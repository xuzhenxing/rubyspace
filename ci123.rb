require "typhoeus"
require 'nokogiri' 
require 'sequel'
DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

ci123 = DB[:ci123]
# sort 按发帖时间排序        各种话题   页数从0开始，每加一也后面数字加上40
uri = []
for i in 0..9
	i *= 40
	p i
	request = Typhoeus.get("http://bbs.ci123.com/postList/sort/98.html/#{i}") 
	body = request.response_body
	doc = Nokogiri::HTML(body)
	p "http://bbs.ci123.com/postList/sort/98.html/#{i}"
	text = doc.css('head > title').text.strip
	p text
	a = text.split('-')
	type = a[0].strip
	p type
	if type == "提示"
		uri << "http://bbs.ci123.com/postList/sort/98.html/#{i}"
	end

	doc.css('body > div#container > div#rs_posts > table > tbody > tr').each do |result|
		title = result.css('td.post_title > a').text.strip
		url = result.css('td.post_title > a').attr('href').value
		author = result.css('td.post_author > a').text.strip
		reply = result.css('td.post_reply').text.strip
		view = result.css('td.post_visits').text.strip

		request = Typhoeus.get(url) 
		body = request.response_body
		js = Nokogiri::HTML(body)
		head = js.css('head > title').text.strip
		time_text = js.css('body > div#main_post > div#posts_container > div.post > table > tr > td.post_body > div.post_head > div.l').first.text.strip
		article = js.css('body > div#main_post > div#posts_container > div.post > table > tr > td.post_body > div.post_content > div#text_1_0').first.text.strip
		time = time_text.gsub('发表于','').gsub('发送站内信','').strip

		#if time >= "2014-01-01" && time <= "2014-10-22"
			puts "type = #{type}"
			puts "title = #{title}"
			puts "url = #{url}"
			puts "reply = #{reply}"
			puts "view = #{view}"
			puts "author = #{author}"
			puts "head = #{head}"
			puts "time = #{time}"
			puts "article = #{article}"
			ci123.insert(
				:type => type,
				:title => title,
				:url => url,
				:reply => reply,
				:view => view,
				:author => author,
				:time => time,
				:article => article)
			sleep(1)
		#end
	end
	sleep(3)
end
p uri



# 宝宝圈   bid:圈id   page:页数
# request = Typhoeus.get('http://good.ci123.com/app2/quan/index_v2.php?bid=201411&page=2') 
# body = request.response_body
# doc = Nokogiri::HTML(body)
# text = doc.css('head > title').text.strip
# p text
# a = text.split('-')
# type = a[0].strip
# p type

# doc.css('body > div#container > div#rs_posts > div.main > table > tbody > tr').each do |result|
# 	title = result.css('td.post_title > a').text.strip
# 	url = result.css('td.post_title > a').attr('href').value
# 	url = "http://good.ci123.com/app2/quan/#{url}"
# 	author = result.css('td.post_author > a').text.strip
# 	reply = result.css('td.post_reply').text.strip
# 	view = result.css('td.post_visits').text.strip

# 	request = Typhoeus.get(url) 
# 	body = request.response_body
# 	js = Nokogiri::HTML(body)
# 	head = js.css('head > title').text.strip
# 	time_text = js.css('body > div#main_post > div#posts_container > div.post > table > tr > td.post_body > div.post_head > div.l').text.strip
# 	article = js.css('body > div#main_post > div#posts_container > div.post > table > tr > td.post_body > div.post_content > div#pcontent').first.text.strip
# 	time = time_text[/发表于.*【/].gsub('发表于  ','').gsub('【','').strip

# 	puts "trpe = #{type}"
#	puts "title = #{title}"
# 	puts "url = #{url}"
# 	puts "reply = #{reply}"
# 	puts "view = #{view}"
# 	puts "head = #{head}"
# 	puts "time = #{time}"
# 	puts "article = #{article}"
	# ci123.insert(
	# 	:type => type,
	# 	:title => title,
	# 	:url => url,
	# 	:reply => reply,
	# 	:view => view,
	# 	:author => author,
	# 	:time => time,
	# 	:article => article)
# end


# request = Typhoeus.get('http://bbs.ci123.com/post/37289728.html') 
# body = request.response_body
# doc = Nokogiri::HTML(body)
# p doc.css('head > title').text.strip
# #p doc.css('body > div#main_post > div#posts_container > div.post > table > tr').text.strip
# time_text = doc.css('body > div#main_post > div#posts_container > div.post > table > tr > td.post_body > div.post_head > div.l').first.text.strip
# article = doc.css('body > div#main_post > div#posts_container > div.post > table > tr > td.post_body > div.post_content > div#text_1_0').first.text.strip
# time = time_text.gsub('发表于','').gsub('发送站内信','').strip
# puts "time = #{time}"
# puts "article = #{article}"


# request = Typhoeus.get('http://good.ci123.com/app2/quan/post.php?id=4726976') 
# body = request.response_body
# doc = Nokogiri::HTML(body)
# p doc.css('head > title').text.strip
# time_text = doc.css('body > div#main_post > div#posts_container > div.post > table > tr > td.post_body > div.post_head > div.l').text.strip
# article = doc.css('body > div#main_post > div#posts_container > div.post > table > tr > td.post_body > div.post_content > div#pcontent').first.text.strip
# time = time_text[/发表于.*【/].gsub('发表于  ','').gsub('【','').strip
# puts "time = #{time}"
# puts "article = #{article}"