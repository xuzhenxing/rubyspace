require "typhoeus"
require 'nokogiri' 
require 'sequel'
#require 'chronic'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

pcbaby = DB[:pcbaby]
#1914母婴孕育-备孕妈妈  170  1915母婴孕育-怀孕妈妈 310  1948母婴孕育-新手妈妈 750    1988 母婴孕育-早教幼教 500   2190母婴孕育-二胎时代 64
# 1917生活休闲-宝宝秀场 168   2130生活休闲-健康辣妈  175    1828生活休闲-家庭游记 51   1799 生活休闲-晒货殿堂  139   1820 生活休闲-美食分享 120
# 2140 生活休闲-生活百科 76     1771 生活休闲-女人心情 169    1929 生活休闲-免费试用  123    1776 生活休闲-谈天说地 337    2200 生活休闲-数码家庭 25
# 1782 版务论坛-版务专区 30

a = [{:type1 => "母婴孕育-备孕妈妈",:id => 1914,:page => 170},
{:type1 => "母婴孕育-怀孕妈妈",:id => 1915,:page => 310},
{:type1 => "母婴孕育-新手妈妈",:id => 1948,:page => 750},
{:type1 => "母婴孕育-早教幼教",:id => 1988,:page => 500},
{:type1 => "母婴孕育-二胎时代",:id => 2190,:page => 64},
{:type1 => "生活休闲-宝宝秀场",:id => 1917,:page => 168},
{:type1 => "生活休闲-健康辣妈",:id => 2130,:page => 175},
{:type1 => "生活休闲-家庭游记",:id => 1828,:page => 51},
{:type1 => "生活休闲-晒货殿堂",:id => 1799,:page => 139},
{:type1 => "生活休闲-美食分享",:id => 1820,:page => 120},
{:type1 => "生活休闲-生活百科",:id => 2140,:page => 76},
{:type1 => "生活休闲-女人心情",:id => 1771,:page => 169},
{:type1 => "生活休闲-免费试用",:id => 1929,:page => 123},
{:type1 => "生活休闲-谈天说地",:id => 1776,:page => 337},
{:type1 => "生活休闲-数码家庭",:id => 2200,:page => 25},
{:type1 => "版务论坛-版务专区",:id => 1782,:page => 30}]

a.each do |aa|
	p aa
	uri = []
	miss = []
	uri << "http://bbs.pcbaby.com.cn/time_31536000-#{aa[:id]}_postat.html"
	for i in 2..aa[:page]
		uri << "http://bbs.pcbaby.com.cn/time_31536000-#{aa[:id]}-#{i}_postat.html"
	end
	uri.each do |uri|
		p uri
		request = Typhoeus.get(uri) 
		body = request.response_body
		doc = Nokogiri::HTML.parse(body)
		head = doc.css('head > title').text.strip
		p head
		if head != "Error"
			doc.css('body > div.wrap.mainwrap > div.topicList > table.data_table > tbody > tr').each do |result|
				type = result.css('td.title > em > a').text.strip
				if type != ""
					title = result.css('td.title > span > a').text.strip
					a = result.css('td.title > span > a.topicurl').to_s
					url = a[/http.*html/]
					author = result.css('td.author > span > a').text.strip
					time = result.css('td.author > i').text.strip
					reply = result.css('td.reply > i').text
					view = result.css('td.reply > span').text

					if time >= "14-01-01" && time <= "14-10-22"
						#p 123
						request = Typhoeus.get(url)
						body = request.response_body
						js = Nokogiri::HTML.parse(body)
						texts = js.css('head > title').text.strip
						article = js.xpath('//body/div[3]/div[4]/div[1]/div[2]/table/tr[1]/td[1]/div[2]').text.strip.gsub(/\n/,'').gsub(/\t/,'').gsub(/\r/,'')
						puts "type = #{type}"
						puts "title = #{title}"
						puts "author = #{author}"
						puts "time = #{time}"
						puts "reply = #{reply}"
						puts "view = #{view}"
						puts "url = #{url}"
						p texts
						puts "article = #{article}"
						pcbaby.insert(
							:type1 => "#{aa[:type1]}",
							:type => type,
							:title => title,
							:url => url,
							:view => view,
							:reply => reply,
							:author => author,
							:time => time,
							:article => article)
						puts "---------------------------------------------------"
					end
				end
			end
			sleep(3)
		else
			p ">>>>>>>>>>>>>>>>>>>>>>>"
			p uri
			miss << uri
		end
	end
	p miss

	sleep(30)


	begin
		miss.each do |uri|
			p uri
			request = Typhoeus.get(uri) 
			body = request.response_body
			doc = Nokogiri::HTML.parse(body)
			head = doc.css('head > title').text.strip
			p head
			if head != "Error"
				doc.css('body > div.wrap.mainwrap > div.topicList > table.data_table > tbody > tr').each do |result|
					type = result.css('td.title > em > a').text.strip
					if type != ""
						miss.delete("#{uri}")
						title = result.css('td.title > span > a').text.strip
						a = result.css('td.title > span > a.topicurl').to_s
						url = a[/http.*html/]
						author = result.css('td.author > span > a').text.strip
						time = result.css('td.author > i').text.strip
						reply = result.css('td.reply > i').text
						view = result.css('td.reply > span').text

						if time >= "14-01-01" && time <= "14-10-22"
							#p 123
							request = Typhoeus.get(url)
							body = request.response_body
							js = Nokogiri::HTML.parse(body)
							texts = js.css('head > title').text.strip
							article = js.xpath('//body/div[3]/div[4]/div[1]/div[2]/table/tr[1]/td[1]/div[2]').text.strip.gsub(/\n/,'').gsub(/\t/,'').gsub(/\r/,'')
							puts "type = #{type}"
							puts "title = #{title}"
							puts "author = #{author}"
							puts "time = #{time}"
							puts "reply = #{reply}"
							puts "view = #{view}"
							puts "url = #{url}"
							p texts
							puts "article = #{article}"
							pcbaby.insert(
								:type1 => "#{aa[:type1]}",
								:type => type,
								:title => title,
								:url => url,
								:view => view,
								:reply => reply,
								:author => author,
								:time => time,
								:article => article)
							puts "---------------------------------------------------"
						end
					end
				end
			end
			sleep(3)
		end 
	end until miss == []

	sleep(30)
end

# request = Typhoeus.get('http://bbs.pcbaby.com.cn/topic-2079939.html') 
# body = request.response_body
# doc = Nokogiri::HTML.parse(body)
# p doc.css('head > title').text.strip
# p doc.xpath('//body/div[3]/div[4]/div[1]/div[2]/table/tr[1]/td[1]/div[2]').text.strip
