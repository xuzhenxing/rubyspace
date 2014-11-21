require 'sequel'
DB = Sequel.connect(:adapter => "mysql2",:database => "test",:host => "localhost",:user => "root",:password => "asd") # memory database

items = DB[:items]
p rand(4)
item = items.where(:id => "#{rand(4)}")
p item[:id][:name]