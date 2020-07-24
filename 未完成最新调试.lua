first=1
firsttime=1
local pianyi
local tzsl
addlist={}
function Main()
	if first ==1 then
---gg.alert("钟别制作")
---gg.alert("simcity模拟城市：532374741")
---gg.alert("群内脚本、教程均为免费")
first=first+1
end
t2={}

  local SN1 = gg.choice({
    "1-初始化--请先选择此处",
    "2-战争材料",
    "3-普通材料",
    "4-小镇材料",
    "5-OMG材料",
    "6-特殊材料",
    "7-新地区材料",
    "8-退出脚本"
  }, nil, "simcity模拟城市 532374741")

 if SN1 == 1 then
    chushihua()
  end
  if SN1 == 2 then
    zhanzheng()
  end
  if SN1 == 3 then
    putongcailiaoxh()
  end
  if SN1 == 4 then
    sanguo()
  end
  if SN1 == 5 then
    omijia()
  end
  if SN1 == 6 then
    kuoxi()
  end
  if SN1 == 7 then
    xindiqu()
  end
  if SN1 == 8 then
    Exit()
  end
  XGCK = -1
end

function chushihua()
banben = gg.choice ({
"国际服",
"国服"})
if banben == 1 then pianyi=192 end
if banben == 2 then pianyi=200 end
  gg.clearResults()
---加密初始化
if firsttime == 1 then
	firsttime = firsttime + 1
  num_value = gg.prompt({
    "当前金币：",
    "当前绿钞:"
  }, {
    [1] = 19838735,
    [2] = 40
  }, {
    [1] = "number",
    [2] = "number"
  })
  if num_value == nil then
    Main()
else
	gg.searchNumber(num_value[1]..";" .. num_value[2] .. "::17", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
	if gg.getResultCount()==0 then
		gg.alert("error")
		Main()
	else
	t = gg.getResults(4)
	check=t[2].address-t[1].address
	if check==4 then
		a=3
	else
		a=1
	end
	jmdz1= string.format("%X", t[a].address)
	jmdz2= string.format("%X", t[a].address+8)
	jmdz3= string.format("%X", t[a].address+12)
	end
	
--  new_value = gg.prompt({
--    "目标数量："
--  }, {
--    [1] = 20000000
--  }, {
--    [1] = "number",
--  })
--  if num_value == nil then
--    Main()
--	else
--	maijinbi=new_value[1]-num_value[1]
--	gg.clearResults()
--	gg.searchNumber("240000;6000::9", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
--	gg.searchNumber("6000")
--  gg.getResults(1)
--	gg.editAll(0, gg.TYPE_DWORD)
--	gg.clearResults()
--	gg.searchNumber("240000;64800;114000::49", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
--	gg.searchNumber("240000")
--	gg.getResults(1)
--	gg.editAll(maijinbi, gg.TYPE_DWORD)
--	gg.alert("请去金币界面购买金币")
--	gg.setVisible(false)
--	end
--	repeat 
--	until gg.isVisible(true)
--	
	gg.clearResults()
	gg.searchAddress(jmdz1, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
	jm1=gg.getResults(1)
	gg.clearResults()
	gg.searchAddress(jmdz2, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
	jm2=gg.getResults(1)
	gg.clearResults()
	gg.searchAddress(jmdz3, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
	jm3=gg.getResults(1)
	
end

---新世纪初始化
  c_value = gg.prompt({
    "输入新世纪其中一个材料价格：",
  }, {
    [1] = 4020,
  }, {
    [1] = "number",
  })

  if c_value == nil then
	
    Main()
  else
	gg.searchNumber("1~10;0;" .. c_value[1] .. "::117", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    gg.searchNumber("1~10;0;0;0;0;0;0;0;0;0;" .. c_value[1] .. "::117", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
  if gg.getResultCount()==0 then
     gg.alert("error")
	 Main()
	 else
     gg.searchNumber(c_value[1], gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
     local csjg = gg.getResults(2)
     local tzdz = string.format("%X", csjg[1].address - 96)
	 local sz1dz = string.format("%X", csjg[1].address - 96-16)
	 local sz1jm1dz = string.format("%X", csjg[1].address - 96-16+8)
	 local sz1jm2dz = string.format("%X", csjg[1].address - 96-16+12)
     gg.clearResults()
	 gg.searchAddress(tzdz, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
     local tz = gg.getResults(1)
	 gg.clearResults()
	 gg.searchAddress(sz1dz, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
     local sz1 = gg.getResults(1)
	 gg.clearResults()
	 gg.searchAddress(sz1jm1dz, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
     local sz1jm1 = gg.getResults(1)
	 gg.clearResults()
	 gg.searchAddress(sz1jm2dz, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
     local sz1jm2 = gg.getResults(1)
	
	
	 gg.clearResults()
	 gg.searchNumber(sz1[1].value..";" ..sz1jm1[1].value..";"..sz1jm2[1].value..";"..tz[1].value.. "::17", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
     gg.searchNumber(tz[1].value, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
	 tzsl = gg.getResultCount()
	 gg.alert("格子数量:" .. tzsl)
	 t2 = gg.getResults(tzsl)
     for j = 1, #t2 do
     addlist[j] = t2[j].address
     end
	
     for j = 1, #t2 do
		---改数字
         gg.clearResults()
         addaf = string.format("%X", addlist[j] - 16)
         gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
         gg.getResults(1)
         gg.editAll(jm1[1].value, gg.TYPE_DWORD)
		 gg.clearResults()
         addaf = string.format("%X", addlist[j] - 16+8)
         gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
         gg.getResults(1)
         gg.editAll(jm2[1].value, gg.TYPE_DWORD)
		 gg.clearResults()
         addaf = string.format("%X", addlist[j] - 4)
         gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
         gg.getResults(1)
         gg.editAll(jm3[1].value, gg.TYPE_DWORD)
		
		---改价格
		 gg.clearResults()
         addaf = string.format("%X", addlist[j] + 96)
         gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
         gg.getResults(1)
         gg.editAll(sz1[1].value, gg.TYPE_DWORD)
		 gg.clearResults()
         addaf = string.format("%X", addlist[j] + 96+8)
         gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
         gg.getResults(1)
         gg.editAll(sz1jm1[1].value, gg.TYPE_DWORD)
		 gg.clearResults()
         addaf = string.format("%X", addlist[j] + 96+12)
         gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
         gg.getResults(1)
         gg.editAll(sz1jm2[1].value, gg.TYPE_DWORD)
		
		---改冻结		
		 gg.clearResults()
		 addaf = string.format("%X", addlist[j] +pianyi)
         gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
         gg.getResults(1)
         gg.editAll(1, gg.TYPE_DWORD)
     end
end
end
end
  local SN = gg.multiChoice({
    "1➖特殊材料初始化",
    "2➖战争材料初始化",
    "3➖OMG材料初始化",
    "4➖返回菜单",
  }, nil, "可多选，如果您只需要普通材料请直接点击确认")
  if SN == nil then
  else
    if SN[1] == true then
	kxcl = ChuShi( 13285930,  21080992, 15)
	gg.toast("普通材料初始化成功")
    end
    if SN[2] == true then
	zzcl = ChuShi(2090081903, 253271711, 11)
	gg.toast("战争材料初始化成功")
    end
    if SN[3] == true then
	omjcl = ChuShi( -1540641695, 1940876015, 10)
	gg.toast("OMG材料初始化成功")
    end
    if SN[4] == true then
      Main()
	end
	ptcl = ChuShi(267176888, 2090874750, 92)
	gg.toast("普通材料初始化成功")
  end
  XGCK = -1
end

function ChuShi(biaoji, biaoji2, clsl)
  gg.clearResults()
  gg.searchNumber(biaoji..";"..biaoji..";".."-2000000000~-100"..";".."::9", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
  SouSuoJieGuoChuLi(gg.getResultCount())
  bj1 = gg.getResults(3)

    gg.clearResults()
  gg.searchNumber(biaoji2..";"..biaoji2..";".."-2000000000~-100"..";".."::9", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
  SouSuoJieGuoChuLi(gg.getResultCount())
  bj2 = gg.getResults(3)
  gg.clearResults()
  gg.searchNumber(bj1[3].value ..";"..bj2[3].value.."::5", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
  SouSuoJieGuoChuLi(gg.getResultCount())
  gg.searchNumber(bj1[3].value, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
  clbj = gg.getResults(1)
  cl = {}
  for j = 1,clsl do
    gg.clearResults()
    gg.searchAddress(string.format("%X", clbj[1].address + j * 4 - 4), -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
    clbjj = gg.getResults(1)
    cl[j] = clbjj[1].value
	end
  SouSuoJieGuo(cl)
  return cl
end


  qcljsqg = 1
  qcljsqz = 1
  ptjsqg = 1
  ptjsqz = 1
  kxjsqg = 1
  kxjsqz = 1
  zzjsqg = 1
  zzjsqz = 1
  omjjsqg = 1
  omjjsqz = 1
  jcqjsqg = 1
  jcqjsqz = 1
  jzjsqg = 1
  jzjsqz = 1
  xzjsqg = 64
  xzjsqz = 1
  xdqjsqg = 73
  xdqjsqz = 1
function zhanzhenga()
	zzjsqg = 1
	panding=1
	gg.toast("请打开新世纪购买")
    gg.setVisible(false)
while true do
  for j = 1, tzsl do
	a=0
    gg.clearResults()
    addaf = string.format("%X", addlist[j] + pianyi)
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
    a=gg.getResults(1)
	if a[1].value~=0 then
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
	gg.getResults(1)
    gg.editAll(0, gg.TYPE_DWORD)
	gg.clearResults()
    addaf = string.format("%X", addlist[j] - 48)
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
    gg.getResults(1)
	if zzjsqg > 11 then
      gg.editAll(ptcl[1], gg.TYPE_DWORD)
	  
	if zzjsqg ==11+tzsl then
	tishi()
	panding=1
				end
				zzjsqg = zzjsqg + 1
    else
      gg.editAll(zzcl[zzjsqg], gg.TYPE_DWORD)
      zzjsqg = zzjsqg + 1
    end
	else
	end
	end
end
end
function zhanzheng()
  if ChuShiHuaPanDuan(zzcl) == false then
    local ts = gg.alert("战争材料", "开始购买", "返回菜单", "退出脚本")
    if ts == 1 then
      zhanzhenga()
    end
    if ts == 2 then
      Main()
    end
    if ts == 3 then
      Exit()
    end
  end
  XGCK = -1
end
function putongcailiaoxha()
		gg.toast("请打开新世纪购买")
	ptjsqg=1
	while true do
  for j = 1, tzsl do
	a=0
    gg.clearResults()
    addaf = string.format("%X", addlist[j] + pianyi)
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
    a=gg.getResults(1)
	if a[1].value~=0 then
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
	gg.getResults(1)
    gg.editAll(0, gg.TYPE_DWORD)
	gg.clearResults()
    addaf = string.format("%X", addlist[j] - 24)
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
    gg.getResults(1)
	
    if ptjsqg > 63 then
      gg.editAll(ptcl[1], gg.TYPE_DWORD)
	if ptjsqg ==63+tzsl then	
	tishi()
	panding=1
	end
			ptjsqg = ptjsqg + 1				
    else
      gg.editAll(ptcl[ptjsqg], gg.TYPE_DWORD)
      ptjsqg = ptjsqg + 1
    end
	else
	end
	end
end
end
function putongcailiaoxh()
  if ChuShiHuaPanDuan(ptcl) == false then
    local ts = gg.alert("普通材料", "开始购买", "返回菜单", "退出脚本")
    if ts == 1 then
      putongcailiaoxha()
    end
    if ts == 2 then
      Main()
    end
    if ts == 3 then
      Exit()
    end
  end
  XGCK = -1
end
function xindiqua()
		gg.toast("请打开新世纪购买")
   xdqjsqg=73
	while true do
  for j = 1, tzsl do
	a=0
    gg.clearResults()
    addaf = string.format("%X", addlist[j] + pianyi)
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
    a=gg.getResults(1)
	if a[1].value~=0 then
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
	gg.getResults(1)
    gg.editAll(0, gg.TYPE_DWORD)
	gg.clearResults()
    addaf = string.format("%X", addlist[j] - 24)
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
    gg.getResults(1)
	
    if xdqjsqg > 92 then
    gg.editAll(ptcl[1], gg.TYPE_DWORD)
	 
	if xdqjsqg ==92+tzsl then
	tishi()
	panding=1
	end
	xdqjsqg = xdqjsqg + 1
    else
      gg.editAll(ptcl[xdqjsqg], gg.TYPE_DWORD)
      xdqjsqg = xdqjsqg + 1
    end
	else
	end
	end	
	

end
end
function xindiqu()
  if ChuShiHuaPanDuan(ptcl) == false then
    local ts = gg.alert("地区材料", "开始购买", "返回菜单", "退出脚本")
    if ts == 1 then
      xindiqua()
    end
    if ts == 2 then
      Main()
    end
    if ts == 3 then
      Exit()
    end
  end
  XGCK = -1
end
function sanguoa()
		gg.toast("请打开新世纪购买")
    xzjsqg=64
	while true do
  for j = 1, tzsl do
	a=0
    gg.clearResults()
    addaf = string.format("%X", addlist[j] + pianyi)
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
    a=gg.getResults(1)
	if a[1].value~=0 then
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
	gg.getResults(1)
    gg.editAll(0, gg.TYPE_DWORD)
	gg.clearResults()
    addaf = string.format("%X", addlist[j] - 24)
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
    gg.getResults(1)
	
    if xzjsqg > 72 then
    gg.editAll(ptcl[1], gg.TYPE_DWORD)
	 
	if xzjsqg ==72+tzsl then
	tishi()
	panding=1
	end
	xzjsqg = xzjsqg + 1
    else
      gg.editAll(ptcl[xzjsqg], gg.TYPE_DWORD)
      xzjsqg = xzjsqg + 1
    end
	else
	end
	end	
	end	
	
end
function sanguo()
  if ChuShiHuaPanDuan(ptcl) == false then
    local ts = gg.alert("三国材料", "开始购买", "返回菜单", "退出脚本")
    if ts == 1 then
      sanguoa()
    end
    if ts == 2 then
      Main()
    end
    if ts == 3 then
      Exit()
    end
  end
  XGCK = -1
end
function kuoxia()
		gg.toast("请打开新世纪购买")
	kxjsqg=1
	while true do
  for j = 1, tzsl do
	a=0
    gg.clearResults()
    addaf = string.format("%X", addlist[j] + pianyi)
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
    a=gg.getResults(1)
	if a[1].value~=0 then
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
	gg.getResults(1)
    gg.editAll(0, gg.TYPE_DWORD)
	gg.clearResults()
    addaf = string.format("%X", addlist[j] - 24)
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
    gg.getResults(1)
    if kxjsqg > 15 then
    gg.editAll(ptcl[1], gg.TYPE_DWORD)
	      
		if kxjsqg== 15+tzsl then
	tishi()
	panding=1
					end
					kxjsqg = kxjsqg + 1
    else
      gg.editAll(kxcl[kxjsqg], gg.TYPE_DWORD)
      kxjsqg = kxjsqg + 1

    end
	else
	end
	end	
	end		
	
end
function kuoxi()
  if ChuShiHuaPanDuan(kxcl) == false then
    local ts = gg.alert("特殊材料", "开始购买", "返回菜单", "退出脚本")
    if ts == 1 then
      kuoxia()
    end
    if ts == 2 then
      Main()
    end
    if ts == 3 then
      Exit()
    end
  end
  XGCK = -1
end
function omijiaa()
		gg.toast("请打开新世纪购买")
	omjjsqg=1
		while true do
  for j = 1, tzsl do
	a=0
    gg.clearResults()
    addaf = string.format("%X", addlist[j] + pianyi)
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
    a=gg.getResults(1)
	if a[1].value~=0 then
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
	gg.getResults(1)
    gg.editAll(0, gg.TYPE_DWORD)
	gg.clearResults()
    addaf = string.format("%X", addlist[j] - 24)
    gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
    gg.getResults(1)
    if omjjsqg > 10 then
      gg.editAll(ptcl[1], gg.TYPE_DWORD)
	  
	if omjjsqg ==10+tzsl then
	tishi()
	panding=1
	end
	omjjsqg = omjjsqg + 1
    else
      gg.editAll(omjcl[omjjsqg], gg.TYPE_DWORD)
      omjjsqg = omjjsqg + 1
    end
	else
	end
	end	
	end	
	
end
function omijia()
  if ChuShiHuaPanDuan(omjcl) == false then
    local ts = gg.alert("OMG材料", "开始购买", "返回菜单", "退出脚本")
    if ts == 1 then
      omijiaa()
    end
    if ts == 2 then
      Main()
    end
    if ts == 3 then
      Exit()
    end
  end
  XGCK = -1
end
function tishi()
  local ts = gg.alert("该组材料已全部买完",  "返回菜单", "退出脚本")
  if ts == 1 then
      for j = 1, tzsl do
	  gg.clearResults()
	  addaf = string.format("%X", addlist[j] + pianyi)
      gg.searchAddress(addaf, -1, gg.TYPE_DWORD, gg.SIGN_EQUAL, 0, -1)
	  gg.getResults(10)
	  gg.editAll("1", gg.TYPE_DWORD)
    end
	Main()
  end
  if ts == 2 then
    Exit()
  end
  XGCK = -1
end


function Exit()
  gg.clearList()
  os.exit()
end
cuowubj = 0
function SouSuoJieGuoChuLi(shuliang)
  if shuliang == 0 then
    weisoudao(cuowubj)
  else
    return shuliang
  end
end
function weisoudao()
   if ts == 1 then
    Exit()
  end
  XGCK = -1
end
function Exit()
  gg.clearList()
  os.exit()
end

function SouSuoJieGuo(shuju)
  for j = 1, #shuju do
    if shuju[j] == 0 then
      weisoudao()
      break
    end
  end
end

function ChuShiHuaPanDuan(cshjh)
  if cshjh == nil then
    chushihuacuowu()
    return true
  else
    return false
  end
end

function chushihuacuowu()
  local ts = gg.alert("请先初始化",  "返回菜单", "退出脚本")
  if ts == 1 then
    Main()
  end
  if ts == 1 then
    Exit()
  end
  XGCK = -1
end




while true do
  if gg.isVisible(true) then
    XGCK = 1
    gg.setVisible(false)
  end
  gg.clearResults()
  if XGCK == 1 then
    Main()
  end
end

