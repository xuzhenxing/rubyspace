require "typhoeus"
require 'nokogiri' 
require 'sequel'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database
yaolan = DB[:yaolan]

# 同龄圈抓取

request = Typhoeus.get('http://bbs.yaolan.com/forumdisplay.php?fid=306&filter=&typeid=0&orderby=dateline&ascdesc=DESC&page=1') 
body = request.response_body
doc = Nokogiri::HTML.parse(body)
head = doc.css('head > title').text.strip
p head
type = doc.css('body > section.waper > div.top_columns > div.top_col_fl > div.date > h1.date_fl > a').text.strip 
doc.css('body > section.waper > section.waper > article.content > div.w_border > div.bbs_box >div.mainbox > form > table > tbody').each do |result|
	title = result.css('tr > td.new > span > a').text.strip
	url_test = result.css('tr > td.new > span > a').attr('href')
	url = "http://bbs.yaolan.com/#{url_test}"
	num = result.css('tr > td.nums').text.strip
	reply,view = num.split('/')
	time_test = result.css('tr > td.author').text.strip
	author = result.css('tr > td.author > a').text.strip
	time = time_test.gsub("#{author}",'').strip

	request = Typhoeus.get(url)
	body = request.response_body
	js = Nokogiri::HTML.parse(body)
	article = js.xpath('//body/div[9]/form[1]/div[2]/div[2]/div[3]/div[1]/p').text.strip

	puts "type = #{type}"
	puts "title = #{title}"
	puts "url = #{url}"
	puts "author = #{author}"
	puts "reply = #{reply}"
	puts "view = #{view}"
	puts "time = #{time}"
	puts "article = #{article}"
	yaolan.insert(
		:type => type,
		:title => title,
		:url => url,
		:author => author,
		:reply => reply,
		:view => view,
		:time => time,
		:article => article)
end


# request = Typhoeus.get('http://bbs.yaolan.com/thread_52576901.aspx') 
# body = request.response_body
# doc = Nokogiri::HTML.parse(body)
# head = doc.css('head > title').text.strip
# p head 
# p doc.xpath('//body/div[9]/form[1]/div[2]/div[2]/div[3]/div[1]/p').text.strip





# 板块抓取

# request = Typhoeus.get('http://bbs.yaolan.com/forumdisplay.php?fid=24&filter=&typeid=0&orderby=dateline&ascdesc=DESC&page=2') 
# body = request.response_body
# doc = Nokogiri::HTML.parse(body)
# head = doc.css('head > title').text.strip
# p head

# doc.css('body > div.bbs_list_mian > div.list_waper > div.list_conarea > div.list_con > div.bd > div.mainbox > form > table > tbody').each do |result|
# 	title = result.css('tr > th.common > span > a').text.strip
# 	#url = result.css('tr > th.common > span > a').attr('href')
# 	if title == ""
# 		title = result.css('tr > th.new > span > a').text.strip
# 		url = result.css('tr > th.new > span > a').attr('href')
# 		url = "http://bbs.yaolan.com#{url}"
# 	else
# 		url = result.css('tr > th.common > span > a').attr('href')
# 		url = "http://bbs.yaolan.com#{url}"
# 	end
# 	num = result.css('tr > td.nums').text
# 	reply,view = num.split('/')
# 	author = result.css('tr > td.author > a').text.strip

# 	request = Typhoeus.get(url)
# 	body = request.response_body
# 	js = Nokogiri::HTML.parse(body)
# 	p js.css('head > title').text.strip
# 	article = js.xpath('//body/div[10]/form[1]/div[2]/div[2]/div[3]/div[1]/p').text.strip
# 	if article == ""
# 		a = doc.xpath('//body/div[10]/form[1]/div[2]/div[2]/div[3]/div[1]').text.strip
# 		b = doc.xpath('//body/div[10]/form[1]/div[2]/div[2]/div[3]/div[1]/div').text.strip
# 		article = a.gsub("#{b}",'').strip
# 	end

# 	puts "title = #{title}"
# 	puts "url = #{url}"
# 	puts "reply = #{reply}"
# 	puts "view = #{view}"
# 	puts "author = #{author}"
# 	puts "article = #{article}"
# end


# request = Typhoeus.get('http://bbs.yaolan.com/thread_52575241.aspx') 
# body = request.response_body
# doc = Nokogiri::HTML.parse(body)
# head = doc.css('head > title').text.strip
# p head 
# #p doc.xpath('//body/div[10]').text.strip
# #p doc.xpath('//body/div[9]/form[1]/div[2]/div[2]/div[3]/div[1]').text.strip
# a = doc.xpath('//body/div[10]/form[1]/div[2]/div[2]/div[3]/div[1]').text.strip
# b = doc.xpath('//body/div[10]/form[1]/div[2]/div[2]/div[3]/div[1]/div[1]').text.strip
# p a.gsub("#{b}",'').strip