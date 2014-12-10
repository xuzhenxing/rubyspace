require 'typhoeus' 
require 'nokogiri' 
require 'sequel'
#require 'chronic'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

proxy = DB[:proxy]

request = Typhoeus.get('www.xici.net.co') 
body = request.response_body
puts body.encoding
doc = Nokogiri::HTML.parse(body)
puts doc.encoding
doc.css('tr:not(.subtitle)').each do |result|
      ip = result.xpath('td[2]').text.strip
      port = result.xpath('td[3]').text.strip
      type = result.xpath('td[6]').text.strip
      if ip != ''
        puts "ip = #{ip}"
        puts "port = #{port}"
        puts "type = #{type}"
        proxy.insert(
        	:ip => "#{ip}",
        	:port => "#{port}",
        	:type => "#{type}")
      end
end