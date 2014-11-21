require "typhoeus"
require 'nokogiri' 
require 'sequel'
#131
DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

babytree = DB[:babytree]

for i in 1..500
	p "http://www.babytree.com/community/yuer/index_#{i}.html?orderby=create_ts"
	request = Typhoeus.get("http://www.babytree.com/community/yuer/index_#{i}.html?orderby=create_ts") 
	body = request.response_body
	doc = Nokogiri::HTML.parse(body)
	head = doc.css('head > title').text.strip
	p head

	#p doc.xpath('//body/div[2]/div[2]/div[1]/div[1]/div[1]/div[1]/div[1]/div[5]').text.strip
	doc.xpath('//body/div[2]/div[2]/div[1]/div[1]/div[1]/div[1]/div[1]/div[5]/table/tbody/tr').each do |result|
		title = result.css('td.topicTitle > span.topicTitleSelf > a').text.strip
		url = result.css('td.topicTitle > span.topicTitleSelf > a').attr('href').value
		view = result.css('td.topicStat > span.topicViews').text.strip
		reply = result.css('td.topicStat > span.topicReplies').text.strip
		author = result.css('td.topicTime > span.topicAuthor > a').text.strip
		time = result.css('td.topicTime > span.topicAuthor').text.strip[-10,10]

		request = Typhoeus.get(url)
		body = request.response_body
		js = Nokogiri::HTML.parse(body)
		p js.css('head > title').text.strip
		article = js.css('body > div.community > div.community-birthclub > div.community-body-wrapper > div.clubTopicSingle > div.clubTopicList > div.clubTopicSinglePost > div.postBody > div.postContent > p').text.strip
		if article == ""
			article = js.css('body > div.community > div.community-group > div.community-body-wrapper > div.clubTopicSingle > div.clubTopicList > div.clubTopicSinglePost > div.postBody > div.postContent > p').text.strip
		end
		puts "#{i}"
		puts "title = #{title}"
		puts "url = #{url}"
		puts "view = #{view}"
		puts "reply = #{reply}"
		puts "author = #{author}"
		puts "time = #{time}"
		puts "article = #{article}"
		p "--------------------------------------------"
		babytree.insert(
			:club => head.gsub(/_宝宝树/,''),
			:title => title,
			:url => url,
			:view => view,
			:reply => reply,
			:author => author,
			:time => time,
			:article => article)
		sleep(1)
	end
end