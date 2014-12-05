# require 'chronic'
# a = '11月26日    18:08'
# # p Time.parse("#{a}")

# p Chronic.parse(a)

# name ='海尔BCD-186KB'
# brand = name[0,2]
# model = name.gsub("#{brand}",'')
# p brand
# p model

a = '物流真是神速啊，下单10个小时就收到了，宝贝不错，<b>客服元芳服务很好</b>'
p a.gsub('<b>','')