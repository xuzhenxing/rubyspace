require "typhoeus"
require 'nokogiri' 
aFile = File.new("1.txt","a")
	aFile.puts "title\tauthor\ttime\turl\treply\tview\n"
aFile.close

for i in 1..20
	request = Typhoeus.get("http://club.autohome.com.cn/bbs/forum-c-281-#{i}.html?orderby=dateline") 
	body = request.response_body
	body = body.encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
	doc = Nokogiri::HTML.parse(body)
	head = doc.css('head > title').text.strip
	p "http://club.autohome.com.cn/bbs/forum-c-281-#{i}.html?orderby=dateline"
	p head
	doc.css('body > div.content > div.carea > div#subcontent > dl.list_dl').each do |result|
		title = result.xpath('dt[1]/a[1]').text.strip
		if title != ""
			text = result.xpath('dt[1]/a[1]').to_s[/bbs.*html/]
			url = "http://club.autohome.com.cn/#{text}"
			author =  result.xpath('dd[1]/a[1]').text.strip
			time = result.xpath('dd[1]/span[1]').text.strip
			if time >= "2014-10-20" && time <= "2014-10-23"
				# p result.xpath('dd[2]/span[1]').text.strip
				# p result.xpath('dd[2]/span[2]').text.strip
				request = Typhoeus.get(url.gsub("thread", "threadowner")) 
				body = request.response_body
				body = body.encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
				js = Nokogiri::HTML.parse(body)
				view = js.css('body > div#topic_detail_main > div#content.clear > div#cont_main.conmain > div#maxwrap-maintopic > div#consnav.consnav > span.fr.fon12 > font#x-views').text
				reply = js.css('body > div#topic_detail_main > div#content.clear > div#cont_main.conmain > div#maxwrap-maintopic > div#consnav.consnav > span.fr.fon12 > font#x-replys').text
				
				puts "title = #{title}"
				#puts "text = #{text}"
				puts "url = #{url}"
				puts "author = #{author}"
				puts "time = #{time}"
				puts "view = #{view}"
				puts "reply = #{reply}"
				aFile = File.new("1.txt","a")
					aFile.puts "#{title}\t#{author}\t#{time}\t#{url}\t#{reply}\t#{view}\n"
				aFile.close
			end
		end
	end
end


# request = Typhoeus.get('http://club.autohome.com.cn/bbs/threadowner-c-281-34661371-1.html') 
# body = request.response_body
# body = body.encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
# doc = Nokogiri::HTML.parse(body)
# head = doc.css('head > title').text.strip
# p head

# p doc.css('body > div#topic_detail_main > div#content.clear > div#cont_main.conmain > div#maxwrap-maintopic > div#consnav.consnav > span.fr.fon12 > font#x-views').text

# p doc.css('body > div#topic_detail_main > div#content.clear > div#cont_main.conmain > div#maxwrap-maintopic > div#consnav.consnav > span.fr.fon12 > font#x-replys').text