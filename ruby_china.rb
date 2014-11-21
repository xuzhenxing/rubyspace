require "typhoeus"
require 'nokogiri' 

for i in 1..100
	request = Typhoeus.get("https://ruby-china.org/topics?page=#{i}") 
	body = request.response_body
	doc = Nokogiri::HTML.parse(body)
	doc.css('div.topics > div').each do |result|
		title = result.css('div.title').text.strip
		p title
		aFile = File.new("1.txt","a")
		       aFile.puts "#{title}\t#{i}\n"
		aFile.close
	end
end