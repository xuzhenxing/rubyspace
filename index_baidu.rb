require "typhoeus"
require 'nokogiri' 

# request = Typhoeus::Request.new('http://index.baidu.com/',
#                          method: :get,
#                          params: {
#                             'tpl' => 'trend',
#                             'word' => '奔跑吧兄弟'
#                          },
#                          headers: {
#                          	'Accept' =>'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
# 		#'Accept-Encoding' =>'gzip, deflate, sdch',
# 		'Accept-Language' =>'zh-CN,zh;q=0.8',
# 		'Connection' =>'keep-alive',
# 		'Cookie' => 'BAIDUID=106B5B695F1DEB8F317C5D88A4894BB4:FG=1; BAIDUPSID=106B5B695F1DEB8F317C5D88A4894BB4; __zpspc=188.2.1417682346.1417682984.2%234%7C%7C%7C%7C%7C%23; CHKFORREG=a3e30dfe0ee36e1e2acb918ba2e18ab8; bdshare_firstime=1417742221219; BDRCVFR[JVKdGst-Mq6]=mk3SLVN4HKm; H_PS_PSSID=10290_1440_9992_10268_10121_10210_10016_10178_9498_9373_10355_9094_10096_10008_10235_10256_9979_9023; Hm_lvt_d101ea4d2a5c67dab98251f0b5de24dc=1417742195; Hm_lpvt_d101ea4d2a5c67dab98251f0b5de24dc=1417744584; BDUSS=hyblNYVENzOElZfkhZWEJPdTJiN1FQWndRdVN-andBUFNKLWZDRmlsRHVuYWhVQVFBQUFBJCQAAAAAAAAAAAEAAABghpQsbG~ArcTI0cUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAO4QgVTuEIFUWD',
# 		'Host' =>'index.baidu.com',
# 		'Referer' =>'http://index.baidu.com/?tpl=trend&word=%B1%BC%C5%DC%B0%C9%D0%D6%B5%DC',
# 		'User-Agent' =>'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/39.0.2171.65 Chrome/39.0.2171.65 Safari/537.36',
#                          }
# 		).run
# body = request.response_body
# body = body.encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
# doc = Nokogiri::HTML.parse(body)
# puts doc.css('head > title').text.strip
# puts doc.css('h4').text.strip
# puts doc.css('a').text.strip
# puts doc.css('div#trend')




request = Typhoeus::Request.new('http://index.baidu.com/',
                         method: :get,
                         params: {
                         	'res' => 'OFsZMW0uHAA/DhwpDBERax8hAEAZXD8HLg0uLwlLfhwSQhMFDBwUOBsaGFEkJAEEQ1hoBxEyXVFxEjMxPBQLRnwwdFxmKA8eODZlIgtCLAFnN04Gdlp7fDc2aCU1CSsBbRFAAyssUnAEJTBYcjN1dHJyDAFIRHVdLwkUDhAHBXAEJyUOAC5YMB1UFzV2Zn9EBBNDYHdzIxUwFnABUidkZ3IzWQIWJhIyCl0LQARXH2JqdjxxLn0zG1UjCDVUcDUXdgBMLwEjKQIXAzN8LjQ1Mi0fYC41KwQDMxI2Nwd+DhQqCw==',
                         	'res2' => '7aEXSTREXSTR4.823hbGMDTeq22VLFlhYbQQWlpHUVYFn9mRlJt245iWF1AsEyeqj417a',
                         	'type' => 0,
                         	'startdate' => '2014-11-05',
                         	'enddate' => '2014-12-04',
                         	'forecast' => 0,
                         	'word' => '奔跑吧兄弟'
                         },
                         headers: {
                         	'Accept' =>'*/*',
		#'Accept-Encoding' =>'gzip, deflate, sdch',
		'Accept-Language' =>'zh-CN,zh;q=0.8',
		'Connection' =>'keep-alive',
		'Cookie' => 'BAIDUID=106B5B695F1DEB8F317C5D88A4894BB4:FG=1; BAIDUPSID=106B5B695F1DEB8F317C5D88A4894BB4; __zpspc=188.2.1417682346.1417682984.2%234%7C%7C%7C%7C%7C%23; CHKFORREG=a3e30dfe0ee36e1e2acb918ba2e18ab8; bdshare_firstime=1417742221219; BDSFRCVID=4FPsJeCCxG0015nxAjmJoG7DD4ww_D1aNa2n3J; H_BDCLCKID_SF=tRk8oItMJCvEDRbN2KTD-tFO5eT22-usJgcTQhcH0hOWsItxDjo_2M_qht6y05bR3nnfLM7gtRjFHDokDUC0-nDSHH-Ht5_j3e; BDUSS=UVIUmRvN1A5NGpIZnpzd0FYV0hzNUZKeFVLVjlKVFVhVWV6T2dRQnMwUTBvcWhVQVFBQUFBJCQAAAAAAAAAAAEAAABghpQsbG~ArcTI0cUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADQVgVQ0FYFUU; BDRCVFR[JVKdGst-Mq6]=mk3SLVN4HKm; BDRCVFR[feWj1Vr5u3D]=I67x6TjHwwYf0; H_PS_PSSID=9008_1440_9992_7801_10268_10212_10121_10210_10016_10178_9498_10065_9770_9373_10355_9094_10096_10008_10235_10256_9979_9023; Hm_lvt_d101ea4d2a5c67dab98251f0b5de24dc=1417742195,1417745298,1417745375; Hm_lpvt_d101ea4d2a5c67dab98251f0b5de24dc=1417760713',
		'Host' =>'index.baidu.com',
		'Referer' =>'http://index.baidu.com/?tpl=trend&word=%B1%BC%C5%DC%B0%C9%D0%D6%B5%DC',
		'User-Agent' =>'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/39.0.2171.65 Chrome/39.0.2171.65 Safari/537.36',
		'X-Requested-With' => 'XMLHttpRequest'
                         }
		).run
body = request.response_body
body = body.encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
doc = Nokogiri::HTML.parse(body)
puts doc


