--------------------------------------------------------------------------------------------
-- 1、本脚本为交易站上架半自动脚本
-- 2、本脚本在0.31版国服，1.28版国际服下测试通过
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
--                researchInfo = "优化搜索信息",
--                totalCount = 上架材料的总组数,
--                itemInfo = {
--                    {itemSearchInfo = "每个材料的特征标识码", itemCount = 上架材料的组数},
--                    ...
--                }
--            }
--      4.3.4、基础搜索信息遵照绿城的搜索条件定义，不一定兼容所有其他的人的搜索方法，
--             如果不同请自行修改相应的脚本
--      4.3.5、优化搜索信息遵照绿城的搜索条件定义，不一定兼容所有其他的人的搜索方法，
--             如果不同请自行修改相应的脚本
--      4.3.6、每个材料的特征标识码请遵照绿城提供的相关文档中的定义，不一定兼容其他人的数据
-- 5、以下内容为国际惯例，请务必遵守：
--    5.1、本脚本仅供个人学习LUA和GG使用，请勿用于任何的商业用途
--    5.2、对使用过程中出现的任何意外绿城不承担任何的责任
--    5.3、不会对使用也不要找我，因为我很懒（^*^）
--    5.4、本脚本的实现得到了某些****的启发，在此表示感谢
-- 6、哈哈哈，你们不知道的秘密，我是不会告诉你们我是雷锋
--    6.1、全自动上架脚本在路上，请不要期待ing
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

-- 各个物品区分特征码的偏移量
local EIGENVALUE_OFFSET = 40

-- 程序终止代码
<<<<<<< HEAD
local STOP_CODE = 999
=======
local STOP_CODE = 700
>>>>>>> 444d73ad6a046170e1df69c3ecc68f29fc79535c

-- 一级菜单选项
local selectInfo_1 = {
    "1. 仓库材料",
    "2. 扩地材料",
    "3. 博士材料",
    "4. 沙滩材料",
    "5. 高山材料",
    "6. 汉堡",
    "7. 绿色山谷",
    "8. 仙人掌峡谷",
    "9. 阳光岛屿",
    "10. 严寒峡湾",
    "11. 石灰岩峭壁",
    "12. 战争灾难物资 ->",
    "13. 退出"
}
-- 二级菜单选项
local selectInfo_2 = {
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
    -- 格式说明
    -- index：选择的索引编号
    -- searchInfo：搜索字符串
    -- researchInfo：再次查找的字符串
    -- totalCount：材料的总个数
    -- itemInfo：材料信息数组
    --    itemSearchInfo：材料的查找字符串
    --    itemCount：材料的组数

    -- 仓库材料
    {
        index = 1,
        searchInfo = "24;0;5;0;49;32;18::45",
        researchInfo = "24",
        totalCount = 12,
        itemInfo = {
            {itemSearchInfo = "13285930", itemCount = 4},
            {itemSearchInfo = "543978041", itemCount = 4},
            {itemSearchInfo = "21080992", itemCount = 4}
        }
    },
    -- 扩地材料
    {
        index = 2,
        searchInfo = "24;0;5;0;33;27::33",
        researchInfo = "24",
        totalCount = 12,
        itemInfo = {
            {itemSearchInfo = "12777566", itemCount = 4},
            {itemSearchInfo = "1206566498", itemCount = 4},
            {itemSearchInfo = "-1227768711", itemCount = 4}
        }
    },
    -- 博士材料
    {
        index = 3,
        searchInfo = "24;0;5;0;49;32;20::45",
        researchInfo = "24",
        totalCount = 12,
        itemInfo = {
            {itemSearchInfo = "-520565565", itemCount = 4},
            {itemSearchInfo = "-2038227", itemCount = 4},
            {itemSearchInfo = "112710515", itemCount = 4}
        }
    },
    -- 沙滩材料
    {
        index = 4,
        searchInfo = "24;0;5;0;33;28::33",
        researchInfo = "24",
        totalCount = 12,
        itemInfo = {
            {itemSearchInfo = "265268177", itemCount = 4},
            {itemSearchInfo = "265268178", itemCount = 4},
            {itemSearchInfo = "265268179", itemCount = 4}
        }
    },
    -- 高山材料
    {
        index = 5,
        searchInfo = "24;0;5;0;33;31::33",
        researchInfo = "24",
        totalCount = 12,
        itemInfo = {
            {itemSearchInfo = "745632329", itemCount = 4},
            {itemSearchInfo = "745632330", itemCount = 4},
            {itemSearchInfo = "745632331", itemCount = 4}
        }
    },
    -- 汉堡
    {
        index = 6,
        searchInfo = "16;0;3;0;33~65;25~43::33",
        researchInfo = "16",
        totalCount = 5,
        itemInfo = {
            {itemSearchInfo = "-1799384545", itemCount = 5},
            {itemSearchInfo = "270885747",itemCount = 0}
        }
    },
    -- 绿色山谷
    {
        index = 7,
        searchInfo = "16;0;3;0;33~65;25~43::33",
        researchInfo = "16",
        totalCount = 22,
        itemInfo = {
            {itemSearchInfo = "1553334434", itemCount = 1},
            {itemSearchInfo = "-2118495682", itemCount = 1},
            {itemSearchInfo = "1886510007", itemCount = 20}
        }
    },
    -- 仙人掌峡谷
    {
        index = 8,
        searchInfo = "16;0;3;0;33~65;25~43::33",
        researchInfo = "16",
        totalCount = 22,
        itemInfo = {
            {itemSearchInfo = "-1964329030", itemCount = 1},
            {itemSearchInfo = "-1290152913", itemCount = 1},
            {itemSearchInfo = "-75965445", itemCount = 20}
        }
    },
    -- 阳光岛屿
    {
        index = 9,
        searchInfo = "16;0;3;0;33~65;25~43::33",
        researchInfo = "16",
        totalCount = 22,
        itemInfo = {
            {itemSearchInfo = "248304484", itemCount = 1},
            {itemSearchInfo = "-1740539876", itemCount = 1},
            {itemSearchInfo = "449644219", itemCount = 20}
        }
    },
    -- 严寒峡湾
    {
        index = 10,
        searchInfo = "16;0;3;0;33~65;25~43::33",
        researchInfo = "16",
        totalCount = 22,
        itemInfo = {
            {itemSearchInfo = "1939782264", itemCount = 1},
            {itemSearchInfo = "1148007126", itemCount = 1},
            {itemSearchInfo = "1321484032", itemCount = 20}
        }
    },
    -- 石灰岩峭壁
    {
        index = 11,
        searchInfo = "16;0;3;0;33~65;25~43::33",
        researchInfo = "16",
        totalCount = 22,
        itemInfo = {
            {itemSearchInfo = "479440892", itemCount = 1},
            {itemSearchInfo = "193491386", itemCount = 1},
            {itemSearchInfo = "2090694637", itemCount = 20}
        }
    },
    -- 磁力之击
    {
        index = 101,
        searchInfo = "51;0;17;0;65::29",
        researchInfo = "51",
        totalCount = 5,
        itemInfo = {
            {itemSearchInfo = "1560176023", itemCount = 1},
            {itemSearchInfo = "253271711", itemCount = 2},
            {itemSearchInfo = "860715237", itemCount = 2}
        }
    },
    -- 滑稽之手
    {
        index = 102,
        searchInfo = "51;0;17;0;65::29",
        researchInfo = "51",
        totalCount = 2,
        itemInfo = {
            {itemSearchInfo = "-1247109630", itemCount = 1},
            {itemSearchInfo = "471968558", itemCount = 1}
        }
    },
    -- 死神之手
    {
        index = 103,
        searchInfo = "51;0;17;0;65::29",
        researchInfo = "51",
        totalCount = 6,
        itemInfo = {
            {itemSearchInfo = "2090081903", itemCount = 2},
            {itemSearchInfo = "352219700", itemCount = 2},
            {itemSearchInfo = "471968558", itemCount = 5}
        }
    },
    -- 修建传送门
    {
        index = 104,
        searchInfo = "51;0;17;0;65::29",
        researchInfo = "51",
        totalCount = 10,
        itemInfo = {
            {itemSearchInfo = "860715237", itemCount = 3},
            {itemSearchInfo = "-1247109630", itemCount = 3},
            {itemSearchInfo = "-1962827238", itemCount = 4}
        }
    },
    -- B级电影怪兽
    {
        index = 105,
        searchInfo = "51;0;17;0;65::29",
        researchInfo = "51",
        totalCount = 6,
        itemInfo = {
            {itemSearchInfo = "-1607480754", itemCount = 2},
            {itemSearchInfo = "-1247109630", itemCount = 2},
            {itemSearchInfo = "-1540742631", itemCount = 2}
        }
    },
    -- 响亮怒吼
    {
        index = 106,
        searchInfo = "51;0;17;0;65::29",
        researchInfo = "51",
        totalCount = 11,
        itemInfo = {
            {itemSearchInfo = "-1540742631", itemCount = 4},
            {itemSearchInfo = "352219700", itemCount = 3},
            {itemSearchInfo = "-1962827238", itemCount = 4}
        }
    },
    -- 蟒蛇
    {
        index = 107,
        searchInfo ="51;0;17;0;65::29",
        resarchInfo = "51",
        totalCount = 8,
        itemInfo = {
            {itemSearchInfo = "1560176023",itemCount = 2},
            {itemSearchInfo = "352219700",itemCount = 3},
            {itemSearchInfo = "-1607480754",itemCount = 3}
        }
    },
    -- 飞行的v机器人
    {
        index = 108,
        searchInfo = "51;0;17;0;65::29",
        resarchInfo = "51",
        totalCiunt = 2,
        itemInfo = {
            {itemSearchInfo = "2090081903",itemCount = 1},
            {itemSearchInfo = "-916988905",itemCount = 1}
        }
    },
    -- 破盾
    {
        index = 109,
        searchInfo ="51;0;17;0;65::29",
        resarchInfo = "51",
        totalCiunt = 7,
        itemInfo = {
            {itemSearchInfo = "-916988905",itemCount = 3},
            {itemSearchInfo = "-1962827238",itemCount = 3},
            {itemSearchInfo = "226338627",itemCount= 1}
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
<<<<<<< HEAD
    index = gg.choice(selectInfo_1, nil, "模拟城市")
    if index == #selectInfo_1 - 1 then
        index = gg.choice(selectInfo_2, nil, "模拟城市")
=======
    index = gg.choice(selectInfo_1, nil, "模拟城市-北极光")
    if index == #selectInfo_1 - 1 then
        index = gg.choice(selectInfo_2, nil, "模拟城市-北极光")
>>>>>>> 444d73ad6a046170e1df69c3ecc68f29fc79535c
        if index ~= nil then
            index = 100 + index
        end
    end
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
    gg.searchNumber(searchInfo.researchInfo, gg.TYPE_DWORD)
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
<<<<<<< HEAD
    gg.toast(string.format("最终价格为: %d", sellPrice))
=======
>>>>>>> 444d73ad6a046170e1df69c3ecc68f29fc79535c
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
<<<<<<< HEAD

        --gg.toast(string.format("设定价格为: %d", SELL_PRICE))
=======
>>>>>>> 444d73ad6a046170e1df69c3ecc68f29fc79535c
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
    -- 初始化售卖价格，价格变动范围在(1~SELL_PRICE_MAX_TIMES)*SELL_ITEM_COUNT之间，步长为SELL_ITEM_COUNT
<<<<<<< HEAD
    -- math.randomseed(os.time())  
    -- SELL_PRICE = SELL_ITEM_COUNT * math.random(SELL_PRICE_MAX_TIMES)

    local data = gg.prompt({'确定材料价格'},{[1]="输入材料价格"})
    SELL_PRICE = data[1]
    gg.toast(string.format("设定价格为: %d", SELL_PRICE))

=======
    math.randomseed(os.time())
    SELL_PRICE = SELL_ITEM_COUNT * math.random(SELL_PRICE_MAX_TIMES)
>>>>>>> 444d73ad6a046170e1df69c3ecc68f29fc79535c
    --选择要上架的材料信息
    local selectedIndex = getSelectIndex()
    if selectedIndex ~= nil and selectedIndex ~= #selectInfo_1 and selectedIndex ~= (100 + #selectInfo_2) then
        -- 获取搜索条件
        local searchInfo = getSearchInfo(selectedIndex)
<<<<<<< HEAD
        gg.toast(string.format("成功获取材料搜索信息！: %d",searchInfo.totalCount))
=======
        gg.toast("成功获取材料搜索信息！")
>>>>>>> 444d73ad6a046170e1df69c3ecc68f29fc79535c
        --获取交易站信息
        local tradeSpotInfo = getTradeSpotInfo()
        gg.toast("成功获取交易站信息！")
        -- 获取材料代码
        local materialInfo = getMaterialInfo(searchInfo)
<<<<<<< HEAD
        gg.toast(string.format("成功获取材料代码信息！: %d",#materialInfo))
=======
        gg.toast("成功材料代码信息！")
>>>>>>> 444d73ad6a046170e1df69c3ecc68f29fc79535c
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
