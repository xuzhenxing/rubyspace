require "execjs"
require "open-uri"
# source = open("http://coffeescript.org/extras/coffee-script.js").read

# context = ExecJS.compile(source)
# context.call("CoffeeScript.compile", "square = (x) -> x * x", bare: true)

# source = open("http://www.samair.ru/jscnt/357298472.js").read
# p source
# context = ExecJS.compile(source)
# p context
# p context.call('eval','+y+x+y',bare: true)
# context.call('function.compile', 'document.write(":"+w+g)', bare: true)


source = open("http://index.baidu.com/static/js/index_graphic.js?140804").read
#source = source.encode("utf-8", "gbk", :invalid => :replace, :undef => :replace)
context = ExecJS.compile(source)
puts context
# p context.call('eval','+y+x+y',bare: true)