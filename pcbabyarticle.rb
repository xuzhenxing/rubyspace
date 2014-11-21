require "typhoeus"
require 'nokogiri' 
require 'sequel'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database
# item = DB[:items]
# item.each do |item|
# 	if item[:name] == "abc"
# 		p item[:price]
# 	end
# end
# item.where(:id => 1).update(:price => 78)
# item.where(:name => 'abc').update(:price => 88)

pcbaby = DB[:pcbaby]
a = []
# pcbaby.each do |msg|
# 	if msg[:article] == ''
# 		#p msg[:url]
# 		a << msg[:url]
# 		# p msg[:id]
# 		# sleep(3)
# 	end
# end
# p a.length
pcbaby.each do |msg|
	if msg[:url] == nil
		p msg[:id]
		p msg[:title]
		a << msg[:id]
	end
end
p a
p a.length
a.each do |a|
	article = "无内容，只有标题"
	pcbaby.where(:id => "#{a}").update(:article => "#{article}")
end


# begin
# 	a.each do |uri|
# 		p uri
# 		request = Typhoeus.get(uri)
# 		body = request.response_body
# 		js = Nokogiri::HTML.parse(body)
# 		texts = js.css('head > title').text.strip
# 		p texts
# 		if texts != "Error"
# 			a.delete("#{uri}")
# 			article = js.xpath('//body/div[3]/div[4]/div[1]/div[2]/table/tr[1]/td[1]/div[2]').text.strip.gsub(/\n/,'').gsub(/\t/,'').gsub(/\r/,'')
# 			if article == ""
# 				article = js.xpath('//body/div[3]/div[4]/div[1]/div[2]/table/tr[1]/td[1]/div[3]').text.strip.gsub(/\n/,'').gsub(/\t/,'').gsub(/\r/,'')
# 				if article == ""
# 					article = "纯图片"
# 				end
# 			end
# 			pcbaby.where(:url => "#{uri}").update(:article => "#{article}")
# 			p article
# 		end
# 	end
# end until a == []

# for i in 1..100
# 	p i
# 	j = a.length
# 	uri = a[j-i]
# 	p uri
# 	request = Typhoeus.get(uri)
# 	body = request.response_body
# 	js = Nokogiri::HTML.parse(body)
# 	texts = js.css('head > title').text.strip
# 	p texts
# 	if texts != "Error" && texts != ""
# 		a.delete("#{uri}")
# 		article = js.xpath('//body/div[3]/div[4]/div[1]/div[2]/table/tr[1]/td[1]/div[2]').text.strip.gsub(/\n/,'').gsub(/\t/,'').gsub(/\r/,'')
# 		if article == ""
# 			article = js.xpath('//body/div[3]/div[4]/div[1]/div[2]/table/tr[1]/td[1]/div[3]').text.strip.gsub(/\n/,'').gsub(/\t/,'').gsub(/\r/,'')
# 			if article == ""
# 				article = "纯图片"
# 			end
# 		end
# 		pcbaby.where(:url => "#{uri}").update(:article => "#{article}")
# 		p uri
# 		p article
# 		p "--------------------------------------------------------------"
# 	end
# 	sleep(3)
# end
