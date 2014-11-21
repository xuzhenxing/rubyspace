require "typhoeus"
require 'nokogiri' 
require 'chronic'
require 'sequel'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database
mama = DB[:mama]

request = Typhoeus.get('http://q.mama.cn/group/4/0-0-1-1/') 
body = request.response_body
doc = Nokogiri::HTML.parse(body)
head = doc.css('head > title').text.strip
p head

doc.css('body > div.content > div.layout > div.layoutLeft > div.quan_tab > div.contentbox.quan_infolist.admin_infolist > div.imgbox').each do |result|
	title = result.css('div.txtArea > dl > dt > a').text.strip
	url = result.css('div.txtArea > dl > dt > a').attr('href').value
	txt = result.xpath('div[2]/dl[1]/dd[1]/div[1]/span[1]').text.strip
	reply,view = txt.split('/')
	author = result.xpath('div[2]/dl[1]/dd[1]/span[1]/a[1]').text.strip

	request = Typhoeus.get(url) 
	body = request.response_body
	js = Nokogiri::HTML.parse(body)
	text = js.css('body > div.content > div.layout > div.quan_news_detail > div.reply_box').first
	article = text.css('div.reply_info > div.news_body > div.re_content > p').text.strip
	time_text = text.xpath('div[2]/div[4]/div[1]/span[1]').text.strip
	time = Chronic.parse(time_text)
	puts "title = #{title}"
	puts "url = #{url}"
	puts "reply = #{reply}"
	puts "view = #{view}"
	puts "author = #{author}"
	puts "time = #{time}"
	puts "article = #{article}"

	mama.insert(
		:title => title,
		:url => url,
		:reply => reply,
		:view => view,
		:author => author,
		:time => time,
		:article => article)
end


# request = Typhoeus.get('http://q.mama.cn/topic/12752974/') 
# body = request.response_body
# doc = Nokogiri::HTML.parse(body)
# head = doc.css('head > title').text.strip
# p head
# # p doc.css('body > div.content > div.layout > div.quan_news_detail > div.reply_box > div.reply_info > div.news_body > div.re_content > p').text.strip
# # p doc.css('body > div.content > div.layout > div.quan_news_detail > div.reply_box > div.reply_info > div.re_func > div.re_from > span').text.strip

# js = doc.css('body > div.content > div.layout > div.quan_news_detail > div.reply_box').first
# p js.css('div.reply_info > div.news_body > div.re_content > p').text.strip
# time_text = js.xpath('div[2]/div[4]/div[1]/span[1]').text.strip
# time = Chronic.parse("#{time_text}")
# p time

# a = "今天 04:21:47"
# p a
# p Chronic.parse(a)

# day = Date.new(今天 04:21:47)
# p day  