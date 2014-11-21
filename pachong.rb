require "typhoeus"
require 'nokogiri' 
# require 'sequel'
# DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

# proxy = DB[:proxy]

# request = Typhoeus::Request.get('http://pachong.org/')
# body = request.response_body
# doc = Nokogiri::HTML.parse(body)
# p doc.css('head > title').text.strip
# doc.css('body > div.mainWap > table.tb > tbody > tr').each do |result|
# 	p result.xpath('td[2]').text.strip
# 	p result.xpath('td[3]').text.strip
# 	p result.xpath('td[5]').text.strip
# end


request = Typhoeus.get('http://pachong.org/') 

body = request.response_body

doc = Nokogiri::HTML.parse(body)

js = doc.xpath('//head/script[3]').text
js.gsub!('var ', '')
js.split(';').each do |line|
  var_name = line[/.+?=/].sub('=', '')
  var_value = line[/=.*+?/].sub('=', '')
  var = var_value[/[a-zA-Z]+/]
  if var != nil
    eval_string = var_value.sub("#{var}", "@#{var}") 
  else
    eval_string = var_value
  end
  # puts "self = #{self}"
  self.instance_variable_set(:"@#{var_name}", eval(eval_string))
  # puts "self.instance_variables = #{self.instance_variables}"
end

self.instance_variables.each do |v|
  puts "self.#{v} = #{self.instance_variable_get(v)}"
end

doc.css('table.tb > tbody > tr').each do |result|
  ip = result.xpath('td[2]').text
  port_text = result.xpath('td[3]').text[/\(.*\)/] # "((12962^frog)+582)"
  # puts "port_text = #{port_text}"
  port_var = port_text[/[a-zA-Z]+/] # "frog"
  # puts "port_var = #{port_var}"
  eval_string = port_text.sub("#{port_var}", "@#{port_var}") 
  # puts "eval_string = #{eval_string}"
  port = eval(eval_string)
  # i = 0
  # proxy.each do |p|
  #   if p[:ip] == "#{ip}" && p[:port] == "#{port}"
  #     i = 1
  #   end
  # end
  # if i == 0
  #   puts "ip = #{ip}"
  #   proxy.insert(
  #     :ip => ip,
  #     :port => port,
  #     :type => 'http')
  # end
  puts "ip = #{ip}"
  puts "port = #{port}"
  # proxy.each do |p|
  #   if p[:ip] == "#{ip}" && p[:port] = "#{port}"
  #   else
  #     puts "ip = #{ip}"
  #     puts "port = #{port}"
  #   end
  # end
end