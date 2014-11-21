require "typhoeus"
require 'nokogiri' 

aFile = File.new("1.txt","a")
       aFile.puts "title\tauthor\turl\treply\tview\ttime\n"
aFile.close


for i in 1..10
	request = Typhoeus.get("http://www.xcar.com.cn/bbs/forumdisplay.php?fid=550&orderby=dateline&page=#{i}") 
	body = request.response_body
	body = body.encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
	doc = Nokogiri::HTML.parse(body)
	head = doc.css('head > title').text.strip
	p head
	js = doc.xpath('//body/div[3]/div[1]')
	js.css('div.Fbox_left > form > div.maintable > div.F_box_1 > table').each do |result|
		title = result.xpath('tr[1]/td[2]/a[1]').text.strip
		if title != ""
			text = result.xpath('tr[1]/td[2]/a[1]').to_s[9,32]
			url = "http://www.xcar.com.cn#{text}"
			author = result.xpath('tr[1]/td[3]/a[1]').text.strip
			time = result.xpath('tr[1]/td[3]/span[1]').text.strip

			if time >= "2014-07-01" && time <= "2014-09-22"

				request = Typhoeus.get(url) 
				body = request.response_body
				body = body.encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
				doc = Nokogiri::HTML.parse(body)
				msg = doc.xpath('//body/div[5]/div[1]/div[1]/div[8]/div[1]/table[1]/tr[1]/td[1]/p[1]').text.strip

				if msg == ""
					msg = doc.xpath('//body/div[5]/div[1]/div[1]/div[9]/div[1]/table[1]/tr[1]/td[1]/p[1]').text.strip
					if msg != ""
						reply,view = msg.split('查看')
						reply = reply.gsub('回复：','').to_i
						view = view.gsub('：','').to_i
					end
				end
				
				puts "title = #{title}"
				puts "url = #{url}"
				puts "author = #{author}"
				puts "time = #{time}"
				puts "reply = #{reply}"
				puts "view = #{view}"
				aFile = File.new("1.txt","a")
					aFile.puts "#{title}\t#{author}\t#{url}\t#{reply}\t#{view}\t#{time}\n"
				aFile.close
			end
		end
	end
end


# request = Typhoeus.get('http://www.xcar.com.cn/bbs/viewthread.php?tid=18662072') 
# body = request.response_body
# body = body.encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
# doc = Nokogiri::HTML.parse(body)
# head = doc.css('head > title').text.strip
# p head
# msg = doc.xpath('//body/div[5]/div[1]/div[1]/div[9]/div[1]/table[1]/tr[1]/td[1]/p[1]').text.strip
# reply,view = msg.split('查看')
# p reply.gsub('回复：','').to_i
# p view.gsub('：','').to_i


# a = doc.xpath('//body/div[5]/div[1]/div[1]/div[8]')
# p a.css('form > div.F_box_2 > table > tbody > tr > td').text.strip
# p doc.xpath('//body/div[5]/div[1]/div[1]/div[8]/form[1]/div[1]/table[1]/tbody[1]').text.strip
# p doc.xpath('//body/div[5]/div[1]/div[1]/div[8]/form[1]/div[1]/table[1]/tr[1]/td[2]/table[1]/tbody[1]/tr[2]').text.strip