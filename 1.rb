require "typhoeus"
require 'nokogiri' 
require 'sequel'
DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

# for i in 1..40
# 	p i
	request = Typhoeus::Request.new('http://tousu.auto.sohu.com/view/newUserComplaints.ac',
	                                 method: :post,
	                                 params: {
	                                 	'provinceld' => '-1',
	                                 	'cityId' => '-1',
	                                 	'brandId' => '-1',
	                                 	'modelId' => '-1',
	                                 	'orderBy' => 'create_time',
	                                 	'state' => '',
	                                 	'curPage' => 1,
	                                 	'mainProld' => ''
	                                 },
	                                 ).run
	body = request.response_body
	doc = Nokogiri::HTML(body)
	p doc.css('head > title').text.strip
	doc.css('dl.conts').each do |result|
		title = result.css('dt > a').text.strip
		url = result.css('dt > a').attr('href').value
		time_text = result.css('span.info').text.strip.gsub("#{result.css('span.comment').text.strip}",'').gsub(/\n/,'').gsub(/\t/,'').gsub(/\r/,'')
		time = time_text[0,15]
		city = time_text[19,2]
		if time_text[0,2] == '11'
			request = Typhoeus.get(url) 
			body = request.response_body
			js = Nokogiri::HTML.parse(body)
			article = js.css('p.details').text.strip.gsub(/\n/,'').gsub(/\t/,'').gsub(/\r/,'')
			brand = js.css('div.info').xpath('a[1]').text.strip
			model = js.css('div.info').xpath('a[2]').text.strip
		end
		puts "title = #{title}"
		puts "url = #{url}"
		puts "time = #{time}"
		puts "city = #{city}"
		puts "brand = #{brand}"
		puts "model = #{model}"
		puts "article = #{article}"
		puts "------------------"
		sleep(3)
	end
	# sleep(3)
# end