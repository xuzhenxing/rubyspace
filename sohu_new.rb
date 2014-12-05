require "typhoeus"
require 'nokogiri' 
require 'chronic'
require 'sequel'
DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database
sohu = DB[:sohu]

for i in 1..40
 	p i
 	begin
		request = Typhoeus::Request.new('http://tousu.auto.sohu.com/view/newUserComplaints.ac',
		                                 method: :post,
		                                 params: {
		                                 	'provinceld' => '-1',
		                                 	'cityId' => '-1',
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
		head = doc.css('head > title').text.strip
		puts "head = #{head}"
		doc.css('dl.conts').each do |result|
			title = result.css('dt > a').text.strip
			url = result.css('dt > a').attr('href').value
			time_text = result.css('span.info').text.strip.gsub("#{result.css('span.comment').text.strip}",'').gsub(/\n/,'').gsub(/\t/,'').gsub(/\r/,'')
			# time = Chronic.parse(time_text[0,15])
			time  = time_text[0,15]
			city = time_text[19,2]
			if time_text[0,2] == '11'
				puts "title = #{title}"
				puts "url = #{url}"
				puts "time = #{time}"
				puts "city = #{city}"
				puts "------------------"
				sohu.insert(
					:title => title,
					:url => url,
					:time => time,
					:city => city)
			end	
		end
	end until head.to_s.include? '搜狐汽车投诉'
	sleep(3)
end


sohu.each do |s|
	p s[:url]
	url = s[:url]
	begin
		request = Typhoeus.get(url) 
		body = request.response_body
		doc = Nokogiri::HTML.parse(body)
		p doc.css('head > title').text.strip
		head = doc.css('head > title').text.strip
		article = doc.css('p.details').text.strip.gsub(/\n/,'').gsub(/\t/,'').gsub(/\r/,'')
		brand = doc.css('div.info').xpath('a[1]').text.strip
		model = doc.css('div.info').xpath('a[2]').text.strip
		p article
		sohu.where(:url => "#{url}").update(:brand => brand,:model => model,:article => article)
	end until head.to_s.include? '搜狐汽车投诉'
	sleep(3)
end
