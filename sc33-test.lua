jianzpd,xsjpd,salecode,shuliang,xsjcode,remark,tempcount = true,true,{},{},{},{},0
simoleons = {}
function read(dizhi,leixing)  
   local td ={} td[1] = {}      
   td[1].address,td[1].flags,td[1].value=dizhi,leixing,0
   td = gg.getValues(td) 
   
   return td[1].value 
end
     
function write(dizhi,shujv,zhuangtai)  
   local txr = {} txr[1]={}     
   txr[1].address,txr[1].value,txr[1].flags,txr[1].freeze=dizhi,shujv,gg.TYPE_DWORD,zhuangtai     
   gg.setValues(txr) gg.addListItems(txr) 
   
   return txr[1].value 
end

function getSimoleons()
   local data = gg.prompt({'你目前的模拟币','你目前的绿钞'},{[1]="输入你的模拟币数",[2]="输入你的绿钞"})

   gg.clearResults()
   gg.searchNumber(string.format("%d;%d::50",data[1],data[2]),gg.TYPE_DWORD)

   if(gg.getResultCount()==4) then
      local simoleonsAddress = gg.getResults(4)

      simoleons[1] = read(simoleonsAddress[1],gg.TYPE_DWORD)
      simoleons[2] = read((simoleonsAddress[1]+0x8),gg.TYPE_DWORD)
      simoleons[3] = read((simoleonsAddress[1]+0xC),gg.TYPE_DWORD)
   end

   gg.toast("%d;%d;%d",simoleons.value,simoleons.encrypt1,simoleons.encrypt2)
end

function shengji()
   gg.clearResults() 
   local Exp = gg.prompt({'升级房屋的金钱奖励', '升级房屋的经验奖励','你想得到的金钱奖励','你想要升级后的等级（18级~35级之间选择）'}, {[1]="去找一个可以升级的房屋并输入", [2]="去找一个可以升级的房屋并输入", [3]=5000000, [4]=30})
      
   gg.searchNumber(string.format("%d;0;0;0;0;0;0;%d::29",Exp[1],Exp[2]), gg.TYPE_DWORD)   
   
   if (gg.getResultsCount()== 8) then                  
      local  a = {7500,8500,9500,11000,12000,13500,15000,16500,18000,20000,22000,24000,26000,28000,31000,33000,36000,38000}

      for eexp = 1 ,20 do 
         while eexp == Exp[4]-17 
            do expdengji = a[eexp] 
            break 
         end 
      end
                   
      local expdata = gg.getResults(8) 
                   
      expdata[1].value=Exp[3]  
      expdata[8].value=expdengji

      gg.setValues(expdata)        
      gg.clearResults()                         
      gg.toast('成功修改，可以去升级房屋了')
                   
   else gg.alert('搜索出错，请检查你输入的数值，或换一栋房屋升级') 
   end  
end 

function shop()
   gg.setVisible(false)    
   gg.clearResults()    
   gg.searchNumber("3;7;26;65537;65536;65538::50", gg.TYPE_DWORD)
   gg.searchNumber("65537",gg.TYPE_DWORD)
   gg.getResults(100)  
   gg.toast("超级商店修改成功")
   gg.editAll("15",gg.TYPE_DWORD) 
end
    
function fac()
   gg.setVisible(false)
   gg.clearResults()
   gg.searchNumber("3;7;21;5;150000;50000::320", gg.TYPE_DWORD)
   local w = gg.getResults(6)  
   gg.toast("超级工厂修改成功")
   w[4].value = '99'  w[5].value = '1'  w[6].value = '99'
   gg.setValues(w) 
   gg.addListItems(w)  
   gg.clearResults()  
end

function stoa()
   gg.setVisible(false)
--gg.clearResults()
--gg.searchNumber("3;26;7::9",gg.TYPE_DWORD)
--if gg.getResultCount() == 141 then
--gg.searchNumber("3",gg.TYPE_DWORD)
--else gg.toast("OMG仓库搜索失败") return end
--omgstoage = gg.getResults(47)                   
--for t = 1,47 do
--if read ((omgstoage[t].address - 72),gg.TYPE_DWORD) == -5428496 then 
--write((omgstoage[t].address + 380), 245 , false)  end 
--write((omgstoage[t].address + 212), -1 , false) end
--gg.toast("可以去建设OMG仓库了")

   gg.clearResults()
   gg.searchNumber("3;8;27::9",gg.TYPE_DWORD)
   if gg.getResultCount() == 339 then
      gg.searchNumber("3",gg.TYPE_DWORD)
   else gg.toast("常规仓库搜索失败") 
      return 
   end
   comstoage = gg.getResults(113)                   
   for t = 1,113 do
      if read ((comstoage[t].address + 204),gg.TYPE_DWORD) ==1 then 
         write((comstoage[t].address + 204),-1,false) 
      end
      write((comstoage[t].address + 0x170),39321600,false) 
   end
   gg.toast("可以去建设普通仓库了")
end



function submap()
   gg.setVisible(false)
   gg.clearResults()
   gg.searchNumber("15000;250000;1000000;10000000::49",gg.TYPE_DWORD)
   gg.getResults(4) 
   gg.editAll("0",gg.TYPE_DWORD)
   gg.clearResults()  gg.toast("可以去开启新地图了") 
end

function SMgetcode(SCnum1,SCnum2,SCNum,SCname)
   gg.setVisible(false) 
   gg.clearResults()  
   gg.toast(SCname.."准备工作进行中......")
   gg.searchNumber(string.format(SCnum1,SCnum2), gg.TYPE_DWORD)
   gg.searchNumber(string.format("%d",SCnum2),gg.TYPE_DWORD)
   if gg.getResultCount() ~= string.format("%d",SCNum) then 
      gg.alert(SCname.."代码初始化失败") 
      os.exit() 
   end
	local tdr= gg.getResults(SCNum)
   for i = 1,string.format("%d",SCNum) do 
      tempcount = tempcount + 1
      salecode[tempcount] = {}     
      salecode[tempcount].flags = gg.TYPE_DWORD
      salecode[tempcount].value = string.format("%d",(tdr[i].address - 4)) 
   end 
end
	    
function xsjbuy(NUM1)    
   for i=1,xsjgezi do
      write(shuliang[i].address,NUM1,false) 
      write((shuliang[i].address + 0x2C),"1",true) 
      gg.toast("可以去新世纪买买买")  
      write((shuliang[i].address - 0x4),salecode[tempcount].value,false)
      write((shuliang[i].address+0x58),"0",false) 
      tempcount=tempcount-1     
      while tempcount == 0 do 
         gg.toast('全部上架完毕！') 
         return 
      end 
   end     
   
   while (true) do  
      for i = 1 , xsjgezi do   
         if read((shuliang[i].address + 0x58),gg.TYPE_DWORD) ~= 0 then   
            write((shuliang[i].address - 0x4),salecode[tempcount].value,false)
            write((shuliang[i].address+0x58),"0",false) tempcount=tempcount-1 
         end
         if tempcount == 0 then       
            gg.toast('全部上架完毕！') 
            return    
         end 
      end 
   end 
end

function xsjready()
   gg.setVisible(false)
   gg.clearResults()  gg.toast("新世纪的准备工作进行中......")
   gg.searchNumber('2;3;2;2,087,261,488D;30W;::167', gg.TYPE_DWORD)
   gg.searchNumber('30', gg.TYPE_WORD)
   local xsjr = gg.getResults(1)
	local xsjtemp=read((xsjr[1].address+258),gg.TYPE_DWORD)
   gg.clearResults()  
   gg.toast("新世纪的准备工作进行中......")       
   gg.searchNumber('-2147483648 ~ -9999;1~99999;'..xsjtemp..'::9', gg.TYPE_DWORD)     
   gg.searchNumber('1', gg.TYPE_DWORD)
     
   if gg.getResultCount() > 8 then 
      gg.alert("新世纪的格子数量不正确") 
      os.exit() 
   end
     
   shuliang = gg.getResults(8)  
   xsjgezi = gg.getResultCount()  
   xsjpd= false 
end

function XSJ()
   if xsjpd then xsjready() end
  
   YJJ = gg.multiChoice({
      "  1  92种常规材料",
      "  2  11种战争材料",
      "  3  15种扩展材料",
      "  4  10种OMG材料",
      "  5  22张战争卡片",
      "  6  18种加成器",
      "  7  市长竞赛金票",
      "  8  庄园",
      "  9  湖泊",
      "  返回到主菜单"
   }, nil, "🔑  山村集团内部工具  🔑  刷材料(可以多选连续刷)  🔑")
  
   getSimoleons()
   
   if YJJ[1] == true then
      SMgetcode("%d;0;-2147483648~-2;-2147483648~-2;3;0::21",16,92,"常规材料")
      xsjbuy(36398030) 
   end
   if YJJ[2] == true then
      SMgetcode("%d;0;17;0;65::33",51,11,"战争材料") 
      xsjbuy(36398030) 
   end
   if YJJ[3] == true then
      SMgetcode("%d;0;-2147483648~-2;-2147483648~-2;5;0::21",24,15,"扩展材料")
      xsjbuy(36398030) 
   end
   if YJJ[4] == true then
      SMgetcode("%d;1;13;0;33~39::33",39,10,"OMG物品") 
      xsjbuy(429496740) 
   end
   if YJJ[5] == true then
      SMgetcode("%d;4;18;0::21",52,22,"战争卡片") 
      xsjbuy(2000) 
   end
   if YJJ[6] == true then
      SMgetcode("%d;4;23;0;49::33",54,18,"战争加成器(buff)") 
      xsjbuy(2000) 
   end
   if YJJ[7] == true then
      SMgetcode("%d;4;37;0;33;29::37",40,1,"市长竞赛金票") 
      xsjbuy(2000) 
   end
   if YJJ[8] == true then 
      SMgetcode("%d;3;925375395::41",2,1,"庄园") 
      xsjbuy(4) 
   end
   if YJJ[9] == true then 
      SMgetcode("%d;3;1092744876::41",2,1,"湖泊") 
      xsjbuy(500) 
   end
  
   if YJJ[10] == true then 
      Main() 
   end 
end


function Main()
   SN = gg.choice({
   "1  快速升级",
   "2  直建仓库",
   "3  超级商店",
   "4  纳米工厂",
   "5  刷齐材料",
   "6  快速建设",
   "7  开新地图",
   "退出"
   }, nil,  "🔑  山村集团内部工具  🔑  新号速成  🔑")
   if SN == 1 then shengji() end
   if SN == 2 then stoa() end
   if SN == 3 then shop() end
   if SN == 4 then fac() end
   if SN == 5 then XSJ() end
   if SN == 6 then kuisujianshe() end
   if SN == 7 then submap() end
   if SN == 8 then Exit() end
   runFlag = '山村'  
end

function kuisujianshe()
   local selection =gg.alert('已经开始建造机场，码头，博士大楼。 \n 我想让它立即建设完成。不想等待了。',"       [✈✈✈  立刻建设完成  ✈✈✈]","[我还没开始建造，先回主菜单]           ")
   if selection == 2 then Main() end	
   if selection == 1 then 
      gg.clearResults()  
      gg.setVisible(false) 
	   gg.searchNumber("2;4;1000::17",gg.TYPE_DWORD)
      local t=gg.getResults(10) 	
      write(t[1].address+8,0,false)
      gg.toast("建设已完成") 	
      gg.clearResults() 
   end 
end

function Exit()    --退出程序
    print("⚡⚡⚡ 山村集团，辅助工具，仅限内部，学习交流，禁止外传  ⚡⚡⚡ ")
    os.exit()
end

while true do
   if gg.isVisible(true) then
      runFlag = 'run'
      gg.setVisible(false)
   end
   if runFlag == 'run' then 
      Main()
   end
end
