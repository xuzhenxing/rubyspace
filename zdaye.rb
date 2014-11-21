require "typhoeus"
require 'nokogiri' 

request = Typhoeus.get('http://ip.zdaye.com/') 

body = request.response_body
body = body.encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
doc = Nokogiri::HTML.parse(body)

p doc.css('head > title').text

doc.css('tr:not(.ctable_head)').each do |result|
	p result.xpath('td[1]').text.strip
	p result.xpath('td[2]').text.strip
	# p result.text
end