require "typhoeus"
require 'nokogiri' 
#pn为页数，值为:50*(page-1)
request = Typhoeus.get("http://tieba.baidu.com/f?kw=厚黑学&ie=utf-8&pn=0") 
body = request.response_body
doc = Nokogiri::HTML.parse(body)
head = doc.css('head > title').text.strip
p head

p doc.css('li#topic_post_thread > div.threadlist_li_left > div.threadlist_rep_num').text
p doc.css('a.th_tit').text
p doc.css('a.th_tit').attr('href').value
doc.css('li.j_thread_list').each do |result|
	p result.css('div.threadlist_rep_num').text
	p result.css('a.j_th_tit').text
	p "http://tieba.baidu.com#{result.css('a.j_th_tit').attr('href').value}"
end

# doc.css('div.threadlist_rep_num').each do |result|
# 	p result.text
# end