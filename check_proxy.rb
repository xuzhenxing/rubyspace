require 'typhoeus' 
require 'nokogiri' 
require 'sequel'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

class Proxy < Sequel::Model(:proxy)
end

class Site < Sequel::Model
end

check_site_list = Site.all.to_a

Proxy.all.each do |p|
  proxy = "#{p.type}://#{p.ip}:#{p.port}"
  response = Typhoeus::Request.get("www.baidu.com", :proxy => proxy, :timeout => 1)

  p.response_time = response.total_time
  p.is_alive = response.success? && (not response.body.index('030173').nil?) # 查询备案号 确认是不是真正的原网页
  p.last_updated = Time.now
  # p response.body

  if p.is_alive
    p proxy
    check_site_list.each do |site|      
      unless Typhoeus::Request.get(site.url, :proxy => proxy, :timeout => 10).success?
        p site.url
        p.is_alive = false
        break
      end
    end
  end
  p.save
end