require "typhoeus"
require 'nokogiri' 
require "oj"
require 'json'


# a = "海尔BCD-186KB,http://detail.tmall.com/item.htm?id=6995577100&_u=8c65nab0f6&areaId=320100&user_id=470168984&is_b=1&cat_id=2&q=BCD-186KB&rn=6389390d7595dc9e0d302b3fe56f3dc0,http://detail.tmall.com/item.htm?id=18385721242&_u=8c65na2121&areaId=320100&user_id=1662144347&is_b=1&cat_id=2&q=BCD-186KB&rn=6389390d7595dc9e0d302b3fe56f3dc0,http://detail.tmall.com/item.htm?id=22260291422&_u=8c65na58be&areaId=320100&user_id=1641036859&is_b=1&cat_id=2&q=BCD-186KB&rn=6389390d7595dc9e0d302b3fe56f3dc0"
# b = a.split(',')
# p b[0]
# b.delete("#{b[0]}")
# p b
url = 'http://rate.tmall.com/list_detail_rate.htm?itemId=6995577100&sellerId=470168984&currentPage=1'
response = Typhoeus.get(url, followlocation: true)
# p response
# items = Oj.load(response.body)["rateDetail"]["rateList"]
# p items
body = response.response_body
body.gsub!(/"rateDetail":/,'')
doc = JSON.parse(body)
#doc = Nokogiri::HTML(body)
#p doc['rateDetail']
#p doc 
#p doc[:rateList]
#p 
doc['rateList'].each do |msg|
	p msg['rateDate']
	p msg['rateContent'].encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
	p msg['auctionSku'].encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
	p msg['displayUserNick'].encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
end
#p doc["rateList"]
# doc['rateList']['appendComment'].each do |msg|
# 	p msg['count']
# end