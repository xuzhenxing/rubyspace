require 'sequel'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

pcbaby = DB[:pcbaby]
#p pcbaby.where(:id => 1)[:id]
article = pcbaby.where(:id => 1)[:id]
# article = article[:article]
p article
p article[:article].encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)



# item = DB[:items]
# # item.each do |item|
# # 	p item[:name]
# # 	item.where(:name => "#{item[:name]}").upadte(:price => "#{item[:price]}+2")
# # end
# for i in 1..3
# price = item.where(:id => "#{i}")[:price]
# price = price[:price] + 20
# item.where(:id => "#{i}").update(:price => "#{price}")
# end