---------------------------------------------------------------------------------------------------
-- 1. 本脚本实现了在新世纪商城购买全材料和战争加成卡片的功能；
-- 2. 本脚本在国服0.34，夜神6.5.0.0，安卓版本5下测试通过；
-- 3. 已知问题：有时会获取不到新世纪商城的信息，此时须重启游戏；
-- 4. 本脚本需要断网操作；
-- 5. 本脚本得到了绿城的全力支持，并无私提供各种资料参考，特致谢意！
-- 6. 最后更新时间：2019年12月7日
---------------------------------------------------------------------------------------------------

-- 新世纪代码偏移量
local NEOMALL_QTY_OFFSET = -16
local NEOMALL_AMOUNT_OFFSET = 96
local NEOMALL_FROZEN_FLAG_OFFSET = 200
local NEOMALL_GRID_COUNT = 8
local NEOMALL_QTY_ENCRYPTION1_OFFSET = -8
local NEOMALL_QTY_ENCRYPTION2_OFFSET = -4
local NEOMALL_MATERIAL_CODE_OFFSET = -24
local MATERIAL_CODE_OFFSET  = 4
local SIMOCASH_OFFSET = 16 -- 搜索金币；绿钞时，绿钞的偏移量


local valueOffset = {0, 8, 12}

local newMallOffset = {}

local neoMallSearchInfo = {
    searchInfo = "2;3;2;2,087,261,488D;30W;::167",
    researchInfo = "30",
    resetSearchInfo = "21600000",
    codeOffset = 258,
    totalGridCount = 8
}

local selectionInfo = {
    "   1. 92种普通材料 + 12种战争材料 + 15种扩展材料",
    "   2. 18种战争加成器",
    "   3. 退出"
}

local materialSearchInfo = {
    -- 格式说明
    -- index: 选择的索引编号
    -- name: 材料类型
    -- searchInfo: 搜索字符串
    -- researchInfo: 再次查找的字符串
    -- totalCount: 材料的总个数

    -- 普通材料
    {
        index = 1,
        name = "普通材料",
        searchInfo = "16;0;-2147483648~-2;-2147483648~-2;3;0::21",
        researchInfo = "16",
        totalCount = 92
    },

    -- 战争材料
    {
        index = 2,
        name = "战争材料",
        searchInfo = "51;0;17;0;65::33",
        researchInfo = "51",
        totalCount = 12
    },
    
    -- 扩展材料
    {
        index = 3,
        name = "扩展材料",
        searchInfo = "24;0;-2147483648~-2;-2147483648~-2;5;0::21",
        researchInfo = "24",
        totalCount = 15
    },

    -- 战争加成卡片
    {
        index = 4,
        name = "战争加成卡片",
        searchInfo = "54;4;23;0;49::33",
        researchInfo = "54",
        totalCount = 18
    }
}

function getAddressValue(address, dataType)
    local temp ={} temp[1] = {}      
    temp[1].address, temp[1].flags, temp[1].value = address,dataType, 0
    temp = gg.getValues(temp) 
    
    return temp[1].value 
 end
      
function setAddressValue(address, dataType, value, frozenFlag)  
    local temp = {} temp[1]={}     
    temp[1].address = address
    temp[1].value = value
    temp[1].flags = dataType
    temp[1].freeze = frozenFlag
    gg.setValues(temp) 
 end

function setMultiAddressValue(address, dataType, valueArray, frozenFlag)
    local temp = {}

    if #valueArray == #valueOffset then
        for i = 1, #valueArray do
            temp[i] = {}
            temp[i].address = address + valueOffset[i]
            temp[i].value = valueArray[i]
            temp[i].flags = dataType
            temp[i].freeze = frozenFlag
        end
    else
        gg.alert(string.format("地址和数值不匹配：%d : %d", #addressArray, #valueArray))
        return
    end

    gg.setValues(temp) 
end

function getSimoleons()
    local data = gg.prompt({'你目前的模拟币','你目前的绿钞'},{[1]="输入你的模拟币数",[2]="输入你的绿钞"})

    gg.clearResults()
    gg.searchNumber(string.format("%d;%d::50",data[1],data[2]),gg.TYPE_DWORD)
    gg.searchNumber(string.format("%d",data[1]), gg.TYPE_DWORD)
    local simoleons = {}
    local temp = {}
    local index
    local count = gg.getResultCount()
    --local simoleonsAddress = {}
    if(count == 0) then
        gg.alert("模拟币的地址和加密值未找到，脚本退出。")
        os.exit()
    end

    --gg.alert(string.format("找到模拟币地址%d个。", count))
    temp = gg.getResults(count)

    for i = 1, count do       
        local tempCash = getAddressValue((temp[i].address + SIMOCASH_OFFSET), gg.TYPE_DWORD)
        -- 
        --gg.alert(string.format("偏移地址的绿钞数: %d", tempCash))      --
        
        -- 定位正确的模拟币地址
        if tempCash == data[2] then
            index = i
            break
        end
    end    
       
    if(index == 0) then
        gg.alert("模拟币的地址和加密值未找到，脚本退出。")
        os.exit()
    end

    for i = 1, #valueOffset do
        simoleons[i] = getAddressValue((temp[index].address + valueOffset[i]),gg.TYPE_DWORD)
    end
        --simoleons[1] = getAddressValue(simoleonsAddress[1],gg.TYPE_DWORD)
        --simoleons[2] = getAddressValue((simoleonsAddress[1]+0x8),gg.TYPE_DWORD)
        --simoleons[3] = getAddressValue((simoleonsAddress[1]+0xC),gg.TYPE_DWORD)
    
    -- 测试
    --gg.alert(string.format("模拟币: %d; %d; %d",simoleons[1],simoleons[2],simoleons[3]))
    --
    return simoleons
end

function getMaterialInfo(searchInfo)
    gg.setVisible(false) 
    gg.clearResults()  
    gg.toast(searchInfo.name.."的准备工作正在进行中 ...")
    gg.searchNumber(searchInfo.searchInfo, gg.TYPE_DWORD)
    gg.searchNumber(searchInfo.researchInfo, gg.TYPE_DWORD)
    --if gg.getResultCount() ~= searchInfo.totalCount then 
    --   gg.alert(searchInfo.name.."代码初始化失败.") 
    --   os.exit() 
    --end

    local result = gg.getResults(searchInfo.totalCount)
    local materialCode = {}
    --local i = 0
    local printOut = ""
    for i = 1, searchInfo.totalCount do 
       --i = i + 1
       materialCode[i] = {}     
       materialCode[i].flags = gg.TYPE_DWORD
       -- 测试
       -- gg.alert(string.format("地址：%d", result[i].address))
       -- gg.alert(string.format("偏移量：%d", MATERIAL_CODE_OFFSET))
       -- 
       materialCode[i].value = result[i].address - MATERIAL_CODE_OFFSET
       printOut = printOut .. materialCode[i].value .. "\n"
    end 

    -- 测试
    --gg.alert(printOut)
    --
    return materialCode
end

-- 获取新世纪格子信息
function getNeoMallGridInfo()
    gg.setVisible(false)
    gg.clearResults()  
    gg.toast("新世纪商城的准备工作正在进行中 ...")
    gg.searchNumber(neoMallSearchInfo.searchInfo, gg.TYPE_DWORD)
    gg.searchNumber(neoMallSearchInfo.researchInfo, gg.TYPE_WORD)
    local result = gg.getResults(1)
    local neoMallCode = getAddressValue((result[1].address + neoMallSearchInfo.codeOffset), gg.TYPE_DWORD)   
    -- 测试
    --gg.alert(string.format("新世纪特征代码：%d", neoMallCode))
    --
    gg.clearResults()  
    gg.toast("新世纪商城的准备工作正在进行中 ...")
    gg.searchNumber('1;'..neoMallCode..'::20', gg.TYPE_DWORD)
    gg.searchNumber(neoMallCode, gg.TYPE_DWORD)

    local grid = {}
    local code = gg.getResults(10)
    local gridCount = 0
    for i = 1, #code do
        local valueONE = getAddressValue((code[i].address + NEOMALL_QTY_OFFSET), gg.TYPE_DWORD)
        local encryption2 = getAddressValue((code[i].address + NEOMALL_QTY_ENCRYPTION2_OFFSET), gg.TYPE_DWORD)
        if (valueONE == 1 and encryption2 ~= 0) then
            gridCount = gridCount + 1
            grid[gridCount] = code[i]            
        end
    end

    if (gridCount == 0) then
        gg.alert("找不到新世纪商城的格子信息，请重启游戏。")
        os.exit()
    end

    if gridCount > NEOMALL_GRID_COUNT then
        gg.alert(string.format("新世纪商城的格子数量不正确。%d : %d", gridCount, NEOMALL_GRID_COUNT))
        os.exit()
    end

    gg.clearResults()

    return grid
end

-- 获取选择的索引
function getSelectionInfo()
    local index = gg.choice(selectionInfo, nil, "***** 刷材料 请断网操作 *****")

    return index
end

-- 获取搜索信息
-- 返回搜索串信息内容
function getSearchInfo(index)
    local info = {}
    for i = 1, #materialSearchInfo do
        if materialSearchInfo[i].index == index then
            info = materialSearchInfo[i]
            break
        end
    end
    return info
end

function getValueArray(address)
    local temp = {}
    for i = 1, #valueOffset do
        temp[i] = getAddressValue(address + valueOffset[i], gg.TYPE_DWORD)
    end
    return temp
end

function resetNeoMallGrid(gridInfo)
    gg.setVisible(false)
    gg.clearResults()  
    gg.searchNumber(neoMallSearchInfo.resetSearchInfo, gg.TYPE_DWORD)
    local result = gg.getResults()
    local resultCount = gg.getResultCount()

    for i = 1, resultCount do
        --setAddressValue((gridInfo[i].address + NEOMALL_FROZEN_FLAG_OFFSET), gg.TYPE_DWORD, "0", false)
        setAddressValue(result[i].address, gg.TYPE_DWORD, "0", false)
    end
end

function materialOnSale(neoMallGridInfo, materialInfo)
    local valueONE = getValueArray(neoMallGridInfo[1].address + NEOMALL_QTY_OFFSET)
    -- 测试
    --gg.alert(string.format("%d; %d; %d",valueONE[1],valueONE[2],valueONE[3]))
    --
    local valueSimoleons = getSimoleons()
    -- gg.alert(string.format("%d; %d; %d",valueSimoleons[1],valueSimoleons[2],valueSimoleons[3]))
    local materialCount = #materialInfo

    for i = 1, #neoMallGridInfo do
        -- 设置上架物品数量
        setMultiAddressValue((neoMallGridInfo[i].address + NEOMALL_QTY_OFFSET), gg.TYPE_DWORD, valueSimoleons, false) 
        -- 设置上架物品金额
        setMultiAddressValue((neoMallGridInfo[i].address + NEOMALL_AMOUNT_OFFSET), gg.TYPE_DWORD, valueONE, true) -- ？？

        gg.toast("可以去新世纪买买买")  
        -- 设置材料代码
        setAddressValue((neoMallGridInfo[i].address + NEOMALL_MATERIAL_CODE_OFFSET), gg.TYPE_DWORD, materialInfo[materialCount].value, false)
        -- 设置冻结标志
        setAddressValue((neoMallGridInfo[i].address + NEOMALL_FROZEN_FLAG_OFFSET), gg.TYPE_DWORD, "0", false) 

        materialCount = materialCount - 1     
        while materialCount == 0 do 
           gg.toast('全部材料上架完毕！') 
           return 
        end 
    end 

    while (true) do  
        for i = 1 , #neoMallGridInfo do   
           if getAddressValue((neoMallGridInfo[i].address + NEOMALL_FROZEN_FLAG_OFFSET),gg.TYPE_DWORD) ~= 0 then   
                -- 设置材料代码
                setAddressValue((neoMallGridInfo[i].address + NEOMALL_MATERIAL_CODE_OFFSET), gg.TYPE_DWORD, materialInfo[materialCount].value, false)
                -- 设置冻结标志
                setAddressValue((neoMallGridInfo[i].address + NEOMALL_FROZEN_FLAG_OFFSET), gg.TYPE_DWORD, "0", false) 
                materialCount = materialCount - 1 
           end
           if materialCount == 0 then       
              gg.toast('全部材料上架完毕！') 
              return    
           end 
        end 
    end 

    --resetNeoMallGrid(neoMallGridInfo)

end

-- 主函数入口
function main()
    gg.setVisible(false)
    gg.clearResults()

    selectedIndex = getSelectionInfo()
    
    local allMaterials = {}
    if (selectedIndex == 1) then  -- 全材料搜索
        local materialIndex = 1
        for i = 1, 3 do
            -- 获取搜索条件
            --local searchInfo = getSearchInfo(selectedIndex)
            local searchInfo = getSearchInfo(i)
            gg.toast("成功获取材料搜索信息！")

            -- 获取材料代码
            local materialInfo = getMaterialInfo(searchInfo)
            gg.toast("成功获取材料代码信息！")

            for j = 1, #materialInfo do
                allMaterials[materialIndex] = materialInfo[j]
                materialIndex = materialIndex + 1
            end
            -- 材料上架
            --materialOnSale(neoMallGridInfo, materialInfo)
            --gg.alert("您取消了本操作")
        end    
    end
    

    if (selectedIndex == 2) then -- 战争加成卡片
        local searchInfo = getSearchInfo(4)
        gg.toast("成功获取材料搜索信息！")

        -- 获取材料代码
        -- local materialInfo = getMaterialInfo(searchInfo)
        
        local materialInfo = getMaterialInfo(searchInfo)
        gg.toast("成功获取材料代码信息！")

        for i = 1, #materialInfo do
            allMaterials[i] = materialInfo[i]
        end
    end

    if (selectedIndex == 3) then
        os.exit()
    end

    --gg.alert(string.format("要上架的材料共 %d 种。", #allMaterials))
    -- 获取新世纪格子信息
    local neoMallGridInfo = getNeoMallGridInfo()
    gg.toast("成功获取新世纪格子信息！")
    --gg.alert(string.format("新世纪商城可用的格子数量：%d", #neoMallGridInfo))
    -- 材料上架
    materialOnSale(neoMallGridInfo, allMaterials)
    
    gg.clearResults()
    os.exit()
end

main()