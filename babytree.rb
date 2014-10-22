require "typhoeus"
require 'nokogiri' 

request = Typhoeus.get('http://www.babytree.com/community/club201501/?orderby=create_ts') 
body = request.response_body
doc = Nokogiri::HTML.parse(body)
head = doc.css('head > title').text.strip
p head