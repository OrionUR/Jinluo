----------------------------------------
--
-- orionids������Ϊ�������Լ���غ���
-- 
----------------------------------------


-- ��������lua�ļ�
function IncludeFile()
    package.path = CONFIG.ScriptLuaPath -- ���ü���·��
    -- ���������ļ���ʹ��require�����ظ�����
    require("JYconst")                  -- ��������
    require("JYwar")                    -- ս������
    require("JYgraphic")                -- ͼ�������
    require("kdef")                     -- �¼�����
    require("ItemInfo")                 -- ��Ʒ��Ϣ
    require("PersonInfo")               -- ������Ϣ
    require("SkillInfo")                -- �书��Ϣ
    require("MP")                       -- �������
end

-- ������Ϸ�ڲ�ʹ�õ�ȫ�̱���
function SetGlobal()
    jy = {}                             -- ��ս��״̬ʱʹ�õ�ȫ�ֱ���

    jy.status = GAME_INIT               -- ��Ϸ״̬
    jy.base = {}                        -- ��������
    jy.person_num = 0                   -- ��������
    jy.person = {}                      -- ��������
    jy.thing_num = 0                    -- ��Ʒ����
    jy.thing = {}                       -- ��Ʒ����
    jy.scene_num = 0                    -- ��������
    jy.scene = {}                       -- ��������
    jy.wugong_num = 0                   -- �书����
    jy.wugong = {}                      -- �书����
    jy.shop_num = 0                     -- �̵�����
    jy.shop = {}                        -- �̵�����

    jy.my_current_pic = 0               -- ���ǵ�ǰ��·��ͼ����ͼ�ļ���ƫ��
    jy.my_pic = 0                       -- ���ǵ�ǰ��ͼ
    jy.my_tick = 0                      -- ����û����·�ĳ���֡��
    jy.my_tick2 = 0                     -- ��ʾ�¼������Ľ���
    jy.load_time = 0                    -- ��ȡʱ��
    jy.save_time = 0                    -- ����ʱ��
    jy.game_time = 0                    -- ��Ϸʱ��
    jy.gold = 0                         -- ��Ϸ����
    jy.year = 1                         -- ��
    jy.month = 1                        -- ��
    jy.day = 1                          -- ��

    jy.sub_scene = -1                   -- ��ǰ�ӳ������
    jy.sub_scene_x = 0                  -- �ӳ�����ʾλ��ƫ�ƣ������ƶ�ָ��ʹ��
    jy.sub_scene_y = 0
    jy.thing_use = -1
    jy.current_d = -1                   -- ��ǰ����D*�ı��
    jy.old_d_pass = -1                  -- �ϴδ���·���¼���D*��ţ������δ���
    jy.current_event_type = -1          -- ��ǰ�����¼��ķ�ʽ��1 �ո�2 ��Ʒ��3 ·��
    jy.current_thing = -1               -- ��ǰѡ����Ʒ�������¼�ʹ��
    jy.mmap_music = -1                  -- �л����ͼ���֣����ش��ͼʱ��������ã��򲥷Ŵ�����
    jy.current_midi = -1                -- ��ǰ���ŵ�����id�������ڹر�����ʱ��������id
    jy.enable_music = 1                 -- �Ƿ񲥷����֣�0 �����ţ�1 ����
    jy.enable_sound = 1                 -- �Ƿ񲥷���Ч��0 �����ţ�1 ����

    war = {}                            -- ս��ʹ�õ�ȫ�̱���
                                        -- ����ռ��λ�ã���Ϊ������治����ȫ�ֱ�����
                                        -- ����������WarSetGlobal������

    auto_move_tab = {[0] = 0}
    jy.restart = 0                      -- ������Ϸ��ʼ����
    jy.walk_count = 0                   -- ��·�Ʋ�
end

-- ���������
function JY_Main()
    os.remove("debug.txt")              -- �����ǰ��debug���
    xpcall(JY_Main_Sub, MyErrFun)       -- ������ô���
end

-- ��������ӡ������Ϣ
function MyErrFun(err)
    Debug(err)                      -- ���������Ϣ
    Debug(debug.traceback())        -- ������ö�ջ��Ϣ
end

-- ��������Ϸ���������
function JY_Main_Sub()
    ct = {}
    IncludeFile()                       -- ��������ģ��
    SetGlobalConst()                    -- ����ȫ�ֱ���cc����JYconst.lua
    SetGlobal()                         -- ����ȫ�ֱ���jy

    -- ��ֹ����ȫ�ֱ���
    setmetatable(_G, {
        __newindex = function (_, n)
            error("attempt read write to undeclared variable " .. n, 2)
        end,
        __index = function (_, n)
            error("attempt read read to undeclared variable " .. n, 2)
        end
    })

    Debug("JY_Main start")

    -- ��ʼ�������������
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
    jy.status = GAME_START              -- �ı���Ϸ״̬
    lib.PicInit(cc.palette_file)        -- ����ԭ����256ɫ��ɫ��
    Gra_FillColor()                     -- ��Ļ����

    Gra_SetAllPNGAddress()              -- ����������ͼ��ַ������id

    while true do
        if jy.restart == 1 then
            jy.restart = 0
            jy.status = GAME_START
        end
        if jy.status == GAME_END then
            break
        end

        PlayMidi(75)                    -- ��������
        Gra_Cls()                       -- ����
        lib.ShowSlow(20, 0)             -- ������ʾ����
        

        -- local r = StartMenu()           -- ��ʾ��Ϸ��ʼ�˵�����
        local r = TitleSelection()
        if r ~= nil then
            return
        end

        -- lib.LoadPicture("", 0, 0)               -- ����ͼƬ
        -- GetKey()                            -- ��ȡ��ֵ

        -- Game_Cycle()                            -- ��Ϸѭ��
    end
end

-- ����lua�ڴ�
function CleanMemory()
    if CONFIG.CleanMemory == 1 then
        -- ��һ�������������ռ�ѭ��
        collectgarbage("collect")
    end
end

-- ��Ϸ��ʼ�˵�����
function StartMenu()
    Gra_Cls()

    local menu_return = TitleSelection()
    if menu_return == 1 then                    -- �µ���Ϸ
        Gra_Cls()
        -- NewGame()

        if jy.restart == 1 then
            do return end
        end

        -- ���������ʼ����
        if jy.base["����"] == 58 then
            jy.sub_scene = 18
            jy.base["��X"] = 144
            jy.base["��Y"] = 218
            jy.base["��X1"] = 30
            jy.base["��Y1"] = 32
        -- ������
        else
            jy.sub_scene = cc.new_game_scene_id
            jy.base["��X1"] = cc.new_game_scene_x
            jy.base["��Y1"] = cc.new_game_scene_y
        end

        -- ��Ů�����ж�
        if jy.person[0]["�Ա�"] == 0 then
            jy.my_pic = cc.new_person_pic_m
        else
            jy.my_pic = cc.new_person_pic_f
        end

        jy.status = GAME_SMAP
        jy.mmap_music = -1
        CleanMemory()
        Init_SMap(0)
        lib.ShowSlow(20, 0)

        -- �����¼�
        if jy.base["����"] == 58 then             -- �������
            CallCEvent(4187)
        else                                      -- ������
            CallCEvent(691)
        end

        -- ���뿪�ֻ�������װ��
        if jy.base["����"] > 0 then
            if jy.person[0]["����"] ~= -1 and jy.base["����"] ~= 27 then
                instruct_2(jy.person[0]["����"], 1)
                jy.person[0]["����"] = -1
            end
            if jy.person[0]["����"] ~= -1 then
                instruct_2(jy.person[0]["����"], 1)
                jy.person[0]["����"] = -1
            end
            if jy.person[0]["����"] ~= -1 then
                instruct_2(jy.person[0]["����"], 1)
                jy.person[0]["����"] = -1
            end
        end

        -- �������������һ����
        if jy.base["����"] == 158 then
            instruct_2(174, 10000)
        end
        -- �������������붴��Ǯѧϰ���ٲ�
        if jy.base["��׼"] > 0 then
            addevent(41, 0, 1, 4144, 1, 8694)
        end
        instruct_10(104)
        instruct_10(105)

        -- ��Ŀ����
        os.remove(CONFIG.DataPath .. 'TgJL')
        for i = 1, #cc.commodity do
            if cc.commodity[i][5] > 0 then
                instruct_2(cc.commodity[i][1], cc.commodity[i][5])
                cc.commodity[i][5] = 0
            end
        end
        tgsave(1)

        cc.tgjl = {}
    -- ����ɵĽ���
    elseif menu_return == 2 then
        --lib.LoadPNG(5, 501 * 2, -1, -1, 1)
        --Gra_ShowScreen()
        Gra_DrawStrBox(-1, cc.screen_h * 1 / 6 - 20, "��ȡ����", LimeGreen, cc.font_big3, C_GOLD)
        -- Gra_DrawStrBox(-1, cc.screen_h / 2 - 20, "��ȡ����", LimeGreen, cc.font_big2, C_GOLD)
        -- local r = SaveList()
        -- -- ESC���·���ѡ��
        -- if r < 1 then
        --     local s = StartMenu()
        --     return s
        -- end

        -- Gra_DrawStrBox(-1, cc.start_menu_y, "���Ժ�...", C_GOLD, cc.default_font)
        Gra_ShowScreen()
        Delay(2000)
        -- local result = Loadrecord(r)
        -- if result ~= nil then
        --     return StartMenu()
        -- end

        -- if jy.base["����"] ~= -1 then
        --     if jy.sub_scene < 0 then
        --         CleanMemory()
        --     end
        --     lib.ShowSlow(20, 1)
        --     jy.status = GAME_SMAP
        --     jy.sub_scene = jy.base["����"]
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

-- ��Ϸ��ʼ����ѡ��
function TitleSelection()
    Debug("TitleSelection")
    local choice = 1            -- ѡ�1��ʼ��Ϸ��2������Ϸ��3�˳���Ϸ��Ĭ����1��λ��
    -- ѡ��
    -- δѡ��ʱ����ͼ��ѡ��ʱ����ͼ��x��λ�ã�y��λ��
    local buttons = {
        {3, 6, 550, 350},
        {4, 7, 550, 450},
        {5, 8, 550, 550}
    }
    -- ���λ���ж�
    -- x����ʼλ�ã�y����ʼλ�ã�x�����λ�ã�y�����λ��
    local mouse_detect = {
        {450, 300, 650, 395},
        {450, 400, 650, 495},
        {450, 500, 650, 595}
    }
    local tmp                   -- ��ʱ������������ʱ�������
    local picid                 -- ͼ��id

    -- �ж�����Ƿ��ڰ�ť��
    -- mx, my��x��y��
    local function OnButton(mx, my)
        local result = 0        -- ����ֵ��ȷ������ڵ�λ��
        
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
        -- �������¡��͡��ҡ�Ч��һ�£�����������һ��ѡ��
        if keypress == VK_DOWN or keypress == VK_RIGHT then
            PlayWav(77)
            choice = choice + 1
            if choice > #buttons then
                choice = 1
            end
        -- �������ϡ��͡���Ч��һ�£�����������һ��ѡ��
        elseif keypress == VK_UP or keypress == VK_LEFT then
            PlayWav(77)
            choice = choice - 1
            if choice < 1 then
                choice = #buttons
            end
        -- ʹ��������
        else
            if ktype == 2 or ktype == 3 then
                -- �����ѡ�Χ�ڣ���ѡ�и�ѡ��
                tmp = OnButton(mx, my)
                if tmp > 0 then
                    choice = tmp
                    PlayWav(77)
                end
            end
            -- �ո��س����������������ж�
            if keypress == VK_RETURN or (ktype == 3 and OnButton(mx, my) > 0) then
                break
            end
        end

        Gra_Cls()

        for i = 1, #buttons do
            -- -- ѡ����ͼ
            picid = buttons[i][1]
            if i == choice then
                picid = buttons[i][2]
            end
            
            -- UI��fileid = 5
            lib.LoadPNG(5, picid * 2, buttons[i][3], buttons[i][4], 1)
        end

        -- ��ʾ�汾��
        Gra_DrawString(600, 250, cc.version, M_Indigo, cc.font_big3)
        Gra_ShowScreen()
        Delay(cc.frame)
    end

    return choice
end

-- ѡ������Ϸ���������ǳ�ʼ����
function NewGame()
end

-- ��Ϸ��ѭ��
function GameCycle()
end

-- ��ʼ�����ͼ����
function InitMMap()
end

-- ����midi
-- id��Ҫ���ŵ�����id
function PlayMidi(id)
    jy.current_midi = id
    if jy.enable_music == 0 then                -- �����Ϸ������Ϊ���������֣��򷵻�
        return
    end
    if id >= 0 then                             -- ����C���������趨������·�������֣�����Ϊid + 1
        lib.PlayMIDI(string.format(cc.midi_file, id + 1))
    end
end

-- ������Ч
-- id��Ҫ���ŵ���Чid
function PlayWav(id)
    if jy.enable_sound == 0 then
        return
    end
    if id >= 0 then
        lib.PlayWAV(string.format(cc.e_file, id))
    end
end

-- ��ȡ��Ϸ����
-- id = 0 �½��ȣ�= 1/2/3 ����
-- �������Ȱ����ݶ���Byte�����У�Ȼ���������Ӧ��ķ������ڷ��ʱ�ʱֱ�Ӵ��������
-- ����ǰ��ʵ����ȣ����ļ��ж�ȡ�ͱ��浽�ļ���ʱ�������ӿ졣�����ڴ�ռ������
function LoadRecord(id)
    local zipfile = string.format('data/save/Save_%d', id)
    if id ~= 0 and (existFile(zipfile) == false) then
        QZXS("�˴浵���ݲ�ȫ�����ܶ�ȡ����ѡ�������浵�����¿�ʼ")
        return -1
    end
    Byte.unzip(zipfile, 'r.grp', 'd.grp', 's.grp', 'tjm')
    
    local time = GetTime()

    -- ��ȡR*.idx�ļ�
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

    -- ��ȡR*.grp�ļ�
    -- ��������
    jy.data_base = Byte.create(idx[1] - idx[0])
    Byte.loadfile(jy.data_base, grpFile, idx[0], idx[1] - idx[0])
    -- ���÷��ʻ������ݵķ����������Ϳ����÷��ʱ�ķ�ʽ������
    -- �����ðѶ���������ת��Ϊ����Լ����ʱ��Ϳռ�
    local meta_t = {
        __index = function(t, k)
            return GetDataFromStruct(jy.data_base, 0, cc.base_s, k)
        end,

        __newindex = function(t, k, v)
            SetDataFromStruct(jy.data_base, 0, cc.base_s, k, v)
        end
    }
    setmetatable(jy.base, meta_t)

    -- ��������
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

    -- ��Ʒ����
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

    -- ��������
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

    -- �书����
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

    -- �̵�����
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

-- �浵�б�
function SaveList()
    -- ��ȡR*.idx�ļ�
    local idx_data = Byte.create(24)
    Byte.loadfile(idx_data, cc.r_idx_filename[0], 0, 24)
    local idx = {}
    idx[0] = 0
    for i = 1, 6 do
        idx[i] = Byte.get32(idx_data, 4 * (i - 1))
    end
    local table_struct = {}
    table_struct["����"] = {idx[1]+8, 2, 10}
    table_struct["����"] = {idx[1]+122, 0, 2}
    table_struct["����"] = {idx[0]+2, 0, 2}
    table_struct["�Ѷ�"] = {idx[0]+24, 0, 2}
    table_struct["��׼"] = {idx[0]+26, 0, 2}
    table_struct["����"] = {idx[0]+28, 0, 2}
    table_struct["����"] = {idx[0]+30, 0, 2}
    table_struct["��������"] = {idx[0]+36, 0, 2}
    table_struct["�书����"] = {idx[0]+38, 0, 2}
    table_struct["��������"] = {idx[3]+2, 2, 10}
    table_struct["��Ƭ"] = {idx[0]+40, 0, 2}
    -- ���Ǳ��
    table_struct["����1"] = {idx[0]+52, 0, 2}

    -- ��ȡR*.grp�ļ�
    local len = FileLength(cc.r_grp_filename[0])
    local data = Byte.create(len)

    -- ��ȡSMAP.grp
    local slen = FileLength(cc.s_filename[0])
    local sdata = Byte.create(slen)
    local menu = {}
    for i = 1, cc.save_num do
        local name = ""
        local sname = ""
        local nd = ""           -- �Ѷ�
        local time = ""
        local tssl = ""         -- ��������
        local zjlx = ""         -- ��������
        local zz = ""           -- ����

        if PD_ExistFile(string.format("data/save/Save_%d", i)) then
            Byte.loadfilefromzip(data, string.format("data/save/Save_%d", i), "r.grp", 0, len)
            local pid = GetDataFromStruct(data, 0, table_struct, "����1")
            name = GetDataFromStruct(data, pid * cc.person_size, table_struct, "����")
            zz = GetDataFromStruct(data, pid * cc.person_size, table_struct, "����")
            local wy = GetDataFromStruct(data, 0, table_struct, "����")
            if wy == -1 then
                sname = "���ͼ"
            else
                sname = GetDataFromStruct(data, wy * cc.scene_size, table_struct, "��������") .. ""
            end
            local lxid1 = GetDataFromStruct(data, 0, table_struct, "��׼")
            local lxid2 = GetDataFromStruct(data, 0, table_struct, "����")
            local lxid3 = GetDataFromStruct(data, 0, table_struct, "����")
            if lxid1 > 0 then
                zjlx = "��׼"
            elseif lxid2 > 0 then
                zjlx = "����"
            elseif lxid3 > 0 then
                zjlx = "����"
            end
            local wz = GetDataFromStruct(data, 0, table_struct, "�Ѷ�")
            tssl = GetDataFromStruct(data, 0, table_struct, "��������") .. "��"
            nd = MODEXZ2[wz]
        end

        if i < 10 then
            menu[i] = {string.format("�浵%02d %-4s %-10s %-4s %4s %4s %-10s", i, zjlx, name, nd, zz, tssl, sname), nil, 1}
        else
            menu[i] = {string.format("�Զ��� %-4s %-10s %-4s %4s %4s %-10s", zjlx, name, nd, zz, tssl, sname), nil, 1}
        end
    end

    local menu_x = (cc.screen_w - 24 * cc.default_font - 2 * cc.menu_border_pixel) / 2
    local menu_y = (cc.screen_h - 9 * (cc.default_font + cc.row_pixel)) / 2
    local r = Gra_ShowMenu(menu, cc.save_num, 10, menu_x, menu_y, 0, 0, 1, 1, cc.default_font, C_WHITE, C_GOLD)
    Debug("SaveList")
    CleanMemory()

    return r
end

-- �����ݵĽṹ�з������ݣ�����ȡ����
-- data������������
-- offset��data�е�ƫ��
-- t_struct�����ݵĽṹ����jyconst���кܶඨ��
-- key�����ʵ�key
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

-- �����ݵĽṹ�з������ݣ�������������
-- data������������
-- offset��data�е�ƫ��
-- t_struct�����ݵĽṹ����jyconst���кܶඨ��
-- key�����ʵ�key
-- v��д���ֵ
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

-- ��ȡ�ļ�����
function FileLength(filename)
    local inp = io.open(filename, "rb")
    local l = inp:seek("end")
    inp:close()

    return l
end

-- �ж��ļ��Ƿ����
function PD_ExistFile(filename)
    local f = io.open(filename)
    if f == nil then
        return false
    end
    io.close(f)

    return true
end

-- ����x�ķ�Χ
function LimitX(x, min, max)
    if x < min then
        x = min
    end
    if max ~= nil and x > max then
        x = max
    end

    return x
end

-- �ȴ���������
function WaitKey()
    -- ktype��1 ���̣�2 ����ƶ���3 ��������4 ����Ҽ���5 ����м���6 �����ϣ�7 ������
    local key, ktype, mx, my = -1, -1, -1, -1
    key, ktype, mx, my = lib.GetKey()

    return key, ktype, mx, my
end

-- ��ʱt����
function Delay(t)
    -- ����У��
    if t <= 0 then
        return
    end

    lib.Delay(t)
end

-- ��������Ŀ¼�µ�debug.txt�ļ�����������ַ���
function Debug(str)
    -- ����У��
    if str == nil then
        return
    end

    lib.Debug(str)
end

-- ����
function instruct_0()
    Gra_Cls()
end

-- �Ի�
-- talkid: Ϊ���֣���Ϊ�Ի���ţ�Ϊ�ַ�������Ϊ�Ի�����
-- headid: ͷ��id
-- flag���Ի���λ��
--      =0����Ļ�Ϸ���ʾ, ���ͷ���ұ߶Ի�
--      =1����Ļ�·���ʾ, ��߶Ի����ұ�ͷ��
--      =2����Ļ�Ϸ���ʾ, ��߿գ��ұ߶Ի�
--      =3����Ļ�·���ʾ, ��߶Ի����ұ߿�
--      =4����Ļ�Ϸ���ʾ, ��߶Ի����ұ�ͷ��
--      =5����Ļ�·���ʾ, ���ͷ���ұ߶Ի�
function instruct_1(talkid, headid, flag)
    local s = ReadTalk(talkid)
    if s == nil then 
        return
    end
    TalkEx(s, headid, flag)
end

-- �õ���Ʒ
function instruct_2(thingid, num)
    if jy.thing[thingid] == nil then
        return 
    end
    instruct_32(thingid, num)
    if num > 0 then
        Gra_DrawStrBoxWaitKey(string.format("�õ���Ʒ%sX%d", "����"..jy.thing[thingid]["����"].."�ϡ�", num), C_ORANGE, cc.default_font, 1)
    else
        Gra_DrawStrBoxWaitKey(string.format("ʧȥ��Ʒ%sX%d", "����"..jy.thing[thingid]["����"].."�ϡ�", -num), C_ORANGE, cc.default_font, 1)
    end
end

-- �޸�ָ������������¼�
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

-- �ж���ǰѡ����Ʒ
function instruct_4(thingid)
    if jy.current_thing == thingid then
        return true
    else
        return false
    end
end

----------------------------------------
--
-- orionids�����º������������������ṩ�Ŀ�����lua�е��õĺ���
-- ע�⣬����ЩAPIû��������Ĳ����ļ�鹤�������Ҫȷ������Ĳ����Ǻ����
-- ���������ܻ����Ҳ����ʲô������
--
----------------------------------------

-- Byte.create(size)
-- ����һ���������ֽ����飬sizeΪ�����С

-- Byte.get16(b, start)
-- ������b�ж�ȡһ���з���16λ����
-- start�������еĶ�ȡλ�ã���0��ʼ

-- Byte.get32(b, start)
-- ������b�ж�ȡһ���з���32λ����

-- Byte.getstr(b, start, length)
-- ������b�ж�ȡһ���ַ���������Ϊlength

-- Byte.getu16(b, start)
-- ������b�ж�ȡһ���޷���16λ��������Ҫ���ڷ������ﾭ��

-- Byte.loadfile(b, filename, start, length)
-- ���ļ�filename�м������ݵ��ֽ�����b��
-- start����ȡλ�ã����ļ���ʼ�����ֽ�������0��ʼ
-- length��Ҫ�����ֽ���

-- Byte.savefile(b, filename, start, length)
-- ���ֽ�����b������д���ļ�filename��
-- start����ȡλ�ã����ļ���ʼ�����ֽ�������0��ʼ
-- length��Ҫ�����ֽ���

-- Byte.set16(b, start, v)
-- ���з���16λ����д������b��
-- start�������е�дλ�ã���0��ʼ

-- Byte.set32(b, start, v)
-- ���з���32λ����д������b��

-- Byte.setstr(b, start, length, str)
-- ���ַ���strд�뵽����b�У��д�볤��Ϊlength

-- Byte.setu16(b, start, v)
-- ���޷���16λ����д������b��

-- lib.CharSet(str, flag)
-- ���ذ�strת������ַ���
-- flag = 0��Big5 -> GBK   
--      = 1��GBK -> Big5
--      = 2��Big5 -> Unicode
--      = 3��GBK -> Unicode

-- lib.CleanWarMap(level, v)
-- ��level��ս������ȫ����ֵv

-- lib.EnableKeyRepeat(delay, interval)
-- ���ü����ظ���
-- delayΪ��һ���ظ����ӳٺ�������intervalΪ���ٺ����ظ�һ��
-- ESC, RETURN ��SPACE���Ѿ�ȡ���ظ���һֱ����Ҳֻ��Ϊ�ǰ���һ��



-- lib.GetKey()
-- �õ���ǰ�������룬���붨��μ�SDL�ĵ�
-- �˺���������̻������ͼ����ظ��ʣ����ص��Ǵ��ϴε��������������µļ�
-- ����ֻ������һ�������������������Ҫ������̻���������Ҫ�ȵ���һ�δ˺���

-- lib.GetTime()
-- ���ؿ�������ǰ�ĺ�����

-- lib.PlayMIDI(filename)
-- �ظ�����MID�ļ�filename����filenameΪ���ַ�������ֹͣ���ŵ�ǰ���ڲ��ŵ�midi

-- lib.PlayWAV(filename) 
-- ������ЧAVI�ļ�filename

-- lib.UnloadMMap()
-- �ͷ�����ͼռ���ڴ�