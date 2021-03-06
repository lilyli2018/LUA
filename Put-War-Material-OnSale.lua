--------------------------------------------------------------------------------------------
-- 1、本脚本为交易站战争材料上架半自动脚本
-- 2、本脚本在0.31版国服下测试通过
-- 3、已知问题：偶发性会报 -- 获取交易站信息失败！的错误，出现改错误时，请重新进入游戏重试
--    （后期会修正该问题）
-- 4、本脚本采取了数据与脚本分离的方式实现，因此如果需要新增上架材料的信息，只需修改字典数据即可
--    不需要对实现脚本进行任何的更改。具体的修改方法如下：
--    4.1、增加一级菜单的选项，需要注意以下几点：
--      4.1.1、二级菜单一定放在倒数第二位的位置
--      4.1.2、退出菜单一定放在最后一位
--      4.1.3、一级菜单最多支持97个选项（不包括退出和二级菜单）
--    4.2、增加二级菜单选项，需要注意以下几点：
--      4.2.1、保证退出放在最后一位
--      4.2.2、二级菜单最多支持98个选项（不包括退出）
--    4.3、对应菜单的修改，搜索数据需要如下修改
--      4.3.1、搜索数据支持单个和打包模式。也就是一次可以上架一个材料，也可以按照要求上架多个材料
--      4.3.2、每种材料上架的个数由SELL_ITEM_COUNT确定，为了防止被黑建议不要超过5
--      4.3.3、以下是具体的材料搜索数据的格式说明
--            {
--                index = 菜单选择索引=菜单选项值*对应的倍数（一级菜单倍数为1，二级菜单倍数为100）,
--                searchInfo = "基础搜索信息",
--                totalCount = 上架材料的总组数,
--                itemInfo = {
--                    {
--                          itemIndex = "每个材料序号", 
--                          itemCount = 上架材料的组数
--                    },
--                    ...
--                }
--            }
--      4.3.4、基础搜索信息遵照绿绿的搜索条件定义，不一定兼容所有其他的人的搜索方法，
--             如果不同请自行修改相应的脚本
--      4.3.5、优化搜索信息遵照绿绿的搜索条件定义，不一定兼容所有其他的人的搜索方法，
--             如果不同请自行修改相应的脚本
--      4.3.6、每个材料的特征标识码请遵照绿绿提供的相关文档中的定义，不一定兼容其他人的数据
-- 5、以下内容为国际惯例，请务必遵守：
--    5.1、本脚本仅供个人学习LUA和GG使用，请勿用于任何的商业用途
--    5.2、对使用过程中出现的任何意外绿绿不承担任何的责任
--    5.4、本脚本的实现得到了某些****的启发，在此表示感谢
--------------------------------------------------------------------------------------------

-- 售卖商品个数
local SELL_ITEM_COUNT = 5

-- 交易站数据的索引值
local INDEX_MAX_SELL_COUNT = 1
local INDEX_SELL_COUNT = 2
local INDEX_PRICE = 3
local INDEX_ADV_FLAG = 4
local INDEX_MATERIAL_CODE = 5

--售卖价格
local SELL_PRICE = 0

--售卖价格变动最大系数
local SELL_PRICE_MAX_TIMES = 20

-- 交易站数据偏移信息
local tradeSpotOffset = {28, 32, 36, 44, 48}

-- 交易站搜索信息
local tradeSpotSearchInfo = {searchInfo = "20;6;32::9", dataCount = 3, baseIndex = 1}

-- 材料代码固定动态码的基准偏移量
local MATERIAL_CODE_OFFSET = -4
local WAR_MATERIAL_CODE_OFFSET = 112

-- 各个物品区分特征码的偏移量
local EIGENVALUE_OFFSET = 40

-- 程序终止代码
local STOP_CODE = 13

-- 一级菜单选项
local selectInfo_1 = {
    "1. 磁力之击",
    "2. 滑稽之手",
    "3. 死神之手",
    "4. 修建传送门",
    "5. B级电影怪兽",
    "6. 响亮怒吼",
    "7. 蟒蛇",
    "8. 飞行的v机器人",
    "9. 破盾",
    "10. 退出"
}

--材料搜索信息表
local materialSearchInfo = {
    -------------------------------------------------------
    -- 战争材料的浮动码依以下顺序排列，每个之间的偏移量为112
    ----1. 弹药箱
    ----2. 铁砧
    ----3. 望远镜
    ----4. 消防栓
    ----5. 汽油
    ----6. 扩音器
    ----7. 老虎钳
    ----8. 马桶塞
    ----9. 螺旋桨
    ----10. 橡胶靴
    ----11. 小黄鸭
    ----12. 医疗箱
    --------------------------------------------------------
    -- 格式说明
    -- index：选择的索引编号
    -- totalCount：材料的总个数
    -- itemInfo：材料信息数组
    --    itemIndex：材料的序号
    --    itemCount：材料的组数

    -- 磁力之击
    {
        index = 1,
        searchInfo = "2090081903;2090081903::5",
        totalCount = 5,
        itemInfo = {
            {itemIndex = 3, itemPrice = 700, itemCount = 1}, --望远镜
            {itemIndex = 4, itemPrice = 700, itemCount = 2}, --消防栓
            {itemIndex = 2, itemPrice = 700, itemCount = 2} --铁砧
        }
    },
    -- 滑稽之手
    {
        index = 2,
        searchInfo = "2090081903;2090081903::5",
        totalCount = 2,
        itemInfo = {
            {itemIndex = 8, itemPrice = 700, itemCount = 1}, --马桶塞
            {itemIndex = 11, itemPrice = 700, itemCount = 1} --小黄鸭
        }
    },
    -- 死神之手
    {
        index = 3,
        searchInfo = "2090081903;2090081903::5",
        totalCount = 9,
        itemInfo = {
            {itemIndex = 1, itemPrice = 2220, itemCount = 2},--弹药箱
            {itemIndex = 11, itemPrice = 700, itemCount = 2},--小黄鸭
            {itemIndex = 7, itemPrice = 700, itemCount = 5}--老虎钳
        }
    },
    -- 修建传送门
    {
        index = 4,
        searchInfo = "2090081903;2090081903::5",
        totalCount = 10,
        itemInfo = {
            {itemIndex = 4, itemPrice = 700, itemCount = 3}, --消防栓
            {itemIndex = 8, itemPrice = 700, itemCount = 3}, --马桶塞
            {itemIndex = 9, itemPrice = 700, itemCount = 4} --螺旋桨
        }
    },
    -- B级电影怪兽
    {
        index = 5,
        searchInfo = "2090081903;2090081903::5",
        totalCount = 6,
        itemInfo = {
            {itemIndex = 10, itemPrice = 700, itemCount = 2}, --橡胶靴
            {itemIndex = 8, itemPrice = 700, itemCount = 2}, --马桶塞
            {itemIndex = 6, itemPrice = 700, itemCount = 2} --扩音器
        }
    },
    -- 响亮怒吼
    {
        index = 6,
        searchInfo = "2090081903;2090081903::5",
        totalCount = 11,
        itemInfo = {
            {itemIndex = 6, itemPrice = 700, itemCount = 4}, --扩音器
            {itemIndex = 7, itemPrice = 700, itemCount = 3}, --老虎钳
            {itemIndex = 9, itemPrice = 700, itemCount = 4} --螺旋桨
        }
    },
    -- 蟒蛇怒缠
    {
        index = 7,
        searchInfo = "2090081903;2090081903::5",
        totalCount = 8,
        itemInfo = {
            {itemIndex = 3, itemPrice = 700, itemCount = 2}, --望远镜
            {itemIndex = 7, itemPrice = 700, itemCount = 3}, --老虎钳
            {itemIndex = 10, itemPrice = 700, itemCount = 3} --橡胶靴
        }
    },
    -- 飞行的V机器人
    {
        index = 8,
        searchInfo = "2090081903;2090081903::5",
        totalCiunt = 2,
        itemInfo = {
            {itemIndex = 1, itemPrice = 2220, itemCount = 1}, --弹药箱
            {itemIndex = 5, itemPrice = 700, itemCount = 1} --汽油
        }
    },
    -- 护盾破坏者
    {
        index = 9,
        searchInfo = "2090081903;2090081903::5",
        totalCiunt = 6,
        itemInfo = {
            {itemIndex = 5, itemPrice = 700, itemCount = 5}, --汽油
            {itemIndex = 12, itemPrice = 700, itemCount = 1} --医疗箱
        }
    }
}

--获取指定地址的数据
--参数：address：要获取数据的地址
--     dataType：获取数据的类型，取值：
--         gg.TYPE_AUTO（自动，不建议使用）
--         gg.TYPE_BYTE（1字节整数）
--         gg.TYPE_DOUBLE（双精度数字）
--         gg.TYPE_DWORD（4字节整数）
--         gg.TYPE_FLOAT（浮点数）
--         gg.TYPE_QWORD（8字节整数）
--         gg.TYPE_WORD（2字节整数）
--         gg.TYPE_XOR（布尔值）
--返回：获取到的数据值
function getAddressValue(address, dataType)
    local temp = {}
    temp[1] = {}
    temp[1].address = address
    temp[1].flags = dataType
    temp = gg.getValues(temp)
    return temp[1].value
end

--设定指定地址的数据
--参数：address：要获取数据的地址
--     dataType：获取数据的类型，取值：
--         gg.TYPE_AUTO（自动，不建议使用）
--         gg.TYPE_BYTE（1字节整数）
--         gg.TYPE_DOUBLE（双精度数字）
--         gg.TYPE_DWORD（4字节整数）
--         gg.TYPE_FLOAT（浮点数）
--         gg.TYPE_QWORD（8字节整数）
--         gg.TYPE_WORD（2字节整数）
--         gg.TYPE_XOR（布尔值）
--    value：要设置的值
--    frozenFlag：冻结标志，取值：true/false
--返回：无
function setAddressValue(address, dataType, value, frozenFlag)
    local temp = {}
    temp[1] = {}
    temp[1].address = address
    temp[1].value = value
    temp[1].flags = dataType
    temp[1].freeze = frozenFlag
    gg.setValues(temp)
end

-- 获取选择的索引
-- 通过选项值获取对用的搜索信息内容。一级菜单的倍数为1，二级菜单的倍数为100
-- 返回的索引值，索引值=选择索引*倍数
function getSelectIndex()
    index = gg.choice(selectInfo_1, nil, "模拟城市-小绿绿")

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

-- 获取交易站信息
function getTradeSpotInfo()
    local tradeSpotInfo = {}
    gg.clearResults()
    gg.searchNumber(tradeSpotSearchInfo.searchInfo, gg.TYPE_DWORD)
    searchResultCount = gg.getResultsCount()
    if searchResultCount ~= tradeSpotSearchInfo.dataCount then
        gg.clearResults()
        gg.alert("获取交易站信息失败！")
        os.exit()
    end
    searchResult = gg.getResults(searchResultCount)
    for i = 1, #tradeSpotOffset do
        tradeSpotInfo[i] = searchResult[tradeSpotSearchInfo.baseIndex].address + tradeSpotOffset[i]
    end
    return tradeSpotInfo
end

-- 获取材料信息
-- 本信息中只存储材料代码，一组一个材料代码，多组会出现材料代码重复
function getMaterialInfo(searchInfo)
    local materialInfo = {}
    local currentIndex = 1
    gg.clearResults()
    gg.searchNumber(searchInfo.searchInfo, gg.TYPE_DWORD)
    --gg.searchNumber(searchInfo.researchInfo, gg.TYPE_DWORD)
    searchResultCount = gg.getResultsCount()
    resultInfo = gg.getResults(searchResultCount)
    for i = 1, #resultInfo do
        local eigenvalue = getAddressValue(resultInfo[i].address + EIGENVALUE_OFFSET, gg.TYPE_DWORD)
        for j = 1, #searchInfo.itemInfo do
            if eigenvalue == searchInfo.itemInfo[j].itemSearchInfo then
                for k = 1, searchInfo.itemInfo[j].itemCount do
                    materialInfo[currentIndex] = resultInfo[i].address + MATERIAL_CODE_OFFSET - 2 ^ 32
                    currentIndex = currentIndex + 1
                end
            end
        end
    end
    return materialInfo
end

-- 更新材料信息
function updateMaterialInfo(tradeSpotInfo, materialCode, sellPrice)
    -- 设置最大一次售卖的数量
    setAddressValue(tradeSpotInfo[INDEX_MAX_SELL_COUNT], gg.TYPE_DWORD, SELL_ITEM_COUNT, false)
    -- 设置当前的售卖数量
    setAddressValue(tradeSpotInfo[INDEX_SELL_COUNT], gg.TYPE_DWORD, SELL_ITEM_COUNT, false)
    -- 设置总价格
    setAddressValue(tradeSpotInfo[INDEX_PRICE], gg.TYPE_DWORD, sellPrice, false)
    -- 设置广告标志
    setAddressValue(tradeSpotInfo[INDEX_ADV_FLAG], gg.TYPE_DWORD, 0, false)
    -- 设置售卖物品的代码
    setAddressValue(tradeSpotInfo[INDEX_MATERIAL_CODE], gg.TYPE_DWORD, materialCode, false)
end

--材料上架
function materialOnShelf(tradeSpotInfo, materialInfo)
    currentMaterialIndex = 1
    while true do
        if getAddressValue(tradeSpotInfo[INDEX_PRICE], gg.TYPE_DWORD) == STOP_CODE then
            gg.alert("您终止了本脚本！")
            gg.clearResults()
            os.exit()
        end
        if getAddressValue(tradeSpotInfo[INDEX_PRICE], gg.TYPE_DWORD) ~= SELL_PRICE then
            updateMaterialInfo(tradeSpotInfo, materialInfo[currentMaterialIndex], SELL_PRICE)
            if currentMaterialIndex == #materialInfo then
                currentMaterialIndex = 1
            else
                currentMaterialIndex = currentMaterialIndex + 1
            end
        end
    end
end

--主函数入口
function runMe()
    gg.setVisible(false)
    gg.clearResults()
    -- 初始化售卖价格，价格必须设置为相应材料的最低价格，默认为700
    -- math.randomseed(os.time())
    -- SELL_PRICE = SELL_ITEM_COUNT * math.random(SELL_PRICE_MAX_TIMES)
    SELL_PRICE = 700
    --选择要上架的材料信息
    local selectedIndex = getSelectIndex()
    if selectedIndex ~= nil and selectedIndex ~= #selectInfo_1 then
        -- 获取搜索条件
        local searchInfo = getSearchInfo(selectedIndex)
        gg.toast("成功获取材料搜索信息！")
        --获取交易站信息
        local tradeSpotInfo = getTradeSpotInfo()
        gg.toast("成功获取交易站信息！")
        -- 获取材料代码
        local materialInfo = getMaterialInfo(searchInfo)
        gg.toast("成功材料代码信息！")
        if #materialInfo == searchInfo.totalCount then
            gg.alert("所有的信息已经收集完成，您可以在交易站中任意点击上架了！如果要结束上架，请将商品的价格设置成" .. STOP_CODE .. "。")
            -- 更新材料代码
            materialOnShelf(tradeSpotInfo, materialInfo)
        else
            gg.alert("获取到的材料个数与设定的不一致！")
        end
    else
        gg.alert("您取消了本操作")
    end
    gg.clearResults()
    os.exit()
end

runMe()
