local selectionInfo = {
    "1. 普通材料",
    "2. 战争材料",
    "3. 扩展材料",
    "4. 退出"
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

function setMultipleAddressValue(address, offset1, offset2, dataType, value, value1, value2, frozenFlag)
    local temp = {}
    temp[1]={}
    temp[1].address = address
    temp[1].value = value
    temp[1].flags = dataType
    temp[1].freeze = frozenFlag

    temp[2]={}
    temp[2].address = address + offset1
    temp[2].value = value1
    temp[2].flags = dataType
    temp[2].freeze = frozenFlag

    temp[3]={}
    temp[3].address = address + offset2
    temp[3].value = value2
    temp[3].flags = dataType
    temp[3].freeze = frozenFlag

    gg.setValues(temp) 
end

function getSimoleons()
    local data = gg.prompt({'你目前的模拟币','你目前的绿钞'},{[1]="输入你的模拟币数",[2]="输入你的绿钞"})

    gg.clearResults()
    gg.searchNumber(string.format("%d;%d::50",data[1],data[2]),gg.TYPE_DWORD)
 
    if(gg.getResultCount()==4) then
       local simoleonsAddress = gg.getResults(4)
 
       simoleons[1] = getAddressValue(simoleonsAddress[1],gg.TYPE_DWORD)
       simoleons[2] = getAddressValue((simoleonsAddress[1]+0x8),gg.TYPE_DWORD)
       simoleons[3] = getAddressValue((simoleonsAddress[1]+0xC),gg.TYPE_DWORD)
    end
 
    gg.alert("%d;%d;%d",simoleons[1],simoleons[2],simoleons[3])
end

function getMaterialInfo(materialName, searchInfo, researchInfo, totalCount)
    gg.setVisible(false) 
    gg.clearResults()  
    gg.toast(materialName.."准备工作进行中 ......")
    gg.searchNumber(searchInfo, gg.TYPE_DWORD)
    gg.searchNumber(researchInfo, gg.TYPE_DWORD)
    if gg.getResultCount() ~= string.format("%d", totalCount) then 
       gg.alert(materialName.."代码初始化失败.") 
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

-- 获取新世纪格子信息
function prepareNeoMallGridInfo()
    local grid = {}
    
end

-- 获取选择的索引
function getSelectionInfo()
    local index = gg.choice(selectionInfo, nil, "刷材料")

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

-- 主函数入口
function main()
    gg.setVisible(false)
    gg.clearResults()


end

main()