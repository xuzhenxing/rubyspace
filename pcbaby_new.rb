require "typhoeus"
require 'nokogiri' 

request = Typhoeus.get('http://bbs.pcbaby.com.cn/time_31536000-1914_postat.html') 
body = request.response_body
doc = Nokogiri::HTML.parse(body)
head = doc.css('head > title').text.strip
puts head
doc.css('tr').each do |result|
	if result.css('td.title > em').text.strip != ""
		puts result.css('td.title > em').text.strip
		puts result.css('td.title > span').text.strip
		puts result.css('td.title > span > a').attr('href').value
		puts result.css('td.author > span > a').text.strip
		puts result.css('td.author > i').text.strip
		puts result.css('td.reply > i').text
		puts result.css('td.reply > span').text
	end
end