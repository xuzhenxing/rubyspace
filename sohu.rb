require "typhoeus"
require 'nokogiri' 

aFile = File.new("tousu_sohu.txt","a")
       aFile.puts "brand\tmodel\ttitle\ttime\turl\tarticle\n"
aFile.close

a = []
for i in 1..40
	p i
	request = Typhoeus::Request.new('http://tousu.auto.sohu.com/view/newUserComplaints.ac',
	                                 method: :post,
	                                 params: {
	                                 	'provinceld' => '-1',
	                                 	'cityID' => '-1',
	                                 	'brandId' => '-1',
	                                 	'modelId' => '-1',
	                                 	'orderBy' => 'create_time',
	                                 	'state' => '',
	                                 	'curPage' => "#{i}",
	                                 	'mainProld' => ''
	                                 },
	                                 ).run
	body = request.response_body
	doc = Nokogiri::HTML(body)
	if doc.css('head > title').text.strip == "502 Bad Gateway"
		a << i
	else
		doc.css('body > div.cont > div.area > div.left > div.content > div.cont_list > dl').each do |result|	
			#brand = result.xpath('dt[1]/span[1]/a[1]').text.strip
			title = result.xpath('dt[1]/a[1]').text.strip
			url = result.xpath('dt[1]/a[1]').attr('href').value
			time_text = result.xpath('dd[1]/div[1]').text.strip
			time_M = time_text[0,2]
			time_D = time_text[3,2]
			time_h = time_text[10,2]
			time_m = time_text[13,2]
			time = "2014-#{time_M}-#{time_D} #{time_h}:#{time_m}"
			puts "title = #{title}"
			#if time >= "2014-10-01" && time <= "2014-11-01"
			if time_M == '10'
				request = Typhoeus.get(url) 
				body = request.response_body
				js = Nokogiri::HTML.parse(body)
				article = js.css('body > div.cont > div.area >div.left > div.cont_det > div.info_box.info_box_end > p.details').text.strip
				article.gsub!(/\n/,'')
				article.gsub!(/\n\r/,'')
				article.gsub!(/\r/,'')
				js.css('body > div.cont > div.area >div.left > div.cont_det > div.header > div.info').each do |msg|
					brand = msg.xpath('a[1]').text.strip
					model = msg.xpath('a[2]').text.strip
					city = msg.xpath('a[3]').text.strip
					puts "brand = #{brand}"
					puts "model = #{model}"
					puts "time = #{time}"
					aFile = File.new("tousu_sohu.txt","a")
						aFile.puts "#{brand}\t#{model}\t#{title}\t#{time}\t#{url}\t#{article}\n"
					aFile.close
				end
				sleep(3)
			end
			puts "-----------------------------------------------------"
		end
		sleep(3)
	end
end
p a

# time = "2014-10-19 23:16"
# if time > "2014-07-01"&& time <= "2014-11-01"
# 	p 123
# else
# 	p 234
# end