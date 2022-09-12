--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- orionids������Ϊ�������Լ���غ���
-- �������ô��շ�ʽ��������������ʹ��С�»�����������������ʹ�ô��»�����������

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



-- ��������lua�ļ�
function IncludeFile()
    package.path = CONFIG.ScriptLuaPath -- ���ü���·��
    -- ���������ļ���ʹ��require�����ظ�����
    require("jyconst")                  -- ��������
    require("jywar")                    -- ս������
    require("jygraphic")                -- ͼ�������
    require("kdef")                     -- �¼�����
    require("jyitem")                   -- ��Ʒ��Ϣ
    require("jyperson")                 -- ������Ϣ
    require("jyskill")                  -- �书��Ϣ
    require("jyenterprise")             -- �������
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

    jy.restart = 0                      -- ������Ϸ��ʼ����
    jy.walk_count = 0                   -- ��·�Ʋ�
end

-- ���������
function JY_Main()
    --os.remove("debug.txt")              -- �����ǰ��debug���
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

    -- ��ʼ�������������
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
    jy.status = GAME_START              -- �ı���Ϸ״̬
    Gra_PicInit()                       -- ��ʼ����ͼCache
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
        Gra_ShowSlow(20, 0)             -- ������ʾ����

        local r = StartMenu()           -- ��ʾ��Ϸ��ʼ�˵�����
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

-- ������Ͻ�X������Alt + F4�ر���Ϸʱִ�еĺ���
-- ���������ɸģ��ڵײ���д��
function Menu_Exit()
    -- ���浱ǰ��Ļ
    local surid = lib.SaveSur(0, 0, cc.screen_w, cc.screen_h)
    local choice = 1            -- ѡ�1 ������Ϸ��2 ���س�ʼ��3 �뿪��Ϸ��Ĭ����1��λ��
    
    -- ���浱ǰ״̬
    local status = jy.status
    jy.status = GAME_BLACK

    while true do
        if jy.restart == 1 then
            return
        end

        Gra_DrawMenuExit(choice)    -- ���Ʋ˵�

        local key = GetKey()        -- ��ȡ��ֵ
        -- ��ESC����Ч����ͬ��ѡ�񡸼�����Ϸ��
        if key == VK_ESCAPE then
            PlayWav(77)
            jy.status = status
            lib.LoadSur(surid, 0, 0)
            Gra_ShowScreen()
            lib.FreeSur(surid)
            return 0
        -- ���ϡ����
        elseif key == VK_UP or key == VK_LEFT then
            PlayWav(77)
            choice = choice - 1
            if choice < 1 then
                choice = 3
            end
        -- ���¡��Ҽ�
        elseif key == VK_DOWN or key == VK_RIGHT then
            PlayWav(77)
            choice = choice + 1
            if choice > 3 then
                choice = 1
            end
        -- ���ո񡢻س���
        elseif key ==VK_SPACE or key == VK_RETURN then
            PlayWav(77)
            -- ѡ���뿪��Ϸ��
            if choice == 3 then
                jy.status = GAME_END
                lib.FreeSur(surid)
                return 1
            -- ѡ�񡸷��س�ʼ��
            elseif choice == 2 then
                jy.restart = 1
                jy.status = GAME_START
                lib.FreeSur(surid)
                return 0
            -- ѡ�񡸼�����Ϸ��
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

-- ��Ϸ��ʼ�˵�����
function StartMenu()
    local menu_return = TitleSelection()
    Gra_Cls()

    -- ����é®
    if menu_return == 1 then
        if jy.restart == 1 then
            do return end
        end

        NewGame()

    -- ��ս����
    elseif menu_return == 2 then
        lib.LoadPNG(5, 501 * 2, -1, -1, 1)
        Gra_DrawStrBox(-1, cc.screen_h *1 / 6 - 20, '��ȡ����', C_LIMEGREEN, cc.font_size_40, C_GOLD)
        Gra_ShowScreen()
        Delay(5000)

        -- local r = SaveList()
        -- -- ESC���·���ѡ��
        -- if r < 1 then
        --     local s = StartMenu()
        --     return s
        -- end

        -- Gra_DrawStrBox(-1, cc.start_menu_y, "���Ժ�...", C_GOLD, cc.default_font)
        -- Gra_ShowScreen()
        -- Delay(2000)
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
    -- �뿪��Ϸ
    else
        return -1
    end
end

-- ��Ϸ��ʼ����ѡ��
---@return number ѡ�����
function TitleSelection()
    local choice = 1            -- ѡ�1 ��ʼ��Ϸ��2 ������Ϸ��3 �˳���Ϸ��Ĭ����1��λ��

    while true do
        if jy.restart == 1 then
            return
        end
        local key = GetKey()    -- ��ȡ��ֵ
        -- ���¡��Ҽ�
        if key == VK_DOWN or key == VK_RIGHT then
            PlayWav(77)
            choice = choice + 1
            if choice > 3 then
                choice = 1
            end
        -- ���ϡ����
        elseif key == VK_UP or key == VK_LEFT then
            PlayWav(77)
            choice = choice - 1
            if choice < 1 then
                choice = 3
            end
        elseif key == VK_RETURN then
            break
        end

        Gra_DrawTitle(choice)         -- ����ѡ��
    end

    return choice
end

-- ѡ������Ϸ���������ǳ�ʼ����
function NewGame()
    Gra_Cls()
    Gra_ShowScreen()
    LoadRecord(0)

    -- ����NPC�������ɣ���upedit����

    -- ѡ��������ǳ��루���棩
    -- page763
    jy.status = GAME_NEWGAME

    -- ѡ�ˣ������б�ͳ����б�
    -- ���������Ҫ��������

    -- ѡ����Ϸ�Ѷȡ�����ģʽ
    -- page768

    -- ѡ������������
    -- page1185

    -- ѡ���ʼ�츳
    -- page1191

    -- ����Ѷ��£�NPC�������װ

    -- һЩNPC�ĳ�ʼ���������Ѷȵ������Լӳ�
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
    -- �����Ϸ������Ϊ���������֣��򷵻�
    if jy.enable_music == 0 then
        return
    end
    -- �����趨������·�������֣�����Ϊid + 1
    if id >= 0 then                             
        lib.PlayMIDI(string.format(cc.midi_file, id + 1))
    end
end

-- ������Ч
-- id��Ҫ���ŵ���Чid
function PlayWav(id)
    -- �����Ϸ������Ϊ��������Ч���򷵻�
    if jy.enable_sound == 0 then
        return
    end
    -- �����趨����Ч·������Ч����ЧΪid
    if id >= 0 then
        lib.PlayWAV(string.format(cc.e_file, id))
    end
end

-- ��ȡ��Ϸ����
-- id�� =0 ����Ϸ��=1..10 ��Ϸ�浵
-- �������Ȱ����ݶ���Byte�����У�Ȼ���������Ӧ��ķ������ڷ��ʱ�ʱֱ�Ӵ��������
-- ����ǰ��ʵ����ȣ����ļ��ж�ȡ�ͱ��浽�ļ���ʱ�������ӿ졣�����ڴ�ռ������
function LoadRecord(id)
    local zip_file = string.format('SAVE/Save_%d', id)
    if id ~= 0 and (existFile(zip_file) == false) then
        -- QZXS("�˴浵���ݲ�ȫ�����ܶ�ȡ����ѡ�������浵�����¿�ʼ")
        return -1
    end
    -- ��ѹ�浵�ļ�������������ļ��ֱ�����Ϊr.grp, d.grp, s.grp, tjm
    Byte.unzip(zip_file, 'r.grp', 'd.grp', 's.grp', 'tjm')
    
    -- ����ʱ��
    local time = GetTime()

    -- ��ȡR*.idx�ļ�
    -- �ܹ�6�����࣬�ֱ�Ϊ�������ݡ������Ʒ���������书���̵�
    -- ÿ������ռ��4���ֽڣ�����ܹ�6 * 4 = 24���ֽ�
    -- �����idx�ļ�ֻ��Ŀ¼��������¼����ĳ���
    local data = ByteCreate(6 * 4)
    ByteLoadFile(data, cc.r_idx_filename[1], 0, 6 * 4)

    -- �ѷ���ĳ��ȷŵ�idx��
    local idx = {}
    for i = 1, 6 do
        idx[i] = ByteGet32(data, 4 * (i - 1))
    end

    -- ���ǿ��µ�����ʹ�ó�ʼ���ݣ�����ʹ�ô浵����
    local grpFile = 'r.grp'
    local sFile = 's.grp'
    local dFile = 'd.grp'
    if id == 0 then
        grpFile = cc.r_grp_filename[1]
        sFile = cc.s_filename[1]
        dFile = cc.d_filename[1]
    end

    -- ��ȡR*.grp�ļ�
    -- ��������������
    jy.raw_base_data = Byte.create(idx[1])
    ByteLoadFile(jy.raw_base_data, grpFile, 0, idx[1])
    -- ���÷��ʻ������ݵķ����������Ϳ����÷��ʱ�ķ�ʽ������
    -- �����ðѶ���������ת��Ϊ����Լ����ʱ��Ϳռ�
    local meta_t = {
        __index = function(t, k)
            return GetDataFromStruct(jy.raw_base_data, 0, cc.base_s, k)
        end,

        __newindex = function(t, k, v)
            SetDataFromStruct(jy.raw_base_data, 0, cc.base_s, k, v)
        end
    }
    setmetatable(jy.base, meta_t)

    -- ��������
    jy.person_num = math.floor((idx[2] - idx[1]) / cc.person_size)
    -- �������������
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

    -- ��Ʒ����
    jy.thing_num = math.floor((idx[3] - idx[2]) / cc.thing_size)
    -- ��Ʒ����������
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

    -- ��������
    jy.scene_num = math.floor((idx[4] - idx[3]) / cc.scene_size)
    -- ��������������
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

    -- �书����
    jy.wugong_num = math.floor((idx[5] - idx[4]) / cc.wugong_size)
    -- �书����������
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

    -- �̵�����
    jy.shop_num = math.floor((idx[6] - idx[5]) / cc.shop_size)
    -- �̵����������
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
    -- ��һ�������������ռ�ѭ��
    collectgarbage()
    jy.load_time = GetTime()
    rest()

    -- if id > 0 then 
    --     tjmload(id)
    -- end

    -- ɾ����ѹ�ļ�
    os.remove('r.grp')
    os.remove('d.grp')
    os.remove('s.grp')
    os.remove('tjm')
end

-- д��Ϸ����
-- id�� =0 ����Ϸ��=1..10 ��Ϸ�浵
function SaveRecord(id)
    -- �ж��Ƿ����ӳ�������
    if jy.status == GAME_SMAP then
        jy.base['�ӳ���'] = jy.sub_scene
    else
        jy.base['�ӳ���'] = -1
    end

    -- ����ʱ�����
    local time = GetTime()
    jy.save_time = GetTime()
    jy.game_time = math.modf((jy.save_time - jy.load_time) / 60000)
    SetS(14, 2, 1, 4, GetS(14, 2, 1, 4) + jy.game_time)
    jy.load_time = GetTime()

    -- ��ȡR*.idx�ļ�
    -- �ܹ�6�����࣬�ֱ�Ϊ�������ݡ������Ʒ���������书���̵�
    -- ÿ������ռ��4���ֽڣ�����ܹ�6 * 4 = 24���ֽ�
    -- �����idx�ļ�ֻ��Ŀ¼��������¼����ĳ���
    local data = ByteCreate(6 * 4)
    ByteLoadFile(data, cc.r_idx_filename[1], 0, 6 * 4)

    -- �ѷ���ĳ��ȷŵ�idx��
    local idx = {}
    for i = 1, 6 do
        idx[i] = ByteGet32(data, 4 * (i - 1))
    end

    -- дR*.grp�ļ�
    ByteSaveFile(jy.raw_base_data, 'r.grp', 0, idx[1])
    ByteSaveFile(jy.raw_person_data, 'r.grp', idx[1], cc.person_size * jy.person_num)
    ByteSaveFile(jy.raw_thing_data, 'r.grp', idx[2], cc.thing_size * jy.thing_num)
    ByteSaveFile(jy.raw_scene_data, 'r.grp', idx[3], cc.scene_size * jy.scene_num)
    ByteSaveFile(jy.raw_wugong_data, 'r.grp', idx[4], cc.wugong_size * jy.wugong_num)
    ByteSaveFile(jy.raw_shop_data, 'r.grp', idx[5], cc.shop_size * jy.shop_num)
    SaveSMap('s.grp', 'd.grp')

    -- ���ѹ���浵
    local zip_file = string.format('SAVE/Save_%d', id)
    Byte.zip(zip_file, 'r.grp', 'd.grp', 's.grp')
    os.remove('r.grp')
    os.remove('d.grp')
    os.remove('s.grp')
end

-- �浵�б�
function SaveList()
    -- ��ȡR*.idx�ļ�
    -- �ܹ�6�����࣬�ֱ�Ϊ�������ݡ������Ʒ���������书���̵�
    -- ÿ������ռ��4���ֽڣ�����ܹ�6 * 4 = 24���ֽ�
    -- �����idx�ļ�ֻ��Ŀ¼��������¼����ĳ���
    local data = ByteCreate(6 * 4)
    ByteLoadFile(data, cc.r_idx_filename[1], 0, 6 * 4)

    -- �ѷ���ĳ��ȷŵ�idx��
    local idx = {}
    for i = 1, 6 do
        idx[i] = ByteGet32(data, 4 * (i - 1))
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
    CleanMemory()

    return r
end

-- �����ݵĽṹ�з������ݣ�����ȡ����
-- data������������
-- offset��data�е�ƫ��
-- t_struct�����ݽṹ����jyconst���кܶඨ��
-- key�����ʵ�key
function GetDataFromStruct(data, offset, t_struct, key)
    local t = t_struct[key]
    local r
    -- �з���
    if t[2] == 0 then
        r = ByteGet16(data, t[1] + offset)
    -- �޷���
    elseif t[2] == 1 then
        r = ByteGetu16(data, t[1] + offset)
    -- �ַ���
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

-- �����ݵĽṹ�з������ݣ�������������
-- data������������
-- offset��data�е�ƫ��
-- t_struct�����ݵĽṹ����jyconst���кܶඨ��
-- key�����ʵ�key
-- v��д���ֵ
function SetDataFromStruct(data, offset, t_struct, key, v)
    local t = t_struct[key]
    -- �з���
    if t[2] == 0 then
        ByteSet16(data, t[1] + offset, v)
    -- �޷���
    elseif t[2] == 1 then
        ByteSetu16(data, t[1] + offset, v)
    -- �ַ���
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

-- ��S*
-- id���������
-- xy������
-- level��������ͼ���ݲ���
--      =0 �������ݣ�=1 ������=2 ս����ս�����
--      =3 �ƶ�ʱ��ʾ���ƶ���λ�ã�=4 ����Ч����=5 ս���˶�Ӧ����ͼ
function GetS(id, x, y, level)
    local err = -1      -- ������
    if not id or not x or not y or not level then
        err = 1         -- ����ʡ�Դ���
    elseif id < 0 then
        err = 2         -- id����
    elseif x < 0 or y < 0 then
        err = 3         -- xy����
    elseif level < 0 or level > 5 then
        err = 4         -- level����
    end

    -- ����ʱ���ش�����
    if err > 0 then
        Debug("GetS Error, error code: " .. err)
        return
    end

    return lib.GetS(id, x, y, level)
end

-- дS*
-- id���������
-- xy������
-- level��������ͼ���ݲ���
--      =0 �������ݣ�=1 ������=2 ս����ս�����
--      =3 �ƶ�ʱ��ʾ���ƶ���λ�ã�=4 ����Ч����=5 ս���˶�Ӧ����ͼ
-- v��д���ֵ
function SetS(id, x, y, level, v)
    local err = -1      -- ������
    if not id or not x or not y or not level or not v then
        err = 1         -- ����ʡ�Դ���
    elseif id < 0 then
        err = 2         -- id����
    elseif x < 0 or y < 0 then
        err = 3         -- xy����
    elseif level < 0 or level > 5 then
        err = 4         -- level����
    elseif type(v) ~= "number" then
        err = 5         -- v����
    end

    -- ����ʱ���ش�����
    if err > 0 then
        Debug("SetS Error, error code: " .. err)
        return
    end

    return lib.SetS(id, x, y, level)
end

-- ��D*
-- sceneid���������
-- id���ó���D*���
-- i���ڼ�������
function GetD(sceneid, id, i)
    local err = -1      -- ������
    if not sceneid or not id or not i then
        err = 1         -- ����ʡ�Դ���
    elseif sceneid < 0 then
        err = 2         -- sceneid����
    elseif id < 0 then
        err = 3         -- id����
    elseif i < 0 then
        err = 4         -- i����
    end

    -- ����ʱ���ش�����
    if err > 0 then
        Debug("GetD Error, error code: " .. err)
        return
    end

    return lib.GetD(sceneid, id, i)
end

-- дD*
-- sceneid���������
-- id���ó���D*���
-- i���ڼ�������
-- v��д���ֵ
function SetD(sceneid, id, i, v)
    local err = -1      -- ������
    if not sceneid or not id or not i or not v then
        err = 1         -- ����ʡ�Դ���
    elseif sceneid < 0 then
        err = 2         -- sceneid����
    elseif id < 0 then
        err = 3         -- id����
    elseif i < 0 then
        err = 4         -- i����
    elseif type(v) ~= "number" then
        err = 5         -- v����
    end

    -- ����ʱ���ش�����
    if err > 0 then
        Debug("SetD Error, error code: " .. err)
        return
    end

    return lib.SetD(sceneid, id, i, v)
end

-- ȡ���ͼ�ṹ��Ӧ�����ֵ
-- flag�� =0 earth, =1 surface, =2 building, =3 buildx, =4 buildy
-- ����һ��ֵ��Ϊflag��Ĵ��ͼ��������
function GetMMap(x, y, flag)
    local err = -1      -- ������
    if not x or not y or not flag then
        err = 1         -- ����ʡ�Դ���
    end

    -- ����ʱ���ش�����
    if err > 0 then
        Debug("GetMMap Error, error code: " .. err)
        return
    end

    return lib.GetMMap(x, y, flag)
end

-- ȡս����ͼ����
-- xy������
-- level��ս����ͼ���ݲ���
--      =0 �������ݣ�=1 ������=2 ս����ս�����
--      =3 �ƶ�ʱ��ʾ���ƶ���λ�ã�=4 ����Ч����=5 ս���˶�Ӧ����ͼ
-- ����һ��ֵ��Ϊ�ò��ս����ͼ��������
function GetWarMap(x, y, level)
    local err = -1      -- ������
    if not x or not y or not level then
        err = 1         -- ����ʡ�Դ���
    end

    -- ����ʱ���ش�����
    if err > 0 then
        Debug("GetWarMap Error, error code: " .. err)
        return
    end

    return lib.GetWarMap(x, y, level)
end

-- lib.SetWarMap(x, y, level, v)
-- ��ս����ͼ����
-- xy������
-- level��ս����ͼ���ݲ���
--      =0 �������ݣ�=1 ������=2 ս����ս�����
--      =3 �ƶ�ʱ��ʾ���ƶ���λ�ã�=4 ����Ч����=5 ս���˶�Ӧ����ͼ
-- v��д���ֵ
function SetWarMap(x, y, level, v)
    local err = -1      -- ������
    if not x or not y or not level or not v then
        err = 1         -- ����ʡ�Դ���
    end

    -- ����ʱ���ش�����
    if err > 0 then
        Debug("SetWarMap Error, error code: " .. err)
        return
    end

    lib.SetWarMap(x, y, level, v)
end

-- ����S*��D*
function SaveSMap(Sfilename, Dfilename)
    local err = -1      -- ������
    if not Sfilename or not Dfilename then
        err = 1         -- ����ʡ�Դ���
    elseif type(Sfilename) ~= "string" then
        err = 2         -- Sfilename����
    elseif type(Dfilename) ~= "string" then
        err = 3         -- Dfilename����
    end

    -- ����ʱ���ش�����
    if err > 0 then
        Debug("SaveSMap Error, error code: " .. err)
        return
    end

    lib.SaveSMap(Sfilename, Dfilename)
end

-- �õ�PNGͼƬ��XYֵ
-- fileid��ָ��id����Gra_LoadPNGPath����ָ��
-- picid��picid��ָ��ͼƬ��id����2��������Ҫ�����pngͼƬ��2.png����ô����picidҪ��4��ͼƬ��һ��Ҫ������
-- ��������ֵ���ֱ�Ϊx��y����ʾ��ѯͼƬ�Ŀ�͸�
function GetPNGXY(fileid, picid)
    local err = -1      -- ������
    if not fileid or not picid then
        err = 1         -- ����ʡ�Դ���
    end

    -- ����ʱ���ش�����
    if err > 0 then
        Debug("GetPNGXY Error, error code: " .. err)
        return
    end

    return lib.GetPNGXY(fileid, picid)
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

-- �õ���ǰ�������룬���붨��μ�SDL�ĵ�
-- �˺���������̻������ͼ����ظ��ʣ����ص��Ǵ��ϴε��������������µļ�
-- ����ֻ������һ�������������������Ҫ������̻���������Ҫ�ȵ���һ�δ˺���
-- ����key��ktype��mx��my�ĸ�ֵ
-- key�����µİ���
-- ktype��1 ���̣�2 ����ƶ���3 ��������4 ����Ҽ���5 ����м���6 �����ϣ�7 ������
-- mx��my�����xy��
function GetKey()
    return lib.GetKey()
end

-- ���ü����ظ���
-- delayΪ��һ���ظ����ӳٺ�������intervalΪ���ٺ����ظ�һ��
-- ESC, RETURN ��SPACE���Ѿ�ȡ���ظ���һֱ����Ҳֻ��Ϊ�ǰ���һ��
function EnableKeyRepeat(delay, interval)
    local err = -1      -- ������
    if not delay or not interval then
        err = 1         -- ����ʡ�Դ���
    elseif delay < 0 then
        err = 2         -- delay����
    elseif interval < 0 then
        err = 3         -- interval����
    end

    -- ����ʱ���ش�����
    if err > 0 then
        Debug("EnableKeyRepeat Error, error code: " .. err)
        return
    end

    lib.EnableKeyRepeat(delay, interval)
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

-- lib.CharSet(str, flag)
-- ���ذ�strת������ַ���
-- flag��=0 Big5 -> GBK   
--       =1 GBK -> Big5
--       =2 Big5 -> Unicode
--       =3 GBK -> Unicode
function CharSet(str, flag)
    if not str or not flag then
        error('����ʡ�Դ���')
    elseif type(str) ~= "string" then
        error('str����')
    elseif flag < 0 or flag > 3 then
        error('flag����')
    end

    return lib.CharSet(str, flag)
end

-- ���ؿ�������ǰ�ĺ�����
function GetTime()
    return lib.GetTime()
end

-- �ͷ�����ͼռ���ڴ�
function UnloadMMap()
    lib.UnloadMMap()
end

-- ����һ���������ֽ����飬sizeΪ�����С
function ByteCreate(size)
    if not size then
        error('����ʡ�Դ���')
    elseif size < 0 then
        error('size����')
    end

    return Byte.create(size)
end

-- ������b�ж�ȡһ���з���16λ����
-- start�������еĶ�ȡλ�ã���0��ʼ
function ByteGet16(b, start)
    if not b or not start then
        error('����ʡ�Դ���')
    end

    return Byte.get16(b, start)
end

-- ������b�ж�ȡһ���з���32λ����
-- start�������еĶ�ȡλ�ã���0��ʼ
function ByteGet32(b, start)
    if not b or not start then
        error('����ʡ�Դ���')
    end

    return Byte.get32(b, start)
end

-- ������b�ж�ȡһ���޷���16λ��������Ҫ���ڷ������ﾭ��
-- start�������еĶ�ȡλ�ã���0��ʼ
function ByteGetu16(b, start)
    if not b or not start then
        error('����ʡ�Դ���')
    end

    return Byte.getu16(b, start)
end

-- ������b�ж�ȡһ���ַ���������Ϊlength
-- start�������еĶ�ȡλ�ã���0��ʼ
function ByteGetStr(b, start, length)
    if not b or not start or not length then
        error('����ʡ�Դ���')
    end

    return Byte.getstr(b, start, length)
end

-- ���ļ�filename�м������ݵ��ֽ�����b��
-- start����ȡλ�ã����ļ���ʼ�����ֽ�������0��ʼ
-- length��Ҫ�����ֽ���
function ByteLoadFile(b, filename, start, length)
    if not b or not filename or not start or not length then
        error('����ʡ�Դ���')
    end

    Byte.loadfile(b, filename, start, length)
end

-- ���ֽ�����b������д���ļ�filename��
-- start��д��λ�ã����ļ���ʼ�����ֽ�������0��ʼ
-- length��Ҫд���ֽ���
function ByteSaveFile(b, filename, start, length)
    if not b or not filename or not start or not length then
        error('����ʡ�Դ���')
    end

    Byte.savefile(b, filename, start, length)
end

-- ���з���16λ����д������b��
-- start�������е�дλ�ã���0��ʼ
-- v��д���ֵ
function ByteSet16(b, start, v)
    if not b or not start or not v then
        error('����ʡ�Դ���')
    end

    Byte.set16(b, start, v)
end

-- ���з���32λ����д������b��
-- start�������е�дλ�ã���0��ʼ
-- v��д���ֵ
function ByteSet32(b, start, v)
    if not b or not start or not v then
        error('����ʡ�Դ���')
    end

    Byte.set32(b, start, v)
end

-- ���޷���16λ����д������b��
-- start�������е�дλ�ã���0��ʼ
-- v��д���ֵ
function ByteSetu16(b, start, v)
    if not b or not start or not v then
        error('����ʡ�Դ���')
    end

    Byte.setu16(b, start, v)
end

-- ���ַ���strд�뵽����b�У��д�볤��Ϊlength
-- start�������е�дλ�ã���0��ʼ
function ByteSetStr(b, start, length, str)
    if not b or not start or not length or not str then
        error('����ʡ�Դ���')
    end

    Byte.setstr(b, start, length, str)
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