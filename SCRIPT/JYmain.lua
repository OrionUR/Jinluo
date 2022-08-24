----------------------------------------
--
-- orionids：以下为主程序以及相关函数
-- 
----------------------------------------


-- 加载所有lua文件
function IncludeFile()
    package.path = CONFIG.ScriptLuaPath -- 设置加载路径
    -- 加载其他文件，使用require避免重复加载
    require("JYconst")                  -- 常量定义
    require("JYwar")                    -- 战斗程序
    require("JYgraphic")                -- 图像画面程序
    require("kdef")                     -- 事件程序
    require("ItemInfo")                 -- 物品信息
    require("PersonInfo")               -- 人物信息
    require("SkillInfo")                -- 武功信息
    require("MP")                       -- 门派相关
end

-- 设置游戏内部使用的全程变量
function SetGlobal()
    jy = {}                             -- 非战斗状态时使用的全局变量

    jy.status = GAME_INIT               -- 游戏状态
    jy.base = {}                        -- 基本数据
    jy.person_num = 0                   -- 人物数量
    jy.person = {}                      -- 人物数据
    jy.thing_num = 0                    -- 物品数量
    jy.thing = {}                       -- 物品数据
    jy.scene_num = 0                    -- 场景数量
    jy.scene = {}                       -- 场景数据
    jy.wugong_num = 0                   -- 武功数量
    jy.wugong = {}                      -- 武功数据
    jy.shop_num = 0                     -- 商店数量
    jy.shop = {}                        -- 商店数据

    jy.my_current_pic = 0               -- 主角当前走路贴图在贴图文件中偏移
    jy.my_pic = 0                       -- 主角当前贴图
    jy.my_tick = 0                      -- 主角没有走路的持续帧数
    jy.my_tick2 = 0                     -- 显示事件动画的节拍
    jy.load_time = 0                    -- 读取时间
    jy.save_time = 0                    -- 保存时间
    jy.game_time = 0                    -- 游戏时长
    jy.gold = 0                         -- 游戏银两
    jy.year = 1                         -- 年
    jy.month = 1                        -- 月
    jy.day = 1                          -- 日

    jy.sub_scene = -1                   -- 当前子场景编号
    jy.sub_scene_x = 0                  -- 子场景显示位置偏移，场景移动指令使用
    jy.sub_scene_y = 0
    jy.thing_use = -1
    jy.current_d = -1                   -- 当前调用D*的编号
    jy.old_d_pass = -1                  -- 上次触发路过事件的D*编号，避免多次触发
    jy.current_event_type = -1          -- 当前触发事件的方式，1 空格，2 物品，3 路过
    jy.current_thing = -1               -- 当前选择物品，触发事件使用
    jy.mmap_music = -1                  -- 切换大地图音乐，返回大地图时，如果设置，则播放此音乐
    jy.current_midi = -1                -- 当前播放的音乐id，用来在关闭音乐时保存音乐id
    jy.enable_music = 1                 -- 是否播放音乐，0 不播放，1 播放
    jy.enable_sound = 1                 -- 是否播放音效，0 不播放，1 播放

    war = {}                            -- 战斗使用的全程变量
                                        -- 这里占个位置，因为程序后面不允许全局变量了
                                        -- 具体内容在WarSetGlobal函数中

    auto_move_tab = {[0] = 0}
    jy.restart = 0                      -- 返回游戏初始界面
    jy.walk_count = 0                   -- 走路计步
end

-- 主程序入口
function JY_Main()
    os.remove("debug.txt")              -- 清除以前的debug输出
    xpcall(JY_Main_Sub, MyErrFun)       -- 捕获调用错误
end

-- 错误处理，打印错误信息
function MyErrFun(err)
    Debug(err)                      -- 输出错误信息
    Debug(debug.traceback())        -- 输出调用堆栈信息
end

-- 真正的游戏主程序入口
function JY_Main_Sub()
    ct = {}
    IncludeFile()                       -- 导入其他模块
    SetGlobalConst()                    -- 设置全局变量cc，在JYconst.lua
    SetGlobal()                         -- 设置全局变量jy

    -- 禁止访问全局变量
    setmetatable(_G, {
        __newindex = function (_, n)
            error("attempt read write to undeclared variable " .. n, 2)
        end,
        __index = function (_, n)
            error("attempt read read to undeclared variable " .. n, 2)
        end
    })

    Debug("JY_Main start")

    -- 初始化随机数发生器
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
    jy.status = GAME_START              -- 改变游戏状态
    lib.PicInit(cc.palette_file)        -- 加载原来的256色调色板
    Gra_FillColor()                     -- 屏幕黑屏

    Gra_SetAllPNGAddress()              -- 载入所有贴图地址并分配id

    while true do
        if jy.restart == 1 then
            jy.restart = 0
            jy.status = GAME_START
        end
        if jy.status == GAME_END then
            break
        end

        PlayMidi(75)                    -- 播放音乐
        Gra_Cls()                       -- 清屏
        lib.ShowSlow(20, 0)             -- 缓慢显示画面
        

        -- local r = StartMenu()           -- 显示游戏开始菜单画面
        local r = TitleSelection()
        if r ~= nil then
            return
        end

        -- lib.LoadPicture("", 0, 0)               -- 载入图片
        -- GetKey()                            -- 获取键值

        -- Game_Cycle()                            -- 游戏循环
    end
end

-- 清理lua内存
function CleanMemory()
    if CONFIG.CleanMemory == 1 then
        -- 做一次完整的垃圾收集循环
        collectgarbage("collect")
    end
end

-- 游戏开始菜单画面
function StartMenu()
    Gra_Cls()

    local menu_return = TitleSelection()
    if menu_return == 1 then                    -- 新的游戏
        Gra_Cls()
        -- NewGame()

        if jy.restart == 1 then
            do return end
        end

        -- 畅想杨过初始场景
        if jy.base["畅想"] == 58 then
            jy.sub_scene = 18
            jy.base["人X"] = 144
            jy.base["人Y"] = 218
            jy.base["人X1"] = 30
            jy.base["人Y1"] = 32
        -- 其他人
        else
            jy.sub_scene = cc.new_game_scene_id
            jy.base["人X1"] = cc.new_game_scene_x
            jy.base["人Y1"] = cc.new_game_scene_y
        end

        -- 男女主角判定
        if jy.person[0]["性别"] == 0 then
            jy.my_pic = cc.new_person_pic_m
        else
            jy.my_pic = cc.new_person_pic_f
        end

        jy.status = GAME_SMAP
        jy.mmap_music = -1
        CleanMemory()
        Init_SMap(0)
        lib.ShowSlow(20, 0)

        -- 开局事件
        if jy.base["畅想"] == 58 then             -- 畅想杨过
            CallCEvent(4187)
        else                                      -- 其他人
            CallCEvent(691)
        end

        -- 畅想开局获得自身的装备
        if jy.base["畅想"] > 0 then
            if jy.person[0]["武器"] ~= -1 and jy.base["畅想"] ~= 27 then
                instruct_2(jy.person[0]["武器"], 1)
                jy.person[0]["武器"] = -1
            end
            if jy.person[0]["防具"] ~= -1 then
                instruct_2(jy.person[0]["防具"], 1)
                jy.person[0]["防具"] = -1
            end
            if jy.person[0]["坐骑"] ~= -1 then
                instruct_2(jy.person[0]["坐骑"], 1)
                jy.person[0]["坐骑"] = -1
            end
        end

        -- 畅想尹克西获得一万两
        if jy.base["畅想"] == 158 then
            instruct_2(174, 10000)
        end
        -- 标主可以在云岭洞花钱学习迷踪步
        if jy.base["标准"] > 0 then
            addevent(41, 0, 1, 4144, 1, 8694)
        end
        instruct_10(104)
        instruct_10(105)

        -- 周目奖励
        os.remove(CONFIG.DataPath .. 'TgJL')
        for i = 1, #cc.commodity do
            if cc.commodity[i][5] > 0 then
                instruct_2(cc.commodity[i][1], cc.commodity[i][5])
                cc.commodity[i][5] = 0
            end
        end
        tgsave(1)

        cc.tgjl = {}
    -- 载入旧的进度
    elseif menu_return == 2 then
        --lib.LoadPNG(5, 501 * 2, -1, -1, 1)
        --Gra_ShowScreen()
        Gra_DrawStrBox(-1, cc.screen_h * 1 / 6 - 20, "读取进度", LimeGreen, cc.font_big3, C_GOLD)
        -- Gra_DrawStrBox(-1, cc.screen_h / 2 - 20, "读取进度", LimeGreen, cc.font_big2, C_GOLD)
        -- local r = SaveList()
        -- -- ESC重新返回选项
        -- if r < 1 then
        --     local s = StartMenu()
        --     return s
        -- end

        -- Gra_DrawStrBox(-1, cc.start_menu_y, "请稍候...", C_GOLD, cc.default_font)
        Gra_ShowScreen()
        Delay(2000)
        -- local result = Loadrecord(r)
        -- if result ~= nil then
        --     return StartMenu()
        -- end

        -- if jy.base["无用"] ~= -1 then
        --     if jy.sub_scene < 0 then
        --         CleanMemory()
        --     end
        --     lib.ShowSlow(20, 1)
        --     jy.status = GAME_SMAP
        --     jy.sub_scene = jy.base["无用"]
        --     jy.mmap_music = -1
        --     jy.my_pic = Gra_GetMyPic()
        --     Init_SMap(1)
        -- else
        --     jy.sub_scene = -1
        --     jy.status = GAME_FIRSTMMAP
        -- end
    elseif menu_return == 3 then
        return -1
    end
end

-- 游戏开始画面选择
function TitleSelection()
    Debug("TitleSelection")
    local choice = 1            -- 选项，1开始游戏，2载入游戏，3退出游戏，默认在1的位置
    -- 选项
    -- 未选中时的贴图，选中时的贴图，x轴位置，y轴位置
    local buttons = {
        {3, 6, 550, 350},
        {4, 7, 550, 450},
        {5, 8, 550, 550}
    }
    -- 鼠标位置判定
    -- x轴起始位置，y轴起始位置，x轴结束位置，y轴结束位置
    local mouse_detect = {
        {450, 300, 650, 395},
        {450, 400, 650, 495},
        {450, 500, 650, 595}
    }
    local tmp                   -- 临时变量，用来临时存放数据
    local picid                 -- 图像id

    -- 判断鼠标是否在按钮上
    -- mx, my：x轴y轴
    local function OnButton(mx, my)
        local result = 0        -- 返回值，确定鼠标在的位置
        
        for i = 1, #mouse_detect do
            if mx >= mouse_detect[i][1] and mx <= mouse_detect[i][3] and my >= mouse_detect[i][2] and my <= mouse_detect[i][4] then
                result = i
                break
            end
        end
    
        return result
    end

    while true do
        if jy.restart == 1 then
            return
        end
        -- local keypress, ktype, mx, my = lib.GetKey()
        local keypress, ktype, mx, my = WaitKey()
        -- 按键「下」和「右」效果一致，都是跳向下一个选项
        if keypress == VK_DOWN or keypress == VK_RIGHT then
            PlayWav(77)
            choice = choice + 1
            if choice > #buttons then
                choice = 1
            end
        -- 按键「上」和「左」效果一致，都是跳向上一个选项
        elseif keypress == VK_UP or keypress == VK_LEFT then
            PlayWav(77)
            choice = choice - 1
            if choice < 1 then
                choice = #buttons
            end
        -- 使用鼠标操作
        else
            if ktype == 2 or ktype == 3 then
                -- 鼠标在选项范围内，则选中该选项
                tmp = OnButton(mx, my)
                if tmp > 0 then
                    choice = tmp
                    PlayWav(77)
                end
            end
            -- 空格或回车或鼠标在左键触发判定
            if keypress == VK_RETURN or (ktype == 3 and OnButton(mx, my) > 0) then
                break
            end
        end

        Gra_Cls()

        for i = 1, #buttons do
            -- -- 选项贴图
            picid = buttons[i][1]
            if i == choice then
                picid = buttons[i][2]
            end
            
            -- UI的fileid = 5
            lib.LoadPNG(5, picid * 2, buttons[i][3], buttons[i][4], 1)
        end

        -- 显示版本号
        Gra_DrawString(600, 250, cc.version, M_Indigo, cc.font_big3)
        Gra_ShowScreen()
        Delay(cc.frame)
    end

    return choice
end

-- 选择新游戏，设置主角初始属性
function NewGame()
end

-- 游戏主循环
function GameCycle()
end

-- 初始化大地图数据
function InitMMap()
end

-- 播放midi
-- id：要播放的音乐id
function PlayMidi(id)
    jy.current_midi = id
    if jy.enable_music == 0 then                -- 如果游戏内设置为不播放音乐，则返回
        return
    end
    if id >= 0 then                             -- 调用C函数播放设定的音乐路径的音乐，音乐为id + 1
        lib.PlayMIDI(string.format(cc.midi_file, id + 1))
    end
end

-- 播放音效
-- id：要播放的音效id
function PlayWav(id)
    if jy.enable_sound == 0 then
        return
    end
    if id >= 0 then
        lib.PlayWAV(string.format(cc.e_file, id))
    end
end

-- 读取游戏进度
-- id = 0 新进度，= 1/2/3 进度
-- 这里是先把数据读入Byte数组中，然后定义访问相应表的方法，在访问表时直接从数组访问
-- 与以前的实现相比，从文件中读取和保存到文件的时间显著加快。而且内存占用少了
function LoadRecord(id)
    local zipfile = string.format('data/save/Save_%d', id)
    if id ~= 0 and (existFile(zipfile) == false) then
        QZXS("此存档数据不全，不能读取，请选择其他存档或重新开始")
        return -1
    end
    Byte.unzip(zipfile, 'r.grp', 'd.grp', 's.grp', 'tjm')
    
    local time = GetTime()

    -- 读取R*.idx文件
    local data = Byte.create(6 * 4)
    Byte.loadfile(data, cc.r_idx_filename[0], 0, 6 * 4)

    local idx = {}
    idx[0] = 0
    for i = 1, 6 do
        idx[i] = Byte.get32(data, 4 * (i - 1))
    end

    local grpFile = 'r.grp'
    local sFile = 's.grp'
    local dFile = 'd.grp'
    if id == 0 then
        grpFile = cc.r_grp_filename[id]
        sFile = cc.s_filename[id]
        dFile = cc.d_filename[id]
    end

    -- 读取R*.grp文件
    -- 基本数据
    jy.data_base = Byte.create(idx[1] - idx[0])
    Byte.loadfile(jy.data_base, grpFile, idx[0], idx[1] - idx[0])
    -- 设置访问基本数据的方法，这样就可以用访问表的方式访问了
    -- 而不用把二进制数据转化为表，节约加载时间和空间
    local meta_t = {
        __index = function(t, k)
            return GetDataFromStruct(jy.data_base, 0, cc.base_s, k)
        end,

        __newindex = function(t, k, v)
            SetDataFromStruct(jy.data_base, 0, cc.base_s, k, v)
        end
    }
    setmetatable(jy.base, meta_t)

    -- 人物数据
    jy.person_num = math.floor((idx[2] - idx[1]) / cc.person_size)
    jy.data_person = Byte.create(cc.person_size * jy.person_num)
    Byte.loadfile(jy.data_person, grpFile, idx[1], cc.person_size * jy.person_num)
    for i = 0, jy.person_num - 1 do
        jy.person[i] = {}
        local meta_t = {
            __index = function(t, k)
                return GetDataFromStruct(jy.data_person, i * cc.person_size, cc.person_s, k)
            end,
    
            __newindex = function(t, k, v)
                SetDataFromStruct(jy.data_person, i * cc.person_size, cc.person_s, k, v)
            end
        }
        setmetatable(jy.person[i], meta_t)
    end

    -- 物品数据
    jy.thing_num = math.floor((idx[3] - idx[2]) / cc.thing_size)
    jy.data_thing = Byte.create(cc.thing_size * jy.thing_num)
    Byte.loadfile(jy.data_thing, grpFile, dix[2], cc.thing_size * jy.thing_num)
    for i = 0, jy.thing_num - 1 do
        jy.thing[i] = {}
        local meta_t = {
            __index = function(t, k)
                return GetDataFromStruct(jy.data_thing, i * cc.thing_size, cc.thing_s, k)
            end,
    
            __newindex = function(t, k, v)
                SetDataFromStruct(jy.data_thing, i * cc.thing_size, cc.thing_s, k, v)
            end
        }
        setmetatable(jy.thing[i], meta_t)
    end

    -- 场景数据
    jy.scene_num = math.floor((idx[4] - idx[3]) / cc.scene_size)
    jy.data_scene = Byte.create(cc.scene_size * jy.scene_num)
    Byte.loadfile(jy.data_scene, grpFile, dix[3], cc.scene_size * jy.scene_num)
    for i = 0, jy.scene_num - 1 do
        jy.scene[i] = {}
        local meta_t = {
            __index = function(t, k)
                return GetDataFromStruct(jy.data_scene, i * cc.scene_size, cc.scene_s, k)
            end,
    
            __newindex = function(t, k, v)
                SetDataFromStruct(jy.data_scene, i * cc.scene_size, cc.scene_s, k, v)
            end
        }
        setmetatable(jy.scene[i], meta_t)
    end

    -- 武功数据
    jy.wugong_num = math.floor((idx[5] - idx[4]) / cc.wugong_size)
    jy.data_wugong = Byte.create(cc.wugong_size * jy.wugong_num)
    Byte.loadfile(jy.data_wugong, grpFile, dix[4], cc.wugong_size * jy.wugong_num)
    for i = 0, jy.wugong_num - 1 do
        jy.wugong[i] = {}
        local meta_t = {
            __index = function(t, k)
                return GetDataFromStruct(jy.data_wugong, i * cc.wugong_size, cc.wugong_s, k)
            end,
    
            __newindex = function(t, k, v)
                SetDataFromStruct(jy.data_wugong, i * cc.wugong_size, cc.wugong_s, k, v)
            end
        }
        setmetatable(jy.wugong[i], meta_t)
    end

    -- 商店数据
    jy.shop_num = math.floor((idx[6] - idx[5]) / cc.shop_size)
    jy.data_shop = Byte.create(cc.shop_size * jy.shop_num)
    Byte.loadfile(jy.data_shop, grpFile, dix[5], cc.shop_size * jy.shop_num)
    for i = 0, jy.shop_num - 1 do
        jy.shop[i] = {}
        local meta_t = {
            __index = function(t, k)
                return GetDataFromStruct(jy.data_shop, i * cc.shop_size, cc.shop_s, k)
            end,
    
            __newindex = function(t, k, v)
                SetDataFromStruct(jy.data_shop, i * cc.shop_size, cc.shop_s, k, v)
            end
        }
        setmetatable(jy.shop[i], meta_t)
    end

    LoadSMap(sFile, cc.temp_s_filename, jy.scene_num, cc.s_width, cc.s_height, dFile, cc.d_num, 11)
    collectgarbage()
    Debug(string.format("Loadrecord time=%d", GetTime() - time))
    jy.load_time = GetTime()
    rest()

    if id > 0 then 
        tjmload(id)
    end

    os.remove('r.grp')
    os.remove('d.grp')
    os.remove('s.grp')
    os.remove('tjm')
end

-- 存档列表
function SaveList()
    -- 读取R*.idx文件
    local idx_data = Byte.create(24)
    Byte.loadfile(idx_data, cc.r_idx_filename[0], 0, 24)
    local idx = {}
    idx[0] = 0
    for i = 1, 6 do
        idx[i] = Byte.get32(idx_data, 4 * (i - 1))
    end
    local table_struct = {}
    table_struct["姓名"] = {idx[1]+8, 2, 10}
    table_struct["资质"] = {idx[1]+122, 0, 2}
    table_struct["无用"] = {idx[0]+2, 0, 2}
    table_struct["难度"] = {idx[0]+24, 0, 2}
    table_struct["标准"] = {idx[0]+26, 0, 2}
    table_struct["畅想"] = {idx[0]+28, 0, 2}
    table_struct["特殊"] = {idx[0]+30, 0, 2}
    table_struct["天书数量"] = {idx[0]+36, 0, 2}
    table_struct["武功数量"] = {idx[0]+38, 0, 2}
    table_struct["场景名称"] = {idx[3]+2, 2, 10}
    table_struct["碎片"] = {idx[0]+40, 0, 2}
    -- 主角编号
    table_struct["队伍1"] = {idx[0]+52, 0, 2}

    -- 读取R*.grp文件
    local len = FileLength(cc.r_grp_filename[0])
    local data = Byte.create(len)

    -- 读取SMAP.grp
    local slen = FileLength(cc.s_filename[0])
    local sdata = Byte.create(slen)
    local menu = {}
    for i = 1, cc.save_num do
        local name = ""
        local sname = ""
        local nd = ""           -- 难度
        local time = ""
        local tssl = ""         -- 天书数量
        local zjlx = ""         -- 主角类型
        local zz = ""           -- 资质

        if PD_ExistFile(string.format("data/save/Save_%d", i)) then
            Byte.loadfilefromzip(data, string.format("data/save/Save_%d", i), "r.grp", 0, len)
            local pid = GetDataFromStruct(data, 0, table_struct, "队伍1")
            name = GetDataFromStruct(data, pid * cc.person_size, table_struct, "姓名")
            zz = GetDataFromStruct(data, pid * cc.person_size, table_struct, "资质")
            local wy = GetDataFromStruct(data, 0, table_struct, "无用")
            if wy == -1 then
                sname = "大地图"
            else
                sname = GetDataFromStruct(data, wy * cc.scene_size, table_struct, "场景名称") .. ""
            end
            local lxid1 = GetDataFromStruct(data, 0, table_struct, "标准")
            local lxid2 = GetDataFromStruct(data, 0, table_struct, "畅想")
            local lxid3 = GetDataFromStruct(data, 0, table_struct, "特殊")
            if lxid1 > 0 then
                zjlx = "标准"
            elseif lxid2 > 0 then
                zjlx = "畅想"
            elseif lxid3 > 0 then
                zjlx = "特殊"
            end
            local wz = GetDataFromStruct(data, 0, table_struct, "难度")
            tssl = GetDataFromStruct(data, 0, table_struct, "天书数量") .. "本"
            nd = MODEXZ2[wz]
        end

        if i < 10 then
            menu[i] = {string.format("存档%02d %-4s %-10s %-4s %4s %4s %-10s", i, zjlx, name, nd, zz, tssl, sname), nil, 1}
        else
            menu[i] = {string.format("自动档 %-4s %-10s %-4s %4s %4s %-10s", zjlx, name, nd, zz, tssl, sname), nil, 1}
        end
    end

    local menu_x = (cc.screen_w - 24 * cc.default_font - 2 * cc.menu_border_pixel) / 2
    local menu_y = (cc.screen_h - 9 * (cc.default_font + cc.row_pixel)) / 2
    local r = Gra_ShowMenu(menu, cc.save_num, 10, menu_x, menu_y, 0, 0, 1, 1, cc.default_font, C_WHITE, C_GOLD)
    Debug("SaveList")
    CleanMemory()

    return r
end

-- 从数据的结构中翻译数据，用来取数据
-- data：二进制数组
-- offset：data中的偏移
-- t_struct：数据的结构，在jyconst中有很多定义
-- key：访问的key
function GetDataFromStruct(data, offset, t_struct, key)
    local t = t_struct[key]
    local r
    if t[2] == 0 then
        r = Byte.get16(data, t[1] + offset)
    elseif t[2] == 1 then
        r = Byte.getu16(data, t[1] + offset)
    elseif t[2] == 2 then
        if cc.src_char_set == 0 then
            r = lib.CharSet(Byte.getstr(data, t[1] + offset, t[3]), 0)
        else
            r = lib.getstr(data, t[1] + offset, t[3])
        end
    end

    return r
end

-- 从数据的结构中翻译数据，用来保存数据
-- data：二进制数组
-- offset：data中的偏移
-- t_struct：数据的结构，在jyconst中有很多定义
-- key：访问的key
-- v：写入的值
function SetDataFromStruct(data, offset, t_struct, key, v)
    local t = t_struct[key]
    if t[2] == 0 then
        Byte.set16(data, t[1] + offset, v)
    elseif t[2] == 1 then
        Byte.setu16(data, t[1] + offset, v)
    elseif t[2] == 2 then
        local s
        if cc.src_char_set == 0 then
            s = lib.CharSet(v, 1)
        else
            s = v
        end
        Byte.setstr(data, t[1] + offset, t[3], s)
    end
end

-- 获取文件长度
function FileLength(filename)
    local inp = io.open(filename, "rb")
    local l = inp:seek("end")
    inp:close()

    return l
end

-- 判定文件是否存在
function PD_ExistFile(filename)
    local f = io.open(filename)
    if f == nil then
        return false
    end
    io.close(f)

    return true
end

-- 限制x的范围
function LimitX(x, min, max)
    if x < min then
        x = min
    end
    if max ~= nil and x > max then
        x = max
    end

    return x
end

-- 等待键盘输入
function WaitKey()
    -- ktype：1 键盘，2 鼠标移动，3 鼠标左键，4 鼠标右键，5 鼠标中键，6 滚动上，7 滚动下
    local key, ktype, mx, my = -1, -1, -1, -1
    key, ktype, mx, my = lib.GetKey()

    return key, ktype, mx, my
end

-- 延时t毫秒
function Delay(t)
    -- 参数校验
    if t <= 0 then
        return
    end

    lib.Delay(t)
end

-- 在主程序目录下的debug.txt文件中输出调试字符串
function Debug(str)
    -- 参数校验
    if str == nil then
        return
    end

    lib.Debug(str)
end

-- 清屏
function instruct_0()
    Gra_Cls()
end

-- 对话
-- talkid: 为数字，则为对话编号；为字符串，则为对话本身。
-- headid: 头像id
-- flag：对话框位置
--      =0：屏幕上方显示, 左边头像，右边对话
--      =1：屏幕下方显示, 左边对话，右边头像
--      =2：屏幕上方显示, 左边空，右边对话
--      =3：屏幕下方显示, 左边对话，右边空
--      =4：屏幕上方显示, 左边对话，右边头像
--      =5：屏幕下方显示, 左边头像，右边对话
function instruct_1(talkid, headid, flag)
    local s = ReadTalk(talkid)
    if s == nil then 
        return
    end
    TalkEx(s, headid, flag)
end

-- 得到物品
function instruct_2(thingid, num)
    if jy.thing[thingid] == nil then
        return 
    end
    instruct_32(thingid, num)
    if num > 0 then
        Gra_DrawStrBoxWaitKey(string.format("得到物品%sX%d", "【Ｇ"..jy.thing[thingid]["名称"].."Ｏ】", num), C_ORANGE, cc.default_font, 1)
    else
        Gra_DrawStrBoxWaitKey(string.format("失去物品%sX%d", "【Ｇ"..jy.thing[thingid]["名称"].."Ｏ】", -num), C_ORANGE, cc.default_font, 1)
    end
end

-- 修改指定场景坐标的事件
function instruct_3(sceneid, id, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10)
    if jy.restart == 1 then
        return
    end
    
    if sceneid == -2 then
        sceneid = jy.sub_scene
    end
    if id == -2 then
        id = jy.current_d
    end
    if v0 ~= -2 then
        SetD(sceneid, id, 0, v0)
    end
    if v1 ~= -2 then
        SetD(sceneid, id, 1, v1)
    end
    if v2 ~= -2 then
        SetD(sceneid, id, 2, v2)
    end
    if v3 ~= -2 then
        SetD(sceneid, id, 3, v3)
    end
    if v4 ~= -2 then
        SetD(sceneid, id, 4, v4)
    end
    if v5 ~= -2 then
        SetD(sceneid, id, 5, v5)
    end
    if v6 ~= -2 then
        SetD(sceneid, id, 6, v6)
    end
    if v7 ~= -2 then
        SetD(sceneid, id, 7, v7)
    end
    if v8 ~= -2 then
        SetD(sceneid, id, 8, v8)
    end
    if v9 ~= -2 and v10 ~= -2 and v9 > 0 and v10 > 0 then
        SetS(sceneid, GetD(sceneid, id, 9), GetD(sceneid, id, 10), 3, -1)
        SetD(sceneid, id, 9, v9)
        SetD(sceneid, id, 10, v10)
        SetS(sceneid, GetD(sceneid, id, 9), GetD(sceneid, id, 10), 3, id)
    end
end

-- 判定当前选择物品
function instruct_4(thingid)
    if jy.current_thing == thingid then
        return true
    else
        return false
    end
end

----------------------------------------
--
-- orionids：以下函数都是主程序引擎提供的可以在lua中调用的函数
-- 注意，对这些API没有做更多的参数的检查工作，因此要确保输入的参数是合理的
-- 否则程序可能会出错，也可能什么都不做
--
----------------------------------------

-- Byte.create(size)
-- 创建一个二进制字节数组，size为数组大小

-- Byte.get16(b, start)
-- 从数组b中读取一个有符号16位整数
-- start：数组中的读取位置，从0开始

-- Byte.get32(b, start)
-- 从数组b中读取一个有符号32位整数

-- Byte.getstr(b, start, length)
-- 从数组b中读取一个字符串，长度为length

-- Byte.getu16(b, start)
-- 从数组b中读取一个无符号16位整数，主要用于访问人物经验

-- Byte.loadfile(b, filename, start, length)
-- 从文件filename中加载数据到字节数组b中
-- start：读取位置，从文件开始处的字节数，从0开始
-- length：要读的字节数

-- Byte.savefile(b, filename, start, length)
-- 把字节数组b的内容写到文件filename中
-- start：读取位置，从文件开始处的字节数，从0开始
-- length：要读的字节数

-- Byte.set16(b, start, v)
-- 把有符号16位整数写入数组b中
-- start：数组中的写位置，从0开始

-- Byte.set32(b, start, v)
-- 把有符号32位整数写入数组b中

-- Byte.setstr(b, start, length, str)
-- 把字符串str写入到数组b中，最长写入长度为length

-- Byte.setu16(b, start, v)
-- 把无符号16位整数写入数组b中

-- lib.CharSet(str, flag)
-- 返回把str转换后的字符串
-- flag = 0，Big5 -> GBK   
--      = 1，GBK -> Big5
--      = 2，Big5 -> Unicode
--      = 3，GBK -> Unicode

-- lib.CleanWarMap(level, v)
-- 给level层战斗数据全部赋值v

-- lib.EnableKeyRepeat(delay, interval)
-- 设置键盘重复率
-- delay为第一个重复的延迟毫秒数，interval为多少毫秒重复一次
-- ESC, RETURN 和SPACE键已经取消重复，一直按下也只认为是按下一次



-- lib.GetKey()
-- 得到当前按键键码，键码定义参见SDL文档
-- 此函数处理键盘缓冲区和键盘重复率，返回的是从上次调用以来曾经按下的键
-- 并且只处理按下一个键的情况。因此如果需要清除键盘缓冲区，需要先调用一次此函数

-- lib.GetTime()
-- 返回开机到当前的毫秒数

-- lib.PlayMIDI(filename)
-- 重复播放MID文件filename，若filename为空字符串，则停止播放当前正在播放的midi

-- lib.PlayWAV(filename) 
-- 播放音效AVI文件filename

-- lib.UnloadMMap()
-- 释放主地图占用内存