require 'typhoeus' 
require 'nokogiri' 
require 'sequel'
#require 'chronic'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

proxy = DB[:proxy]

request = Typhoeus.get('www.proxy.com.ru/') 
body = request.response_body
doc = Nokogiri::HTML.parse(body)
doc.css('tr').each do |result|
  ip = result.xpath('td[2]').text.strip
  port = result.xpath('td[3]').text.strip
  if ip != '' && port != '' && port != '端口'
    #puts "ip = #{ip}"
    #puts "port = #{port}"
    proxy.insert(
    	:ip => "#{ip}",
    	:port => "#{port}",
    	:type => 'http')
  end
end