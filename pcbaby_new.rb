require "typhoeus"
require 'nokogiri' 

request = Typhoeus.get('http://bbs.pcbaby.com.cn/time_31536000-1914_postat.html') 
body = request.response_body
doc = Nokogiri::HTML.parse(body)
head = doc.css('head > title').text.strip
p head
doc.css('tr').each do |result|
	if result.css('td.title > em').text.strip != ""
		p result.css('td.title > em').text.strip
		p result.css('td.title > span').text.strip
		p result.css('td.title > span > a').attr('href').value
		p result.css('td.author > span > a').text.strip
		p result.css('td.author > i').text.strip
		p result.css('td.reply > i').text
		p result.css('td.reply > span').text
	end
end