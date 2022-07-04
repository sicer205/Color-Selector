require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "com.xiao.color.*"
import "com.xiao.color.views.*"
import "com.xiao.color.Hex"
import "android.content.res.*"
import "android.graphics.*"
import "android.provider.Settings"
import "android.net.Uri"
import "android.content.*"
import "android.content.Context"
import "android.graphics.PixelFormat"
import "android.view.WindowManager"
import "android.os.Build"
import "android.util.Rational"
import "android.app.*"
import "android.graphics.drawable.Icon"
import "android.graphics.drawable.*"
import "android.graphics.drawable.shapes.*"
import "com.google.android.material.snackbar.Snackbar"
import "android.view.animation.AlphaAnimation"
import "android.view.Gravity"
import "androidx.appcompat.widget.Toolbar"
import "androidx.coordinatorlayout.widget.CoordinatorLayout"
import "com.google.android.material.appbar.AppBarLayout"
import "androidx.core.widget.NestedScrollView"
import "com.google.android.material.button.MaterialButton"
locals={}
locals.darkmode=(activity.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES
--activity.setTheme()



--activity.ActionBar.hide()
--模式 = 2
hex = {[0]=0,1,2,3,4,5,6,7,8,9,"A","B","C","D","E","F"}
function 复制(文本)
  import "android.content.*"
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(文本)
end
function 数值变十六进制(num)
  local a = {"",num}
  repeat
    local b = a[2] < 16 and 0 or math.floor(a[2]/16)
    local c = a[2] < 16 and a[2] or a[2]%16
    a[1] = a[1]..tostring(hex[b])..tostring(hex[c])
    a[2] = b
  until b < 256
  return a[1]
end
function 数值变十六进制x(n)
end
--print(activity.getResources().getDrawable(R.drawable.seekbar_thumb))
SeekBar的Thumb = nil--activity.getResources().getDrawable(R.drawable.seekbar_thumb)--ClipDrawable(ClipDrawable(activity.getResources().getDrawable(R.drawable.tools_v),Gravity.LEFT,1),Gravity.TOP,2)

main=function()
  if activity.getPackageName() == "com.xiao.color" and b == nil then
    --[[ AlertDialog.Builder(activity)
    .setPositiveButton("确定",nil)
    .setTitle("提示")
    .setMessage("画中画模式尚未完善。您仍可体验除其之外的所有功能。")
    .show()]]
   else
    AlertDialog.Builder(activity)
    .setTitle("Compiled failed!")
    .setCancelable(false)
    .setPositiveButton("OK",{onClick=function()activity.finish()end})
    .create()
    .show()
  end
end
--print(0xFF)
local a = 0x000123
local b = Color.parseColor("#FF0000")
local c = Color.HSVToColor(float{0,1.0,1.0})
--print(a,b,a-b,c+16777216)
--print(string.reverse(ToolsHex.numToHex(Color.HSVToColor(float{0,0,0})+16777216)))

function 十位取整(n)
  return math.floor(n/10)*10
end
主页面 = loadlayout("layout")--LayoutInflater.from(activity).inflate(R.layout.cx2,nil)
activity.setContentView(主页面)
activity.getSupportActionBar().setDisplayHomeAsUpEnabled(true)
--activity.setTitle("调色板")
onOptionsItemSelected=function(item)
  if item.getItemId() == android.R.id.home then
    activity.finish()
    return true
  end
end

color={255,255,255}--rgb模式下颜色
hsvcolor={0,0,100}--HSV模式下颜色，两个都是存数据用的
bottomtext={"#c","#","0x"}
主页面.setBackgroundColor(locals.darkmode and Color.BLACK or Color.WHITE)
function 刷新(i)
  if 模式 == 1 then
    local b = string.reverse(Hex.numToHex(Color.HSVToColor(float{hsvcolor[1],hsvcolor[2]/100,hsvcolor[3]/100})+16777216))
    local str = (string.len(b) >= 6 and "" or string.rep("0",6-string.len(b)))..b
    seek[i].setProgress(hsvcolor[i])
    top.setBackgroundColor(Color.HSVToColor(float{hsvcolor[1],hsvcolor[2]/100,hsvcolor[3]/100}))
    for a, v in pairs(bottom)
      v.setText("复制"..bottomtext[a]..str)
    end
    if (color[2]+color[3])/3 > 255/2 then
      top.setTextColor(Color.BLACK)
     else
      top.setTextColor(Color.WHITE)
    end
    text[1].setTextColor(Color.HSVToColor(float{hsvcolor[1],1,1}))
   elseif 模式 == 2 then
    for a, v in pairs(bottom)
      --print(a,type(a))
      v.setText("复制"..bottomtext[a]..数值变十六进制(color[1])..数值变十六进制(color[2])..数值变十六进制(color[3]))
    end
    text[i].setText(tostring(color[i]))
    seek[i].setProgress(color[i])
    top.setBackgroundColor(Color.parseColor("#"..数值变十六进制(color[1])..数值变十六进制(color[2])..数值变十六进制(color[3])))
    if (color[1]+color[2]+color[3])/3 > 255/2 then
      top.setTextColor(Color.BLACK)
     else
      top.setTextColor(Color.WHITE)
    end
    local function 设置(颜色)
      --print(string.sub(tostring(颜色)))
      local c = ColorMatrixColorFilter(float{
        0,0,0,0,tonumber("0x"..string.sub(tostring(颜色),1,2))/255,
        0,0,0,0,tonumber("0x"..string.sub(tostring(颜色),3,4))/255,
        0,0,0,0,tonumber("0x"..string.sub(tostring(颜色),5,6))/255,
        0,0,0,0,1
        })
      --left[i].getIcon().setColorFilter(c)
      right[i].getIcon().setColorFilter(c)
    end
    local 深 = locals.darkmode
    if i == 1 then
      if 深 == true then
        设置("FF"..数值变十六进制(255-color[i])..数值变十六进制(255-color[i]))
       else
        设置(数值变十六进制(color[i]).."0000")
      end
     elseif i == 2 then
      if 深 == true then
        设置(数值变十六进制(255-color[i]).."FF"..数值变十六进制(255-color[i]))
       else
        设置("00"..数值变十六进制(color[i]).."00")
      end
     else
      if 深 == true then
        设置(数值变十六进制(255-color[i])..数值变十六进制(255-color[i]).."FF")
       else
        设置("0000"..数值变十六进制(color[i]))
      end
    end
  end
end

bottom={colorB1,colorB2,colorB3}
top=colorTextView
function RGB模式()
  模式=2
  中间=loadlayout("c1")
  colorMiddleLayout.removeAllViews()
  colorMiddleLayout.addView(中间)
  left,right,text,seek = {color1L1,color1L2,color1L3},{color1R1,color1R2,color1R3},{color1TextView1,color1TextView2,color1TextView3},{color1S1,color1S2,color1S3}
  for i = 1,3 do
    left[i].setIconResource(R.drawable.remove)
    right[i].setIconResource(R.drawable.add)
    seek[i].setOnSeekBarChangeListener({
      onProgressChanged=function(控件,进度,是否来自用户)
        color[i]=进度
        刷新(i)
      end,
      onStartTrackingTouch=function(控件)
      end,
      onStopTrackingTouch=function(控件)
      end
    })
    left[i].onClick=function(v)
      if color[i] ~= 0 then
        color[i] = color[i]-1
        刷新(i)
      end
    end
    right[i].onClick=function(v)
      if color[i] ~= 255 then
        color[i] = color[i]+1
        刷新(i)
      end
    end
    刷新(i)
    --left[i].setTextColor(locals.darkmode and Color.WHITE or Color.BLACK)
    --left[i].setBackgroundColor(locals.darkmode and Color.BLACK or Color.WHITE)
    --left[i].setLayoutParams(RelativeLayout.LayoutParams(50,50))
    --right[i].setTextColor(locals.darkmode and Color.WHITE or Color.BLACK)
    --right[i].setBackgroundColor(locals.darkmode and Color.BLACK or Color.WHITE)
    --right[i].setLayoutParams(RelativeLayout.LayoutParams(50,50))
    left[i].setTextColor(locals.darkmode and Color.WHITE or Color.BLACK)
    left[i].setBackgroundColor(locals.darkmode and Color.BLACK or Color.WHITE)
    --left[i].getImageView().setLayoutParams(LinearLayout.LayoutParams(50,50))
    right[i].setTextColor(locals.darkmode and Color.WHITE or Color.BLACK)
    right[i].setBackgroundColor(locals.darkmode and Color.BLACK or Color.WHITE)
    --right[i].getImageView().setLayoutParams(LinearLayout.LayoutParams(50,50))
    bottom[i].setTextColor(locals.darkmode and Color.WHITE or Color.BLACK)
    bottom[i].setBackgroundColor(locals.darkmode and Color.BLACK or Color.WHITE)
    bottom[i].onClick=function(v)
      local a = string.sub(v.getText(),7,-1)
      复制(a)
      Snackbar.make(v,"已复制"..a,Snackbar.LENGTH_LONG).show()
    end
    seek[i].setProgress(color[i]-1)
    seek[i].setProgress(color[i]-1)
    if hsvcolor[i] ~= 0 then
      seek[i].setProgress(color[i]+1)
    end
  end
end
function HSV模式()
  模式=1
  中间=loadlayout("c2")
  colorMiddleLayout.removeAllViews()
  colorMiddleLayout.addView(中间)
  left,right,text,seek = {color2L1,color2L2,color2L3},{color2R1,color2R2,color2R3},{color2TextView1,color2TextView2,color2TextView3},{color2S1,color2S2,color2S3}

  local function s们刷新()
    --[[if hsvcolor[2] ~= 0 then
      seek[2].setProgress(hsvcolor[2]+1)
    end
    if hsvcolor[3] ~= 0 then
      seek[3].setProgress(hsvcolor[3]+1)
    end]]
  end

  for i = 1,3 do
    seek[i].setOnSeekBarChangeListener({
      onProgressChanged=function(控件,进度,是否来自用户)
        if 进度 == 360 then
          hsvcolor[i] = 0
         else
          hsvcolor[i] = 进度
        end
        if i == 1 then
          if 进度 == 360 then
            text[1].setText("0°")
           else
            text[1].setText(进度.."°")
          end
          s们刷新()
         else
          text[i].setText(进度.."%")
        end
        刷新(i)
      end,
      onStartTrackingTouch=function(控件)
      end,
      onStopTrackingTouch=function(控件)
      end
    })
    left[i].onClick=function(v)
      if hsvcolor[i] ~= 0 then
        hsvcolor[i] = hsvcolor[i]-1
        刷新(i)
      end
    end
    right[i].onClick=function(v)
      if i == 1 then
        if hsvcolor[i] ~= 360 then
          hsvcolor[i] = hsvcolor[i]+1
          刷新(i)
        end
       else
        if hsvcolor[i] ~= 100 then
          hsvcolor[i] = hsvcolor[i]+1
          刷新(i)
        end
      end
    end
    刷新(i)
    left[i].setTextColor(locals.darkmode and Color.WHITE or Color.BLACK)
    left[i].setBackgroundColor(locals.darkmode and Color.BLACK or Color.WHITE)
    --left[i].getImageView().setLayoutParams(LinearLayout.LayoutParams(50,50))
    right[i].setTextColor(locals.darkmode and Color.WHITE or Color.BLACK)
    right[i].setBackgroundColor(locals.darkmode and Color.BLACK or Color.WHITE)
    --right[i].getImageView().setLayoutParams(LinearLayout.LayoutParams(50,50))
    bottom[i].setTextColor(locals.darkmode and Color.WHITE or Color.BLACK)
    bottom[i].setBackgroundColor(locals.darkmode and Color.BLACK or Color.WHITE)
    bottom[i].onClick=function(v)
      local a = string.sub(v.getText(),7,-1)
      复制(a)
      Snackbar.make(v,"已复制"..a,Snackbar.LENGTH_LONG).show()
    end
  end
  seek[1].setProgress(hsvcolor[1]-1)
  if hsvcolor[1] ~= 0 then
    seek[1].setProgress(hsvcolor[1]+1)
  end
  s们刷新()
end

colorTopButton1.setTextColor(locals.darkmode and Color.WHITE or Color.BLACK)
colorTopButton1.setBackgroundColor(locals.darkmode and Color.BLACK or Color.WHITE)
colorTopButton2.setTextColor(locals.darkmode and Color.WHITE or Color.BLACK)
colorTopButton2.setBackgroundColor(locals.darkmode and Color.BLACK or Color.WHITE)
colorTopButton1.onClick=function(v)
  if 模式 == 2 then
    local b = float[3]
    Color.RGBToHSV(color[1],color[2],color[3],b)
    hsvcolor[1],hsvcolor[2],hsvcolor[3]=tonumber(tostring(int(b[0]))),tonumber(tostring(int(b[1]*100))),tonumber(tostring(int(b[2]*100)))
    local a = AlphaAnimation(1,0)
    a.setDuration(100)--设置动画时间
    a.setFillAfter(false)--设置动画后停留位置
    a.setRepeatCount(0)--设置无限循环
    中间.startAnimation(a)
    task(100,function()
      HSV模式()
      local a = AlphaAnimation(0,1)
      a.setDuration(100)--设置动画时间
      a.setFillAfter(false)--设置动画后停留位置
      a.setRepeatCount(0)--设置无限循环
      中间.startAnimation(a)
    end)
  end
end
colorTopButton2.onClick=function(v)
  if 模式 == 1 then
    local str = string.sub(bottom[1].getText(),9,-1)
    --print(str)
    if string.len(str) == 6 then
      color[1] = tonumber("0x"..string.sub(str,1,2))
      color[2] = tonumber("0x"..string.sub(str,3,4))
      color[3] = tonumber("0x"..string.sub(str,5,6))
    end
    local a = AlphaAnimation(1,0)
    a.setDuration(100)--设置动画时间
    a.setFillAfter(false)--设置动画后停留位置
    a.setRepeatCount(0)--设置无限循环
    中间.startAnimation(a)
    task(100,function()
      RGB模式()
      local a = AlphaAnimation(0,1)
      a.setDuration(100)--设置动画时间
      a.setFillAfter(false)--设置动画后停留位置
      a.setRepeatCount(0)--设置无限循环
      中间.startAnimation(a)
    end)
  end
end

HSV模式()


