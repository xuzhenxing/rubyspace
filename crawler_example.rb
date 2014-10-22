require 'typhoeus' # Typhoeus wraps libcurl in order to make fast and reliable requests. https://github.com/typhoeus/typhoeus
require 'nokogiri' # Nokogiri (鋸) is an HTML, XML, SAX, and Reader parser with XPath and CSS selector support. https://github.com/sparklemotion/nokogiri

request = Typhoeus.get('http://pachong.org/') 

body = request.response_body

doc = Nokogiri::HTML.parse(body)

js = doc.xpath('//head/script[3]').text
js.gsub!('var ', '')
js.split(';').each do |line|
  var_name = line[/.+?=/].sub('=', '')
  var_value = line[/=.+?/].sub('=', '')
  puts "self = #{self}"
  self.instance_variable_set(:"@#{var_name}", var_value.to_i)
  puts "self.instance_variables = #{self.instance_variables}"
end

self.instance_variables.each do |v|
  puts "self.#{v} = #{self.instance_variable_get(v)}"
end

doc.css('table.tb > tbody > tr').each do |result|
  address = result.xpath('td[2]').text
  port_text = result.xpath('td[3]').text[/\(.*\)/] # "((12962^frog)+582)"
  puts "port_text = #{port_text}"
  port_var = port_text[/[a-zA-Z]+/] # "frog"
  puts "port_var = #{port_var}"
  eval_string = port_text.sub("#{port_var}", "@#{port_var}") 
  puts "eval_string = #{eval_string}"
  port = eval(eval_string)
  puts "address = #{address}"
  puts "port = #{port}"
end
