require 'sequel'

DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

# DB.create_table :items do
#   primary_key :id
#   String :name
#   Float :price
# end

items = DB[:items] # Create a dataset

# Populate the table
# items.insert(:name => 'abc', :price => rand * 100)
# items.insert(:name => 'def', :price => rand * 100)
# items.insert(:name => 'ghi', :price => rand * 100)

# Print out the number of records
# puts "Item count: #{items.count}"

# Print out the average price
# puts "The average price is: #{items.avg(:price)}"

items.each do |item|
	p item
end