require "typhoeus"
require 'nokogiri' 

uri = []
a = []
uri << "http://bbs.pcbaby.com.cn/time_15897600-1914_postat.html"
for i in 1..64
	uri << "http://bbs.pcbaby.com.cn/time_15897600-1914-#{i}_postat.html"
end
uri.each do |uri|
	p uri
	request = Typhoeus.get(uri) 
	body = request.response_body
	doc = Nokogiri::HTML.parse(body)
	head = doc.css('head > title').text.strip
	if head != "Error"
		doc.css('body > div.wrap.mainwrap > div.topicList > table.data_table > tbody > tr').each do |result|
			type = result.css('td.title > em > a').text.strip
			if type != ""
				title = result.css('td.title > span > a').text.strip
				a = result.css('td.title > span > a.topicurl').to_s
				url = a[/http.*html/]
				author = result.css('td.author > span > a').text.strip
				time = result.css('td.author > i').text.strip
				reply = result.css('td.reply > i').text
				view = result.css('td.reply > span').text
				request = Typhoeus.get(url)
				body = request.response_body
				js = Nokogiri::HTML.parse(body)
				texts = js.css('head > title').text.strip
				article = js.xpath('//body/div[3]/div[4]/div[1]/div[2]/table/tr[1]/td[1]/div[2]').text.strip
				puts "type = #{type}"
				puts "title = #{title}"
				puts "author = #{author}"
				puts "time = #{time}"
				puts "reply = #{reply}"
				puts "view = #{view}"
				puts "url = #{url}"
				p texts
				puts "article = #{article}"
				puts "---------------------------------------------------"
			end
		end
	else
		a << uri
	end
end

p a

# request = Typhoeus.get('http://bbs.pcbaby.com.cn/topic-2079939.html') 
# body = request.response_body
# doc = Nokogiri::HTML.parse(body)
# p doc.css('head > title').text.strip
# p doc.xpath('//body/div[3]/div[4]/div[1]/div[2]/table/tr[1]/td[1]/div[2]').text.strip