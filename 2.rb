require "typhoeus"
require 'nokogiri' 
require 'sequel'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

pcbaby = DB[:pcbaby]

for i in 0..9
	p i
	a = []
	pcbaby.each do |msg|
		if msg[:article] == ''
			a << msg[:url]
		end
	end
	p a.length

	begin
		a.each do |uri|
			p uri
			if uri != nil
				request = Typhoeus.get(uri)
				body = request.response_body
				js = Nokogiri::HTML.parse(body)
				texts = js.css('head > title').text.strip
				p texts
				if texts != "Error"
					a.delete("#{uri}")
					article = js.xpath('//body/div[3]/div[4]/div[1]/div[2]/table/tr[1]/td[1]/div[2]').text.strip.gsub(/\n/,'').gsub(/\t/,'').gsub(/\r/,'')
					if article == ""
						article = js.xpath('//body/div[3]/div[4]/div[1]/div[2]/table/tr[1]/td[1]/div[3]').text.strip.gsub(/\n/,'').gsub(/\t/,'').gsub(/\r/,'')
						if article == ""
							article = "纯图片"
						end
					end
					pcbaby.where(:url => "#{uri}").update(:article => "#{article}")
					p article
				end
				sleep(3)
			end

		end
	end until a == []
	sleep(30)
end