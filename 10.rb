require 'sequel'
# require 'typhoeus' 
# require 'nokogiri' 

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

proxy = DB[:proxy2]


proxy.each do |i|
	if i[:is_alive] == false
		id = i[:id]
		proxy.where(:id => "#{id}").delete
	end
end 


# proxy.each do |proxy|
# 	proxy = "#{proxy[:type]}://#{proxy[:ip]}:#{proxy[:port]}"
# 	p proxy
# 	request = Typhoeus::Request.get("www.baidu.com", :proxy => proxy, :timeout => 2)
# 	body = request.response_body
# 	doc = Nokogiri::HTML.parse(body)
# 	p doc.css('head > title').text.strip
# end