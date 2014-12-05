#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# 2013-09
#
# ruby 2.0 , 1.9.3
# jruby 1.7.4 (1.9.3p392) 2013-05-16 2390d3b on Java HotSpot(TM) Client VM 1.7.0_07-b10 [Windows 7-x86]
 
#需要安装 gem install ffi
#参考 : https://github.com/ffi/ffi/wiki/Basic-Usage
#       http://www.oschina.net/code/snippet_98523_3455
#
 
require 'rubygems'
require 'ffi'
 
module G
  extend FFI::Library
  ffi_lib 'gdi32'
  ffi_convention :stdcall
  attach_function :GetPixel, :GetPixel,[ :int , :int, :int], :int
  attach_function :SetPixel, :SetPixel,[ :int , :int, :int, :int ], :int
  ffi_lib 'user32'
  attach_function :GetDC, :GetDC ,[ :int ], :long
  attach_function :InvalidateRect, :InvalidateRect,[ :int,:long,:bool], :bool
  attach_function :ReleaseDC, :ReleaseDC,[ :long,:int ], :int
end
include G
 
class Snow
  SnowNum = 600 #同一时间飘动的雪花数量
  ScrnWidth = 1280 #屏幕宽度(单位:像素)
  ScrnHight = 1024 #屏幕高度(单位:像素)
  SnowColDown = 0xFFFFFF #积雪颜色
  SnowColDuck = 0xFFDDDD #深色积雪颜色
  SnowCol = 0xFEFfFE #雪花颜色
 
  def initialize
    print "\r ctrl + c = exit"
    @hDC1 = GetDC(0)
    #初始化整个屏幕
    @vx=0
    @vy=0
    @px=[]
    @py=[]
    @pColor=[]
    SnowNum.times{|j|
      @px[j] = rand * ScrnWidth
      @py[j] = rand * ScrnHight / 1.5
      @pColor[j] = GetPixel(@hDC1, @px[j], @py[j])
    }
  end
 
  def timerStart
 
    Thread.new do
      loop do
        #改变风向
        @vx = rand * 4 - 2
        @vy = rand + 2     
        sleep 1.3
      end
    end
 
    loop do
      #画出一帧
      draw
      sleep 0.002
    end
 
  end
 
  #初始化雪花位置
  def initP(i)
    @px[i] = rand * ScrnWidth
    @py[i] = rand * 3
    @pColor[i] = GetPixel(@hDC1, @px[i], @py[i]) #取得屏幕原来的颜色值
  end
 
  #画出一帧，即重画所有雪花位置一次
  def draw
    SnowNum.times{|i|
      if @pColor[i] != SnowCol
        #还原上一个位置的颜色
        SetPixel @hDC1, @px[i],@py[i], @pColor[i]
      end
      #设置新的位置，i Mod 3用于将雪花分为三类采用不同速度，以便形成层次感
      @pvx = rand * 2 - 1 + @vx * (i%3)
      @pvy = @vy * (i%3+1)
      @px[i] += @pvx
      @py[i] += @pvy
 
      #取得新位置原始颜色值，用于下一步雪花飘过时恢复此处颜色
      @pColor[i] = GetPixel(@hDC1,@px[i],@py[i])
 
      #如果获取颜色失败，表明雪花已飘出屏幕，重新初始化
      if @pColor[i] == 0xFFFFFFFF or @pColor[i] == -1
        initP i
      else
        #否则若雪花没有重叠
        if @pColor[i] != SnowCol
          #若对比度较小(即不能堆积),就画出雪花
          #Rnd()>0.3用于防止某些连续而明显的边界截获所有雪花
          if rand > 0.3 or getContrast(i) < 50
            SetPixel @hDC1,@px[i],@py[i], SnowCol
            #否则表明找到明显的边界，画出堆积的雪，并初始化以便画新的雪花
          else
            SetPixel @hDC1,@px[i],@py[i] - 1, SnowColDuck
            SetPixel @hDC1,@px[i] - 1,@py[i], SnowColDuck
            SetPixel @hDC1,@px[i] + 1,@py[i], SnowColDown
            initP i
          end
        end
      end
    }
  end
 
  #取得某一点与周围点的对比度，确定是否在此位置堆积雪花
  def getContrast(i)
    #colorCmp = 0 #存储用作对比的点的颜色值
    #tempR = 0 #存储CorlorCmp的红色部分，下同
    #tempG = 0
    #tempB = 0
    #slope=0  #存储雪花飘落方向:Vx/Vy
 
    #计算雪花飘落方向
    if @pvy != 0
      slope = @pvx / @pvy
    else
      slope = 2
    end
    #根据雪花飘落方向决定取哪一点作对比点，
    #若PVx/PVy在-1到1之间，即Slope=0，就取正下面的象素点
    #若PVx/PVy>1，取右下方的点，PVx/PVy<-1则取左下方
    if slope == 0
      colorCmp = GetPixel(@hDC1, @px[i], @py[i] + 1)
    elsif slope > 1
      colorCmp = GetPixel(@hDC1, @px[i] + 1, @py[i] + 1)
    else
      colorCmp = GetPixel(@hDC1, @px[i] - 1, @py[i] + 1)     
    end
    #确定当前位置没有与另一个雪花重叠，否则返回0，用于防止由于不同雪花重叠造成雪花乱堆
    if colorCmp == SnowCol
      return 0
    end
    #分别获取ColorCmp与对比点的蓝、绿、红部分的差值
    tempB = ((colorCmp & 0xFF0000).abs - (@pColor[i] & 0xFF0000)) / 0x10000
    tempG = ((colorCmp & 0xFF00).abs - (@pColor[i] & 0xFF00)) / 0x100
    tempR = ((colorCmp & 0xFF).abs - (@pColor[i] & 0xFF))
    ##返回对比度值
    (tempR + tempG + tempB) / 3
  end
 
  def cc
    ReleaseDC 0, @hDC1 #释放桌面窗口设备句柄
    #InvalidateRect 0, Rect.new.data , 0 #清除所有雪花，恢复桌面
    InvalidateRect 0, 0, 0 #清除所有雪花，恢复桌面
    exit
  end
 
  def run
    trap(:INT){cc} #按 ctrl-c 退出
    timerStart #启动定时器
 
    #等到所有线程退出后,主线程再退出
    sleep 1 while Thread.list.count != 1
    cc #结束运行
  end
end
 
Snow.new.run