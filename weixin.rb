require "typhoeus"
require 'uri'
require 'cgi'
require 'htmlentities'
require 'nokogiri' 
require 'json' 

referer = 'http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MjM5MTI4NDY1Mg==&uin=Mjk1NzMxMzkyMw%3D%3D&amp;key=ac55a43075d889439106015a682ce93f557954be74ba4acad8b988de990f7d973907430fb33555552fa3aaa1c7bb744f&devicetype=android-16&;version=26000036&lang=zh_CN&;pass_ticket=5OZHRAY6X3VnfssOC5e87%2F2yQgKLLMbcfJ6j%2Fx4eZLEDhBD4lMVI8kxDRbLiSjVR#wechat_webview_type=1'
histories = []
a = CGI.unescape("#{referer}")
a = CGI.unescapeHTML("#{a}")
p a
biz = a[/biz=.*uin=/].gsub!(/biz=/,'').gsub!(/&uin=/,'')
uin = a[/uin=.*key=/].gsub!(/uin=/,'').gsub!(/&key=/,'')
key = a[/key=.*&devicetype/].gsub!(/key=/,'').gsub!(/&devicetype/,'')
request = Typhoeus::Request.new('http://mp.weixin.qq.com/mp/getmasssendmsg',
                         method: :get,
                         params: {
                            '__biz' =>"#{biz}",
		'uin' =>"#{uin}",
		'key' =>"#{key}",
		'f' =>'json',
		# 'frommsgid' =>"#{frommsgid}",
		'count' =>"1"
                         },
                         headers: {
                         	'Accept' =>'application/json',
		#'Accept-Encoding' =>'deflate,sdch',
		'Accept-Language' =>'zh-CN,zh;q=0.8',
		'Connection' =>'keep-alive',
		'Host' =>'mp.weixin.qq.com',
		'Referer' =>"#{referer}",
		'User-Agent' =>'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36',
		'X-Requested-With' =>'XMLHttpRequest'
                         }
		).run
body = request.response_body
p request.effective_url
doc = JSON.parse(body)
p doc
    aFile = File.new("2.txt","a")
       aFile.puts "#{doc}"
aFile.close
JSON.parse(doc['general_msg_list'])['list'].each do |article|
	if article.has_key?('app_msg_ext_info')
		content_url = article['app_msg_ext_info']['content_url']
		request = Typhoeus.get("#{content_url}")
		body = request.response_body
		view = Nokogiri::HTML.parse(body)
		#time = view.css('div.rich_media > div.rich_media_inner > div.rich_media_meta_list>em').text
		time = view.css('em').text
		# if time.nil? || time.empty?
		#   next
		# end
		# created_at = Time.parse("#{time}")
		# if created_at >= started_at && created_at <= ended_at
			histories << {
				:title => article['app_msg_ext_info']['title'],
				:content_url => article['app_msg_ext_info']['content_url'],
				#:time => view.css('div.rich_media > div.rich_media_inner > div.rich_media_meta_list>em').text[0,10],
				:time => view.css('em').text[0,10],
				:auther => view.css('div.rich_media_meta_list > a').text.strip,
				#:auther => view.css('em').text[10,view.css('em').text.length],
				:digest => article['app_msg_ext_info']['digest'],
				:text => view.css('div.rich_media_content').text.strip,
			}

			#多图文消息抓取
			msg = article['app_msg_ext_info']
			if msg.has_key?('multi_app_msg_item_list')
				(msg['multi_app_msg_item_list']).each do |ama|
					content_url = ama['content_url']
					request = Typhoeus.get("#{content_url}")
					body = request.response_body
					view = Nokogiri::HTML.parse(body)
					histories << {
						:title => ama['title'],
						:content_url => ama['content_url'],
						:time => view.css('em').text[0,10],
						:auther => view.css('div.rich_media_meta_list > a').text.strip,
						:digest => ama['digest'],
						:text => view.css('div.rich_media_content').text.strip,
					}
				end
			end
		# elsif created_at <= started_at
		# 	return histories 
		# end
	end
end
p histories