require "logger"
require "typhoeus"
require "oj"
require 'json'
require 'sequel'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database
tmall = DB[:tmall]

screen_name = "海尔BCD-186KB,http://detail.tmall.com/item.htm?id=6995577100&_u=8c65nab0f6&areaId=320100&user_id=470168984&is_b=1&cat_id=2&q=BCD-186KB&rn=6389390d7595dc9e0d302b3fe56f3dc0,http://detail.tmall.com/item.htm?id=18385721242&_u=8c65na2121&areaId=320100&user_id=1662144347&is_b=1&cat_id=2&q=BCD-186KB&rn=6389390d7595dc9e0d302b3fe56f3dc0,http://detail.tmall.com/item.htm?id=22260291422&_u=8c65na58be&areaId=320100&user_id=1641036859&is_b=1&cat_id=2&q=BCD-186KB&rn=6389390d7595dc9e0d302b3fe56f3dc0
海尔BCD-579WE,http://detail.tmall.com/item.htm?id=19745961305&_u=8c65na95a3&areaId=320100&user_id=1705232246&is_b=1&cat_id=2&q=BCD-579WE&rn=887be0b4ddef86f5bfe6bb5ce88b0a84,,
海尔BCD-539WT,http://detail.tmall.com/item.htm?id=8305708536&_u=8c65naa7cd&areaId=320100&user_id=470168984&is_b=1&cat_id=50918004&q=BCD-539WT&rn=b76cc47592528596d6462bb5d6639ec5,,
海尔BCD-206STPA,http://detail.tmall.com/item.htm?id=19842770800&_u=8c65nac534&areaId=320100&user_id=470168984&is_b=1&cat_id=2&q=BCD-206STPA&rn=7e61682a7ed1a70e128f6042b174ebdc,http://detail.tmall.com/item.htm?id=36163063590&_u=8c65na3444&areaId=320100&user_id=1641036859&is_b=1&cat_id=2&q=BCD-206STPA&rn=7e61682a7ed1a70e128f6042b174ebdc,
海尔BCD-206TASJX,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.5.cZty9Z&id=35343164934&_u=8c65naa4af&areaId=320100&user_id=1662144347&is_b=1&cat_id=2&q=BCD-206TASJX&rn=03561b5f2071df84b3a3bed8f2ff87f3,,
海尔BCD-225SLDA,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.DjBg2P&id=17698337200&_u=8c65na0cb2&areaId=320100&user_id=470168984&is_b=1&cat_id=2&q=BCD-225SLDA&rn=7b6f66a03de99128d09adebbc04df295,,
海尔BCD-225SCZM,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.h9y06x&id=19782866175&_u=8c65na498d&areaId=320100&user_id=470168984&is_b=1&cat_id=2&q=BCD-225SCZM&rn=c2b6e4a31e8ae41258567489fa66e8cd,,
海尔BCD-225SFM,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.qhbyG7&id=18505636885&_u=8c65naa15f&areaId=320100&user_id=470168984&is_b=1&cat_id=2&q=BCD-225SFM&rn=365e817608d8059dd412958767673759,,
海尔BCD-206SM,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.jJoiBl&id=18446459925&_u=8c65nab472&areaId=320100&user_id=470168984&is_b=1&cat_id=2&q=BCD-206SM&rn=756c8db62bce772e12c20204fbe3a980,,
海尔BCD-215SEBB,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.7.AEsJla&id=20164541035&_u=8c65naa464&areaId=320100&user_id=470168984&is_b=1&cat_id=2&q=BCD-215SEBB&rn=d8c14d0ad18bce1f5bc779b50fb4b84f,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.13.AEsJla&id=35431747406&_u=8c65na179f&areaId=320100&user_id=1662144347&is_b=1&cat_id=2&q=BCD-215SEBB&rn=d8c14d0ad18bce1f5bc779b50fb4b84f,
海尔BCD-339WBA,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.A7Tnwc&id=27193000655&_u=8c65naf0de&areaId=320100&user_id=1085181034&is_b=1&cat_id=2&q=BCD-339WBA&rn=f89522832d9ac0d432b68e5df5fd284d,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.6.A7Tnwc&id=37961269095&_u=8c65na8ce6&areaId=320100&user_id=1662144347&is_b=1&cat_id=2&q=BCD-339WBA&rn=f89522832d9ac0d432b68e5df5fd284d,
海尔BCD-196TMPI,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.7.ktNMh5&id=35285252690&_u=8c65na8649&areaId=320100&user_id=470168984&is_b=1&cat_id=2&q=BCD-196TMPI&rn=8bb8ca512a9825d23ef9f22a60cea217,,
海尔BCD-133EN,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.DKOKvf&id=27041704260&_u=8c65naedd7&areaId=320100&user_id=1705232246&is_b=1&cat_id=2&q=BCD-133EN&rn=ec4d379fac5cc5f452da0ddb0222a904,,
海尔BCD-649WE,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.11.skybe5&id=22418947917&_u=8c65na34b1&areaId=320100&user_id=1662144347&is_b=1&cat_id=2&q=BCD-649WE&rn=8d6af9197fbf7ec7486eb9b492ed104d,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.skybe5&id=27107244227&_u=8c65na1fde&areaId=320100&user_id=1085181034&is_b=1&cat_id=2&q=BCD-649WE&rn=8d6af9197fbf7ec7486eb9b492ed104d,
容声BCD-202M/TX6-GF61-C,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.11.MyoGSb&id=20728127197&_u=8c65nac8dd&areaId=320100&user_id=1639933436&is_b=1&cat_id=2&q=BCD-202M%2FTX6-GF61-C&rn=e666fc1b49886dcae1f7432b7561e3e7,,
容声BCD-180E/DS-K61,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.Qn0ir5&id=21622131711&_u=8c65na6812&areaId=320100&user_id=1703350805&is_b=1&cat_id=2&q=BCD-180E%2FDS-K61&rn=c7149c0b193236ce9fe81b557a20ebe9,,
容声BCD-137G,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.30.R30hXy&id=19320521094&_u=8c65nad9d4&areaId=320100&user_id=883999789&is_b=1&cat_id=2&q=BCD-137G&rn=ddbe9b2d3f84e60024f8df6a6e99a973,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.24.R30hXy&id=27335276129&_u=8c65na1784&areaId=320100&user_id=1770526498&is_b=1&cat_id=2&q=BCD-137G&rn=ddbe9b2d3f84e60024f8df6a6e99a973,
容声BCD-202M/TX6,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.hjJAYX&id=15678411879&_u=8c65naf802&areaId=320100&user_id=883999789&is_b=1&cat_id=2&q=BCD-202M%2FTX6&rn=769faf38d89d3b14e0f7c16780668174,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.7.hjJAYX&id=20114902268&_u=8c65nabb6c&areaId=320100&user_id=1770526498&is_b=1&cat_id=2&q=BCD-202M%2FTX6&rn=769faf38d89d3b14e0f7c16780668174,
容声BCD-201MB/DS,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.ar9AUf&id=19758014656&_u=8c65na03dd&areaId=320100&user_id=883999789&is_b=1&cat_id=2&q=BCD-201MB%2FDS&rn=6f10437f938287a10b0fb7bf0ea24f9b,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.6.ar9AUf&id=22414659524&_u=8c65na7425&areaId=320100&user_id=1770526498&is_b=1&cat_id=2&q=BCD-201MB%2FDS&rn=6f10437f938287a10b0fb7bf0ea24f9b,
容声BCD-211YM/T,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.w0A4MG&id=25043932505&_u=8c65na08fd&areaId=320100&user_id=883999789&is_b=1&cat_id=2&q=BCD-211YM%2FT&rn=2c64bd6e9e2f27c43ef76d2e4e4381e1,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.6.w0A4MG&id=20161985143&_u=8c65na3a45&areaId=320100&user_id=1770526498&is_b=1&cat_id=2&q=BCD-211YM%2FT&rn=2c64bd6e9e2f27c43ef76d2e4e4381e1,
容声BCD-563WY-C,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.RkTFVc&id=24176620659&_u=8c65naf616&areaId=320100&user_id=1662144347&is_b=1&cat_id=2&q=BCD-563WY-C&rn=d1cdb3ae5b137a71ec10ab939ae9bbe5,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.12.RkTFVc&id=15796615834&_u=8c65na5eca&areaId=320100&user_id=883999789&is_b=1&cat_id=2&q=BCD-563WY-C&rn=d1cdb3ae5b137a71ec10ab939ae9bbe5,
容声BCD-167E/DS-K61 ,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.RMwGx9&id=37610140132&_u=8c65na9cdb&areaId=320100&user_id=1917338680&is_b=1&cat_id=2&q=BCD-167E%2FDS-K61%3F&rn=ceff8a1e3723a9ddea84f2eb8e08cb48,,
美菱BCD-206L3CT,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.ReKJ7Q&id=14698749394&_u=8c65na684f&areaId=320100&user_id=377476427&is_b=1&cat_id=2&q=BCD-206L3CT&rn=5a0fd1767c720560821054e63f283c0f,,
美菱BCD-181MLC,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.HtxWiF&id=13362615458&_u=8c65nac1b0&areaId=320100&user_id=377476427&is_b=1&cat_id=2&q=BCD-181MLC&rn=4fa97fb6d75957608dd05ba7ab2a6854,,
美菱BCD-221CHC,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.C1LV6r&id=4520399710&_u=8c65nadf70&areaId=320100&user_id=377476427&is_b=1&cat_id=2&q=BCD-221CHC&rn=adc26a611d57c40e234efc46b6f4057c,,
海信BCD-562WT,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.13.fh8SXA&id=15935131315&_u=8c65na61d2&areaId=320100&user_id=407840604&is_b=1&cat_id=2&q=BCD-562WT&rn=504ff7831c8d4866eeaf226e8932819c,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.19.fh8SXA&id=19397105992&_u=8c65na0815&areaId=320100&user_id=1055977456&is_b=1&cat_id=2&q=BCD-562WT&rn=504ff7831c8d4866eeaf226e8932819c,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.fh8SXA&id=18387353221&_u=8c65nabdc9&areaId=320100&user_id=1662144347&is_b=1&cat_id=2&q=BCD-562WT&rn=504ff7831c8d4866eeaf226e8932819c
海信BCD-211DG/E,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.42.zQNktv&id=35192276354&_u=8c65nab804&areaId=320100&user_id=1763615626&is_b=1&cat_id=2&q=BCD-211DG%2FE&rn=d14eb72b3a892eedd1df9ee1ae86d27c,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.83.zQNktv&id=21407167573&_u=8c65nacd44&areaId=320100&user_id=407840604&is_b=1&cat_id=2&q=BCD-211DG%2FE&rn=d14eb72b3a892eedd1df9ee1ae86d27c,
海信BC-90S,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.JHMriR&id=19299971790&_u=8c65na9bb2&areaId=320100&user_id=407840604&is_b=1&cat_id=2&q=BC-90S&rn=3519f0d11fe2933a95faa9fdfc7379db,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.83.JHMriR&id=23491720971&_u=8c65na92b4&areaId=320100&user_id=1055977456&is_b=1&cat_id=2&q=BC-90S&rn=3519f0d11fe2933a95faa9fdfc7379db,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.7.JHMriR&id=35192312327&_u=8c65na6c32&areaId=320100&user_id=1763615626&is_b=1&cat_id=2&q=BC-90S&rn=3519f0d11fe2933a95faa9fdfc7379db
奥马BCD-118A3,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.JsC3A6&id=18581234449&_u=8c65na1032&areaId=320100&user_id=1662144347&is_b=1&cat_id=2&q=BCD-118A3&rn=d85ab839ff0d89f43e890abd6eb7d595,,
奥马BCD-176A7,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.WkO70e&id=15196368810&_u=8c65na53c0&areaId=320100&user_id=698644807&is_b=1&cat_id=2&q=BCD-176A7&rn=3a0cfc0d6ef7d9a251e15de164e31d2a,,
奥马BCD-145A5,http://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.1.p5uuHm&id=18581250199&_u=8c65nab4f9&areaId=320100&user_id=1662144347&is_b=1&cat_id=2&q=BCD-145A5&rn=bc077a69adf6e558c58940f7c051548c,,"
comments = []
puts screen_name
screen_name.each_line.map do |line|
	a = line.split(',')
	name =a[0]
	brand = name[0,2]
	model = name.gsub("#{brand}",'')
	a.delete("#{a[0]}")
	a.each do |url|
		p url
		tag_list = []
		response = Typhoeus.get(url, followlocation: true)
		@itemid = url[/id=(\d+)/, 1].to_i
		@userid = url[/user_id=(\d+)/, 1].to_i

		# 取得评论tag数目
		response = Typhoeus.get("http://rate.tmall.com/listTagClouds.htm?isAll=true&itemId=#{@itemid}", followlocation: true)
		body = response.response_body
		body.gsub!(/"tags":/,'')
		doc = JSON.parse(body)
		doc['tagClouds'].each do |msg|
			id = msg['id']
			count = msg['count']
			posi = msg['posi']
			tag = msg['tag'].encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
			tag_list << 
			{
				:id => id,
				:tag => tag,
				:posi => posi,
				:count => count
			}
		end
		p tag_list
		# tag_list.each do |t|
		# 	if t[:posi] == false
		# 		p t
		# 	end
		# end

		tag_list.each do |t|
			p t
			if t[:posi] == false
				posi = -1
			else
				posi = ''
			end
			for currentPage in 1..1000
				url = "http://rate.tmall.com/list_detail_rate.htm?itemId=#{@itemid}&sellerId=#{@userid}&currentPage=#{currentPage}&tagId=#{t[:id]}&posi=#{posi}"
				p url
				response = Typhoeus.get("#{url}", followlocation: true)
				body = response.response_body
				body.gsub!(/"rateDetail":/,'')
				doc = JSON.parse(body)
				lastPage = doc['paginator']['lastPage']
				page = doc['paginator']['page']
				p lastPage
				p page
				p name
				doc['rateList'].each do |msg|
					# p msg['rateContent'].encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
					# p t[:tag]
					# p msg['rateDate']
					tmall.insert(
						:brand => brand,
						:model => model,
						:tag => t[:tag],
						:comment => msg['rateContent'].encode("utf-8", "gbk", :invalid => :replace, :undef => :replace).gsub('<b>','').gsub('</b>',''),
						:date => msg['rateDate'])
				end
				if lastPage == page
					break
				end
				sleep(3)
			end
		end
	end
end