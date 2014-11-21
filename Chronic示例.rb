require 'chronic'

Time.now   #=> Sun Aug 27 23:18:25 PDT 2006

p Chronic.parse('tomorrow')
  #=> Mon Aug 28 12:00:00 PDT 2006

p Chronic.parse('monday', :context => :past)
  #=> Mon Aug 21 12:00:00 PDT 2006

p Chronic.parse('this tuesday 5:00')
  #=> Tue Aug 29 17:00:00 PDT 2006

p Chronic.parse('this tuesday 5:00', :ambiguous_time_range => :none)
  #=> Tue Aug 29 05:00:00 PDT 2006

p Chronic.parse('may 27th', :now => Time.local(2000, 1, 1))
  #=> Sat May 27 12:00:00 PDT 2000

p Chronic.parse('may 27th', :guess => false)
  #=> Sun May 27 00:00:00 PDT 2007..Mon May 28 00:00:00 PDT 2007

p Chronic.parse('6/4/2012', :endian_precedence => :little)
  #=> Fri Apr 06 00:00:00 PDT 2012

p Chronic.parse('INVALID DATE')
  #=> nil