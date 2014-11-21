require 'sequel'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

DB.create_table :proxy2 do
  primary_key :id
  String :ip
  String :port
  String :type
  boolean :is_alive
  timestamp :last_updated
end
# DB.create_table :pcbabyyy do
#   primary_key :id
#   String :type1
#   String :type
#   String :title
#   String :url
#   Int :view
#   Int :reply
#   String :author
#   DATETIME :time
#   BLOB :article
# end
# DB.create_table :ci123 do
#   primary_key :id
#   String :type
#   String :title
#   String :url
#   Int :view
#   Int :reply
#   String :author
#   DATETIME :time
#   BLOB :article
# end
# DB.create_table :babytree do
#   primary_key :id
#   VARCHAR :title
#   VARCHAR :url
#   Int :view
#   Int :reply
#   VARCHAR :author
#   DATE :time
#   BLOB :article
# end
# DB.create_table :babytree do
#   primary_key :id
#   String :club
#   String :title
#   String :url
#   Int :view
#   Int :reply
#   String :author
#   DATE :time
#   BLOB :article
# end

# DB.create_table :items do
#   primary_key :id
#   String :name
#   Float :price
# end

# items = DB[:items] # Create a dataset

# # Populate the table
# # items.insert(:name => 'abc', :price => rand * 100)
# # items.insert(:name => 'def', :price => rand * 100)
# # items.insert(:name => 'ghi', :price => rand * 100)

# # Print out the number of records
# # puts "Item count: #{items.count}"

# # Print out the average price
# # puts "The average price is: #{items.avg(:price)}"

# items.each do |item|
# 	p item
# end