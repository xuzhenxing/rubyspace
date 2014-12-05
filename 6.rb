require "typhoeus"
require 'nokogiri' 
require 'sequel'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

DB.create_table :tmall do
  primary_key :id
  String :brand
  String :model
  String :tag
  String :tag_article
  Datetime :date
end
# pcbaby = DB[:pcbaby]

# # pcbaby.each do |pcbaby|
# # 	if pcbaby[:title] == "孕妇身体乳液哪种好用？"
# # 		p pcbaby[:id]
# # 	end
# # end

# #验证是否有重复的条目
# pcbaby.each do |a|
# 	pcbaby.each do |b|
# 		if a[:url] == b[:url] && a[:id] != b[:id]
# 			p a[:id]
# 			p b[:id]
# 		end
# 	end
# end

items = DB[:items]
items.each do |a|
	items.each do |b|
		if a[:name] == b[:name] && a[:id] != b[:id]
			id = b[:id]
			items.where(:id => "#{id}").delete
		end
	end
end