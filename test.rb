require 'typhoeus' 
require 'nokogiri' 
require 'sequel'
#require 'chronic'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

proxy = DB[:proxy]

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
  puts "self = #{self}"
  self.instance_variable_set(:"@#{var_name}", eval(eval_string))
  puts "self.instance_variables = #{self.instance_variables}"
end

self.instance_variables.each do |v|
  puts "self.#{v} = #{self.instance_variable_get(v)}"
end

doc.css('table.tb > tbody > tr').each do |result|

    ip = result.xpath('td[2]').text
    port_text = result.xpath('td[3]').text[/\(.*\)/]
    port_var = port_text[/[a-zA-Z]+/] # "frog"
    #puts "port_var = #{port_var}"
    eval_string = port_text.sub("#{port_var}", "@#{port_var}") 
    #puts "eval_string = #{eval_string}"
    port = eval(eval_string)
    puts "ip = #{ip}"
    puts "port = #{port}"
    proxy.insert(
      :ip => "#{ip}",
      :port => "#{port}",
      :type => 'http')
  end


# dog=1555+8670
# ant=1584+4886^dog
# seal=3586+7407^ant
# duck=4398+2455^seal
# hen=804+952^duck

# p dog
# p ant
# p seal
# p duck
# p hen