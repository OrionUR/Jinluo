--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- orionids：以下为主程序以及相关函数
-- 函数采用大驼峰式命名方法，变量使用小下划线命名方法，常量使用大下划线命名方法

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



-- 加载所有lua文件
function IncludeFile()
    package.path = CONFIG.ScriptLuaPath -- 设置加载路径
    -- 加载其他文件，使用require避免重复加载
    require("jyconst")                  -- 常量定义
    require("jywar")                    -- 战斗程序
    require("jygraphic")                -- 图像画面程序
    require("kdef")                     -- 事件程序
    require("jyitem")                   -- 物品信息
    require("jyperson")                 -- 人物信息
    require("jyskill")                  -- 武功信息
    require("jyenterprise")             -- 门派相关
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

    jy.restart = 0                      -- 返回游戏初始界面
    jy.walk_count = 0                   -- 走路计步
end

-- 主程序入口
function JY_Main()
    --os.remove("debug.txt")              -- 清除以前的debug输出
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

    -- 初始化随机数发生器
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
    jy.status = GAME_START              -- 改变游戏状态
    Gra_PicInit()                       -- 初始化贴图Cache
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
        Gra_ShowSlow(20, 0)             -- 缓慢显示画面

        local r = StartMenu()           -- 显示游戏开始菜单画面
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

-- 点击右上角X，或者Alt + F4关闭游戏时执行的函数
-- 函数名不可改，在底层已写死
function Menu_Exit()
    -- 缓存当前屏幕
    local surid = lib.SaveSur(0, 0, cc.screen_w, cc.screen_h)
    local choice = 1            -- 选项，1 继续游戏，2 返回初始，3 离开游戏，默认在1的位置
    
    -- 保存当前状态
    local status = jy.status
    jy.status = GAME_BLACK

    while true do
        if jy.restart == 1 then
            return
        end

        Gra_DrawMenuExit(choice)    -- 绘制菜单

        local key = GetKey()        -- 获取键值
        -- 按ESC键，效果等同于选择「继续游戏」
        if key == VK_ESCAPE then
            PlayWav(77)
            jy.status = status
            lib.LoadSur(surid, 0, 0)
            Gra_ShowScreen()
            lib.FreeSur(surid)
            return 0
        -- 按上、左键
        elseif key == VK_UP or key == VK_LEFT then
            PlayWav(77)
            choice = choice - 1
            if choice < 1 then
                choice = 3
            end
        -- 按下、右键
        elseif key == VK_DOWN or key == VK_RIGHT then
            PlayWav(77)
            choice = choice + 1
            if choice > 3 then
                choice = 1
            end
        -- 按空格、回车键
        elseif key ==VK_SPACE or key == VK_RETURN then
            PlayWav(77)
            -- 选择「离开游戏」
            if choice == 3 then
                jy.status = GAME_END
                lib.FreeSur(surid)
                return 1
            -- 选择「返回初始」
            elseif choice == 2 then
                jy.restart = 1
                jy.status = GAME_START
                lib.FreeSur(surid)
                return 0
            -- 选择「继续游戏」
            else
                jy.status = status
                lib.LoadSur(surid, 0, 0)
                Gra_ShowScreen()
                lib.FreeSur(surid)
                return 0
            end
        end
    end
end

-- 游戏开始菜单画面
function StartMenu()
    local menu_return = TitleSelection()
    Gra_Cls()

    -- 初出茅庐
    if menu_return == 1 then
        if jy.restart == 1 then
            do return end
        end

        NewGame()

    -- 再战江湖
    elseif menu_return == 2 then
        lib.LoadPNG(5, 501 * 2, -1, -1, 1)
        Gra_DrawStrBox(-1, cc.screen_h *1 / 6 - 20, '读取进度', C_LIMEGREEN, cc.font_size_40, C_GOLD)
        Gra_ShowScreen()
        Delay(5000)

        -- local r = SaveList()
        -- -- ESC重新返回选项
        -- if r < 1 then
        --     local s = StartMenu()
        --     return s
        -- end

        -- Gra_DrawStrBox(-1, cc.start_menu_y, "请稍候...", C_GOLD, cc.default_font)
        -- Gra_ShowScreen()
        -- Delay(2000)
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
    -- 离开游戏
    else
        return -1
    end
end

-- 游戏开始画面选择
---@return number 选择的项
function TitleSelection()
    local choice = 1            -- 选项，1 开始游戏，2 载入游戏，3 退出游戏，默认在1的位置

    while true do
        if jy.restart == 1 then
            return
        end
        local key = GetKey()    -- 获取键值
        -- 按下、右键
        if key == VK_DOWN or key == VK_RIGHT then
            PlayWav(77)
            choice = choice + 1
            if choice > 3 then
                choice = 1
            end
        -- 按上、左键
        elseif key == VK_UP or key == VK_LEFT then
            PlayWav(77)
            choice = choice - 1
            if choice < 1 then
                choice = 3
            end
        elseif key == VK_RETURN then
            break
        end

        Gra_DrawTitle(choice)         -- 绘制选项
    end

    return choice
end

-- 选择新游戏，设置主角初始属性
function NewGame()
    Gra_Cls()
    Gra_ShowScreen()
    LoadRecord(0)

    -- 所有NPC加入门派，在upedit操作

    -- 选择标主还是畅想（画面）
    -- page763
    jy.status = GAME_NEWGAME

    -- 选人，标主列表和畅想列表
    -- 畅想人物，需要重新配置

    -- 选择游戏难度、游玩模式
    -- page768

    -- 选择内属、资质
    -- page1185

    -- 选择初始天赋
    -- page1191

    -- 最高难度下，NPC随机穿套装

    -- 一些NPC的初始化，根据难度调整属性加成
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
    -- 如果游戏内设置为不播放音乐，则返回
    if jy.enable_music == 0 then
        return
    end
    -- 播放设定的音乐路径的音乐，音乐为id + 1
    if id >= 0 then                             
        lib.PlayMIDI(string.format(cc.midi_file, id + 1))
    end
end

-- 播放音效
-- id：要播放的音效id
function PlayWav(id)
    -- 如果游戏内设置为不播放音效，则返回
    if jy.enable_sound == 0 then
        return
    end
    -- 播放设定的音效路径的音效，音效为id
    if id >= 0 then
        lib.PlayWAV(string.format(cc.e_file, id))
    end
end

-- 读取游戏进度
-- id： =0 新游戏，=1..10 游戏存档
-- 这里是先把数据读入Byte数组中，然后定义访问相应表的方法，在访问表时直接从数组访问
-- 与以前的实现相比，从文件中读取和保存到文件的时间显著加快。而且内存占用少了
function LoadRecord(id)
    local zip_file = string.format('SAVE/Save_%d', id)
    if id ~= 0 and (existFile(zip_file) == false) then
        -- QZXS("此存档数据不全，不能读取，请选择其他存档或重新开始")
        return -1
    end
    -- 解压存档文件，并让里面的文件分别命名为r.grp, d.grp, s.grp, tjm
    Byte.unzip(zip_file, 'r.grp', 'd.grp', 's.grp', 'tjm')
    
    -- 游玩时间
    local time = GetTime()

    -- 读取R*.idx文件
    -- 总共6个分类，分别为基本数据、人物、物品、场景、武功、商店
    -- 每个分类占用4个字节，因此总共6 * 4 = 24个字节
    -- 这里的idx文件只是目录，用来记录分类的长度
    local data = ByteCreate(6 * 4)
    ByteLoadFile(data, cc.r_idx_filename[1], 0, 6 * 4)

    -- 把分类的长度放到idx里
    local idx = {}
    for i = 1, 6 do
        idx[i] = ByteGet32(data, 4 * (i - 1))
    end

    -- 若是开新档，则使用初始数据，否则使用存档数据
    local grpFile = 'r.grp'
    local sFile = 's.grp'
    local dFile = 'd.grp'
    if id == 0 then
        grpFile = cc.r_grp_filename[1]
        sFile = cc.s_filename[1]
        dFile = cc.d_filename[1]
    end

    -- 读取R*.grp文件
    -- 基本二进制数据
    jy.raw_base_data = Byte.create(idx[1])
    ByteLoadFile(jy.raw_base_data, grpFile, 0, idx[1])
    -- 设置访问基本数据的方法，这样就可以用访问表的方式访问了
    -- 而不用把二进制数据转化为表，节约加载时间和空间
    local meta_t = {
        __index = function(t, k)
            return GetDataFromStruct(jy.raw_base_data, 0, cc.base_s, k)
        end,

        __newindex = function(t, k, v)
            SetDataFromStruct(jy.raw_base_data, 0, cc.base_s, k, v)
        end
    }
    setmetatable(jy.base, meta_t)

    -- 人物数据
    jy.person_num = math.floor((idx[2] - idx[1]) / cc.person_size)
    -- 人物二进制数据
    jy.raw_person_data = Byte.create(cc.person_size * jy.person_num)
    ByteLoadFile(jy.raw_person_data, grpFile, idx[1], cc.person_size * jy.person_num)
    for i = 0, jy.person_num - 1 do
        jy.person[i] = {}
        local meta_t = {
            __index = function(t, k)
                return GetDataFromStruct(jy.raw_person_data, i * cc.person_size, cc.person_s, k)
            end,
    
            __newindex = function(t, k, v)
                SetDataFromStruct(jy.raw_person_data, i * cc.person_size, cc.person_s, k, v)
            end
        }
        setmetatable(jy.person[i], meta_t)
    end

    -- 物品数据
    jy.thing_num = math.floor((idx[3] - idx[2]) / cc.thing_size)
    -- 物品二进制数据
    jy.raw_thing_data = Byte.create(cc.thing_size * jy.thing_num)
    ByteLoadFile(jy.raw_thing_data, grpFile, dix[2], cc.thing_size * jy.thing_num)
    for i = 0, jy.thing_num - 1 do
        jy.thing[i] = {}
        local meta_t = {
            __index = function(t, k)
                return GetDataFromStruct(jy.raw_thing_data, i * cc.thing_size, cc.thing_s, k)
            end,
    
            __newindex = function(t, k, v)
                SetDataFromStruct(jy.raw_thing_data, i * cc.thing_size, cc.thing_s, k, v)
            end
        }
        setmetatable(jy.thing[i], meta_t)
    end

    -- 场景数据
    jy.scene_num = math.floor((idx[4] - idx[3]) / cc.scene_size)
    -- 场景二进制数据
    jy.raw_scene_data = Byte.create(cc.scene_size * jy.scene_num)
    ByteLoadFile(jy.raw_scene_data, grpFile, dix[3], cc.scene_size * jy.scene_num)
    for i = 0, jy.scene_num - 1 do
        jy.scene[i] = {}
        local meta_t = {
            __index = function(t, k)
                return GetDataFromStruct(jy.raw_scene_data, i * cc.scene_size, cc.scene_s, k)
            end,
    
            __newindex = function(t, k, v)
                SetDataFromStruct(jy.raw_scene_data, i * cc.scene_size, cc.scene_s, k, v)
            end
        }
        setmetatable(jy.scene[i], meta_t)
    end

    -- 武功数据
    jy.wugong_num = math.floor((idx[5] - idx[4]) / cc.wugong_size)
    -- 武功二进制数据
    jy.raw_wugong_data = Byte.create(cc.wugong_size * jy.wugong_num)
    ByteLoadFile(jy.raw_wugong_data, grpFile, dix[4], cc.wugong_size * jy.wugong_num)
    for i = 0, jy.wugong_num - 1 do
        jy.wugong[i] = {}
        local meta_t = {
            __index = function(t, k)
                return GetDataFromStruct(jy.raw_wugong_data, i * cc.wugong_size, cc.wugong_s, k)
            end,
    
            __newindex = function(t, k, v)
                SetDataFromStruct(jy.raw_wugong_data, i * cc.wugong_size, cc.wugong_s, k, v)
            end
        }
        setmetatable(jy.wugong[i], meta_t)
    end

    -- 商店数据
    jy.shop_num = math.floor((idx[6] - idx[5]) / cc.shop_size)
    -- 商店二进制数据
    jy.raw_shop_data = Byte.create(cc.shop_size * jy.shop_num)
    ByteLoadFile(jy.raw_shop_data, grpFile, dix[5], cc.shop_size * jy.shop_num)
    for i = 0, jy.shop_num - 1 do
        jy.shop[i] = {}
        local meta_t = {
            __index = function(t, k)
                return GetDataFromStruct(jy.raw_shop_data, i * cc.shop_size, cc.shop_s, k)
            end,
    
            __newindex = function(t, k, v)
                SetDataFromStruct(jy.raw_shop_data, i * cc.shop_size, cc.shop_s, k, v)
            end
        }
        setmetatable(jy.shop[i], meta_t)
    end

    Gra_LoadSMap(sFile, jy.scene_num, dFile)
    -- 做一次完整的垃圾收集循环
    collectgarbage()
    jy.load_time = GetTime()
    rest()

    -- if id > 0 then 
    --     tjmload(id)
    -- end

    -- 删除解压文件
    os.remove('r.grp')
    os.remove('d.grp')
    os.remove('s.grp')
    os.remove('tjm')
end

-- 写游戏进度
-- id： =0 新游戏，=1..10 游戏存档
function SaveRecord(id)
    -- 判断是否在子场景保存
    if jy.status == GAME_SMAP then
        jy.base['子场景'] = jy.sub_scene
    else
        jy.base['子场景'] = -1
    end

    -- 游玩时间计算
    local time = GetTime()
    jy.save_time = GetTime()
    jy.game_time = math.modf((jy.save_time - jy.load_time) / 60000)
    SetS(14, 2, 1, 4, GetS(14, 2, 1, 4) + jy.game_time)
    jy.load_time = GetTime()

    -- 读取R*.idx文件
    -- 总共6个分类，分别为基本数据、人物、物品、场景、武功、商店
    -- 每个分类占用4个字节，因此总共6 * 4 = 24个字节
    -- 这里的idx文件只是目录，用来记录分类的长度
    local data = ByteCreate(6 * 4)
    ByteLoadFile(data, cc.r_idx_filename[1], 0, 6 * 4)

    -- 把分类的长度放到idx里
    local idx = {}
    for i = 1, 6 do
        idx[i] = ByteGet32(data, 4 * (i - 1))
    end

    -- 写R*.grp文件
    ByteSaveFile(jy.raw_base_data, 'r.grp', 0, idx[1])
    ByteSaveFile(jy.raw_person_data, 'r.grp', idx[1], cc.person_size * jy.person_num)
    ByteSaveFile(jy.raw_thing_data, 'r.grp', idx[2], cc.thing_size * jy.thing_num)
    ByteSaveFile(jy.raw_scene_data, 'r.grp', idx[3], cc.scene_size * jy.scene_num)
    ByteSaveFile(jy.raw_wugong_data, 'r.grp', idx[4], cc.wugong_size * jy.wugong_num)
    ByteSaveFile(jy.raw_shop_data, 'r.grp', idx[5], cc.shop_size * jy.shop_num)
    SaveSMap('s.grp', 'd.grp')

    -- 打包压缩存档
    local zip_file = string.format('SAVE/Save_%d', id)
    Byte.zip(zip_file, 'r.grp', 'd.grp', 's.grp')
    os.remove('r.grp')
    os.remove('d.grp')
    os.remove('s.grp')
end

-- 存档列表
function SaveList()
    -- 读取R*.idx文件
    -- 总共6个分类，分别为基本数据、人物、物品、场景、武功、商店
    -- 每个分类占用4个字节，因此总共6 * 4 = 24个字节
    -- 这里的idx文件只是目录，用来记录分类的长度
    local data = ByteCreate(6 * 4)
    ByteLoadFile(data, cc.r_idx_filename[1], 0, 6 * 4)

    -- 把分类的长度放到idx里
    local idx = {}
    for i = 1, 6 do
        idx[i] = ByteGet32(data, 4 * (i - 1))
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
    CleanMemory()

    return r
end

-- 从数据的结构中翻译数据，用来取数据
-- data：二进制数组
-- offset：data中的偏移
-- t_struct：数据结构，在jyconst中有很多定义
-- key：访问的key
function GetDataFromStruct(data, offset, t_struct, key)
    local t = t_struct[key]
    local r
    -- 有符号
    if t[2] == 0 then
        r = ByteGet16(data, t[1] + offset)
    -- 无符号
    elseif t[2] == 1 then
        r = ByteGetu16(data, t[1] + offset)
    -- 字符串
    elseif t[2] == 2 then
        -- GBK
        if cc.src_char_set == 0 then
            r = ByteGetStr(data, t[1] + offset, t[3])
        -- Big5
        else
            r = CharSet(ByteGetStr(data, t[1] + offset, t[3]), 1)
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
    -- 有符号
    if t[2] == 0 then
        ByteSet16(data, t[1] + offset, v)
    -- 无符号
    elseif t[2] == 1 then
        ByteSetu16(data, t[1] + offset, v)
    -- 字符串
    elseif t[2] == 2 then
        local s
        -- GBK
        if cc.src_char_set == 0 then
            s = v
        -- Big5
        else
            s = CharSet(v, 0)
        end
        ByteSetStr(data, t[1] + offset, t[3], s)
    end
end

-- 读S*
-- id：场景编号
-- xy：坐标
-- level：场景地图数据层数
--      =0 地面数据，=1 建筑，=2 战斗人战斗编号
--      =3 移动时显示可移动的位置，=4 命中效果，=5 战斗人对应的贴图
function GetS(id, x, y, level)
    local err = -1      -- 错误码
    if not id or not x or not y or not level then
        err = 1         -- 参数省略错误
    elseif id < 0 then
        err = 2         -- id错误
    elseif x < 0 or y < 0 then
        err = 3         -- xy错误
    elseif level < 0 or level > 5 then
        err = 4         -- level错误
    end

    -- 错误时返回错误码
    if err > 0 then
        Debug("GetS Error, error code: " .. err)
        return
    end

    return lib.GetS(id, x, y, level)
end

-- 写S*
-- id：场景编号
-- xy：坐标
-- level：场景地图数据层数
--      =0 地面数据，=1 建筑，=2 战斗人战斗编号
--      =3 移动时显示可移动的位置，=4 命中效果，=5 战斗人对应的贴图
-- v：写入的值
function SetS(id, x, y, level, v)
    local err = -1      -- 错误码
    if not id or not x or not y or not level or not v then
        err = 1         -- 参数省略错误
    elseif id < 0 then
        err = 2         -- id错误
    elseif x < 0 or y < 0 then
        err = 3         -- xy错误
    elseif level < 0 or level > 5 then
        err = 4         -- level错误
    elseif type(v) ~= "number" then
        err = 5         -- v错误
    end

    -- 错误时返回错误码
    if err > 0 then
        Debug("SetS Error, error code: " .. err)
        return
    end

    return lib.SetS(id, x, y, level)
end

-- 读D*
-- sceneid：场景编号
-- id：该场景D*编号
-- i：第几个数据
function GetD(sceneid, id, i)
    local err = -1      -- 错误码
    if not sceneid or not id or not i then
        err = 1         -- 参数省略错误
    elseif sceneid < 0 then
        err = 2         -- sceneid错误
    elseif id < 0 then
        err = 3         -- id错误
    elseif i < 0 then
        err = 4         -- i错误
    end

    -- 错误时返回错误码
    if err > 0 then
        Debug("GetD Error, error code: " .. err)
        return
    end

    return lib.GetD(sceneid, id, i)
end

-- 写D*
-- sceneid：场景编号
-- id：该场景D*编号
-- i：第几个数据
-- v：写入的值
function SetD(sceneid, id, i, v)
    local err = -1      -- 错误码
    if not sceneid or not id or not i or not v then
        err = 1         -- 参数省略错误
    elseif sceneid < 0 then
        err = 2         -- sceneid错误
    elseif id < 0 then
        err = 3         -- id错误
    elseif i < 0 then
        err = 4         -- i错误
    elseif type(v) ~= "number" then
        err = 5         -- v错误
    end

    -- 错误时返回错误码
    if err > 0 then
        Debug("SetD Error, error code: " .. err)
        return
    end

    return lib.SetD(sceneid, id, i, v)
end

-- 取大地图结构相应坐标的值
-- flag： =0 earth, =1 surface, =2 building, =3 buildx, =4 buildy
-- 返回一个值，为flag层的大地图坐标数据
function GetMMap(x, y, flag)
    local err = -1      -- 错误码
    if not x or not y or not flag then
        err = 1         -- 参数省略错误
    end

    -- 错误时返回错误码
    if err > 0 then
        Debug("GetMMap Error, error code: " .. err)
        return
    end

    return lib.GetMMap(x, y, flag)
end

-- 取战斗地图数据
-- xy：坐标
-- level：战斗地图数据层数
--      =0 地面数据，=1 建筑，=2 战斗人战斗编号
--      =3 移动时显示可移动的位置，=4 命中效果，=5 战斗人对应的贴图
-- 返回一个值，为该层的战斗地图坐标数据
function GetWarMap(x, y, level)
    local err = -1      -- 错误码
    if not x or not y or not level then
        err = 1         -- 参数省略错误
    end

    -- 错误时返回错误码
    if err > 0 then
        Debug("GetWarMap Error, error code: " .. err)
        return
    end

    return lib.GetWarMap(x, y, level)
end

-- lib.SetWarMap(x, y, level, v)
-- 存战斗地图数据
-- xy：坐标
-- level：战斗地图数据层数
--      =0 地面数据，=1 建筑，=2 战斗人战斗编号
--      =3 移动时显示可移动的位置，=4 命中效果，=5 战斗人对应的贴图
-- v：写入的值
function SetWarMap(x, y, level, v)
    local err = -1      -- 错误码
    if not x or not y or not level or not v then
        err = 1         -- 参数省略错误
    end

    -- 错误时返回错误码
    if err > 0 then
        Debug("SetWarMap Error, error code: " .. err)
        return
    end

    lib.SetWarMap(x, y, level, v)
end

-- 保存S*和D*
function SaveSMap(Sfilename, Dfilename)
    local err = -1      -- 错误码
    if not Sfilename or not Dfilename then
        err = 1         -- 参数省略错误
    elseif type(Sfilename) ~= "string" then
        err = 2         -- Sfilename错误
    elseif type(Dfilename) ~= "string" then
        err = 3         -- Dfilename错误
    end

    -- 错误时返回错误码
    if err > 0 then
        Debug("SaveSMap Error, error code: " .. err)
        return
    end

    lib.SaveSMap(Sfilename, Dfilename)
end

-- 得到PNG图片的XY值
-- fileid：指定id，由Gra_LoadPNGPath函数指定
-- picid：picid：指定图片的id乘以2，比如你要载入的png图片叫2.png，那么这里picid要填4，图片名一定要是数字
-- 返回两个值，分别为x和y，表示查询图片的宽和高
function GetPNGXY(fileid, picid)
    local err = -1      -- 错误码
    if not fileid or not picid then
        err = 1         -- 参数省略错误
    end

    -- 错误时返回错误码
    if err > 0 then
        Debug("GetPNGXY Error, error code: " .. err)
        return
    end

    return lib.GetPNGXY(fileid, picid)
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

-- 得到当前按键键码，键码定义参见SDL文档
-- 此函数处理键盘缓冲区和键盘重复率，返回的是从上次调用以来曾经按下的键
-- 并且只处理按下一个键的情况。因此如果需要清除键盘缓冲区，需要先调用一次此函数
-- 返回key、ktype、mx、my四个值
-- key：按下的按键
-- ktype：1 键盘，2 鼠标移动，3 鼠标左键，4 鼠标右键，5 鼠标中键，6 滚动上，7 滚动下
-- mx、my：鼠标xy轴
function GetKey()
    return lib.GetKey()
end

-- 设置键盘重复率
-- delay为第一个重复的延迟毫秒数，interval为多少毫秒重复一次
-- ESC, RETURN 和SPACE键已经取消重复，一直按下也只认为是按下一次
function EnableKeyRepeat(delay, interval)
    local err = -1      -- 错误码
    if not delay or not interval then
        err = 1         -- 参数省略错误
    elseif delay < 0 then
        err = 2         -- delay错误
    elseif interval < 0 then
        err = 3         -- interval错误
    end

    -- 错误时返回错误码
    if err > 0 then
        Debug("EnableKeyRepeat Error, error code: " .. err)
        return
    end

    lib.EnableKeyRepeat(delay, interval)
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

-- lib.CharSet(str, flag)
-- 返回把str转换后的字符串
-- flag：=0 Big5 -> GBK   
--       =1 GBK -> Big5
--       =2 Big5 -> Unicode
--       =3 GBK -> Unicode
function CharSet(str, flag)
    if not str or not flag then
        error('参数省略错误')
    elseif type(str) ~= "string" then
        error('str错误')
    elseif flag < 0 or flag > 3 then
        error('flag错误')
    end

    return lib.CharSet(str, flag)
end

-- 返回开机到当前的毫秒数
function GetTime()
    return lib.GetTime()
end

-- 释放主地图占用内存
function UnloadMMap()
    lib.UnloadMMap()
end

-- 创建一个二进制字节数组，size为数组大小
function ByteCreate(size)
    if not size then
        error('参数省略错误')
    elseif size < 0 then
        error('size错误')
    end

    return Byte.create(size)
end

-- 从数组b中读取一个有符号16位整数
-- start：数组中的读取位置，从0开始
function ByteGet16(b, start)
    if not b or not start then
        error('参数省略错误')
    end

    return Byte.get16(b, start)
end

-- 从数组b中读取一个有符号32位整数
-- start：数组中的读取位置，从0开始
function ByteGet32(b, start)
    if not b or not start then
        error('参数省略错误')
    end

    return Byte.get32(b, start)
end

-- 从数组b中读取一个无符号16位整数，主要用于访问人物经验
-- start：数组中的读取位置，从0开始
function ByteGetu16(b, start)
    if not b or not start then
        error('参数省略错误')
    end

    return Byte.getu16(b, start)
end

-- 从数组b中读取一个字符串，长度为length
-- start：数组中的读取位置，从0开始
function ByteGetStr(b, start, length)
    if not b or not start or not length then
        error('参数省略错误')
    end

    return Byte.getstr(b, start, length)
end

-- 从文件filename中加载数据到字节数组b中
-- start：读取位置，从文件开始处的字节数，从0开始
-- length：要读的字节数
function ByteLoadFile(b, filename, start, length)
    if not b or not filename or not start or not length then
        error('参数省略错误')
    end

    Byte.loadfile(b, filename, start, length)
end

-- 把字节数组b的内容写到文件filename中
-- start：写的位置，从文件开始处的字节数，从0开始
-- length：要写的字节数
function ByteSaveFile(b, filename, start, length)
    if not b or not filename or not start or not length then
        error('参数省略错误')
    end

    Byte.savefile(b, filename, start, length)
end

-- 把有符号16位整数写入数组b中
-- start：数组中的写位置，从0开始
-- v：写入的值
function ByteSet16(b, start, v)
    if not b or not start or not v then
        error('参数省略错误')
    end

    Byte.set16(b, start, v)
end

-- 把有符号32位整数写入数组b中
-- start：数组中的写位置，从0开始
-- v：写入的值
function ByteSet32(b, start, v)
    if not b or not start or not v then
        error('参数省略错误')
    end

    Byte.set32(b, start, v)
end

-- 把无符号16位整数写入数组b中
-- start：数组中的写位置，从0开始
-- v：写入的值
function ByteSetu16(b, start, v)
    if not b or not start or not v then
        error('参数省略错误')
    end

    Byte.setu16(b, start, v)
end

-- 把字符串str写入到数组b中，最长写入长度为length
-- start：数组中的写位置，从0开始
function ByteSetStr(b, start, length, str)
    if not b or not start or not length or not str then
        error('参数省略错误')
    end

    Byte.setstr(b, start, length, str)
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