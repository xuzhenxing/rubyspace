require "logger"
require "typhoeus"
require "oj"
require 'json'


screen_name = "海尔BCD-186KB,http://detail.tmall.com/item.htm?id=6995577100&_u=8c65nab0f6&areaId=320100&user_id=470168984&is_b=1&cat_id=2&q=BCD-186KB&rn=6389390d7595dc9e0d302b3fe56f3dc0,http://detail.tmall.com/item.htm?id=18385721242&_u=8c65na2121&areaId=320100&user_id=1662144347&is_b=1&cat_id=2&q=BCD-186KB&rn=6389390d7595dc9e0d302b3fe56f3dc0,http://detail.tmall.com/item.htm?id=22260291422&_u=8c65na58be&areaId=320100&user_id=1641036859&is_b=1&cat_id=2&q=BCD-186KB&rn=6389390d7595dc9e0d302b3fe56f3dc0"
comments = []
puts screen_name
#while true
	fetch_list = []
	screen_name.each_line.map do |line|
		a = line.split(',')
		name =a[0]
		a.delete("#{a[0]}")
		a.each do |url|
			response = Typhoeus.get(url, followlocation: true)
			id = url[/id=(\d+)/, 1].to_i
			user_id = url[/user_id=(\d+)/, 1].to_i

			# 取得评论数目
			response = Typhoeus.get("http://dsr.rate.tmall.com/list_dsr_info.htm?itemId=#{id}", followlocation: true)
			num_comment = response.body[/"rateTotal":(\d+)/, 1].to_i
			fetch_list << 
			{
				:id => id,
				:user_id => user_id,
				:pages => (num_comment / 20.0).ceil,
				:name => name.gsub('/', '--')
			}
		end
	end
	p fetch_list
	fetch_list.each do |data|
		p data[:pages]
	end

	# 取得评论内容
	fetch_list.each do |data|
		#(0..data[:pages]).each do |i|
			url = "http://rate.tmall.com/list_detail_rate.htm?itemId=#{data[:id]}&sellerId=#{data[:user_id]}&currentPage=1"
			response = Typhoeus.get(url, followlocation: true)
			
			body = response.response_body
			body.gsub!(/"rateDetail":/,'')
			doc = JSON.parse(body)
			doc['rateList'].each do |msg|
				p msg['rateDate']
				#p msg['rateContent'].encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
				#p msg['auctionSku'].encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
				#p msg['displayUserNick'].encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
				#created_at = Time.parse("#{msg['rateDate']}")
				#if created_at >= Time.parse("2014-09-19") && created_at <= Time.parse("2014-10-19")
					comments << {
						:name => data[:name],
						:id => data[:id],
						:buyer => msg['displayUserNick'].encode("utf-8", "gbk", :invalid => :replace, :undef => :replace),
						:date => msg['rateDate'],
						:deal => msg['auctionSku'].encode("utf-8", "gbk", :invalid => :replace, :undef => :replace),
						:text => msg['rateContent'].encode("utf-8", "gbk", :invalid => :replace, :undef => :replace),
					}
				#elsif created_at <= Time.parse("2014-09-19")
					#break
					#return comments
				#end
				#p comments
			end
			p comments
			sleep(3)
		#end
	end

	sleep(20)
	p comments
#end



