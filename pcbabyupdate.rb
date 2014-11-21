require "typhoeus"
require 'nokogiri' 
require 'sequel'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

pcbaby = DB[:pcbaby]


a = [{:type1 => "母婴孕育-备孕妈妈",:id => 1914,:page => 10},
{:type1 => "母婴孕育-怀孕妈妈",:id => 1915,:page => 5},
{:type1 => "母婴孕育-新手妈妈",:id => 1948,:page => 30},
{:type1 => "母婴孕育-早教幼教",:id => 1988,:page => 8},
{:type1 => "母婴孕育-二胎时代",:id => 2190,:page => 2},
{:type1 => "生活休闲-宝宝秀场",:id => 1917,:page => 3},
{:type1 => "生活休闲-健康辣妈",:id => 2130,:page => 8},
{:type1 => "生活休闲-家庭游记",:id => 1828,:page => 1},
{:type1 => "生活休闲-晒货殿堂",:id => 1799,:page => 4},
{:type1 => "生活休闲-美食分享",:id => 1820,:page => 3},
{:type1 => "生活休闲-生活百科",:id => 2140,:page => 4},
{:type1 => "生活休闲-女人心情",:id => 1771,:page => 14},
{:type1 => "生活休闲-免费试用",:id => 1929,:page => 4},
{:type1 => "生活休闲-谈天说地",:id => 1776,:page => 10},
{:type1 => "生活休闲-数码家庭",:id => 2200,:page => 2},
{:type1 => "版务论坛-版务专区",:id => 1782,:page => 1}]

a.each do |aa|
	p aa
	uri = []
	miss = []
	uri << "http://bbs.pcbaby.com.cn/time_604800-#{aa[:id]}_postat.html"
	if aa[:page] >= 2
		for i in 2..aa[:page]
			uri << "http://bbs.pcbaby.com.cn/time_604800-#{aa[:id]}-#{i}_postat.html"
		end
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

					if time >= "14-11-14" && time <= "14-11-17"
						#p 123
						sleep(1)
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

						if time >= "14-11-14" && time <= "14-11-17"
							sleep(1)
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

	sleep(10)
end