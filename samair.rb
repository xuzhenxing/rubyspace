require "typhoeus"
require 'nokogiri' 
require "execjs"
require "open-uri"

request = Typhoeus.get('http://www.samair.ru/proxy-by-country/China-01.htm')
body = request.response_body
doc = Nokogiri::HTML.parse(body)

url = "http://www.samair.ru#{doc.css('head > script').attr('src').value}"
source = open(url).read
context = ExecJS.compile(source)

doc.css('tr').each do |result|
  proxy_txt = result.xpath('td[1]').text.strip
  if proxy_txt.to_s.include? "document"
    ip = proxy_txt[/.*document/].gsub('document','')
    port_txt = proxy_txt[/\(.*\)/].gsub('(','').gsub(')','')
    port = context.call('eval',port_txt,bare: true).gsub(':','').to_i
    puts "ip = #{ip}"
    puts "port = #{port}"
  end
end


# request = Typhoeus.get('http://www.samair.ru/jscnt/478770668.js')
# body = request.response_body
# doc = Nokogiri::HTML.parse(body)
# p doc.css('head > title').text.strip
