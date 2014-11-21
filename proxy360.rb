require 'typhoeus' 
require 'nokogiri' 
require 'sequel'
#require 'chronic'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

proxy = DB[:proxy2]

request = Typhoeus.get('www.proxy360.cn/default.aspx') 
body = request.response_body
doc = Nokogiri::HTML.parse(body)
p doc.css('head > title').text.strip
doc.css('div.proxylistitem').each do |result|
  ip = result.xpath('div[1]/span[1]').text.strip
  port = result.xpath('div[1]/span[2]').text.strip
  # type = result.xpath('div[1]/span').text.strip
  puts "ip = #{ip}"
  puts "port = #{port}"
  # puts "type = #{type}"
  proxy.insert(
  	:ip => "#{ip}",
  	:port => "#{port}",
  	:type => 'http')
end