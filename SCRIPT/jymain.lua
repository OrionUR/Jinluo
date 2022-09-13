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
    require('jyconst')                  -- ��������
    require('jywar')                    -- ս������
    require('jygraphic')                -- ͼ�������
    require('kdef')                     -- �¼�����
    require('jyitem')                   -- ��Ʒ��Ϣ
    require('jyperson')                 -- ������Ϣ
    require('jyskill')                  -- �书��Ϣ
    require('jyenterprise')             -- �������
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
    --os.remove('debug.txt')              -- �����ǰ��debug���
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
            error('attempt read write to undeclared variable ' .. n, 2)
        end,
        __index = function (_, n)
            error('attempt read read to undeclared variable ' .. n, 2)
        end
    })

    -- ��ʼ�������������
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
    jy.status = GAME_START              -- �ı���Ϸ״̬
    PicInit()                       -- ��ʼ����ͼCache
    FillColor()                     -- ��Ļ����
    SetAllPNGAddress()              -- ����������ͼ��ַ������id

    while true do
        if jy.restart == 1 then
            jy.restart = 0
            jy.status = GAME_START
        end
        if jy.status == GAME_END then
            break
        end

        PlayMidi(75)                    -- ��������
        Cls()                       -- ����
        ShowSlow(20, 0)             -- ������ʾ����

        local r = StartMenu()           -- ��ʾ��Ϸ��ʼ�˵�����
        if r ~= nil then
            return
        end

        -- lib.LoadPicture('', 0, 0)               -- ����ͼƬ
        -- GetKey()                            -- ��ȡ��ֵ

        -- Game_Cycle()                            -- ��Ϸѭ��
    end
end

-- ����lua�ڴ�
function CleanMemory()
    if CONFIG.CleanMemory == 1 then
        -- ��һ�������������ռ�ѭ��
        collectgarbage('collect')
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

        DrawMenuExit(choice)    -- ���Ʋ˵�

        local key = GetKey()        -- ��ȡ��ֵ
        -- ��ESC����Ч����ͬ��ѡ�񡸼�����Ϸ��
        if key == VK_ESCAPE then
            PlayWav(77)
            jy.status = status
            lib.LoadSur(surid, 0, 0)
            ShowScreen()
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
                ShowScreen()
                lib.FreeSur(surid)
                return 0
            end
        end
    end
end

-- ��Ϸ��ʼ�˵�����
function StartMenu()
    local menu_return = TitleSelection()
    Cls()

    -- ����é®
    if menu_return == 1 then
        if jy.restart == 1 then
            do return end
        end

        NewGame()

    -- ��ս����
    elseif menu_return == 2 then
        lib.LoadPNG(5, 501 * 2, -1, -1, 1)
        DrawStrBox(-1, cc.screen_h *1 / 6 - 20, '��ȡ����', C_LIMEGREEN, cc.font_size_40, C_GOLD)
        ShowScreen()
        Delay(5000)

        -- local r = SaveList()
        -- -- ESC���·���ѡ��
        -- if r < 1 then
        --     local s = StartMenu()
        --     return s
        -- end

        -- DrawStrBox(-1, cc.start_menu_y, '���Ժ�...', C_GOLD, cc.default_font)
        -- ShowScreen()
        -- Delay(2000)
        -- local result = Loadrecord(r)
        -- if result ~= nil then
        --     return StartMenu()
        -- end

        -- if jy.base['����'] ~= -1 then
        --     if jy.sub_scene < 0 then
        --         CleanMemory()
        --     end
        --     lib.ShowSlow(20, 1)
        --     jy.status = GAME_SMAP
        --     jy.sub_scene = jy.base['����']
        --     jy.mmap_music = -1
        --     jy.my_pic = GetMyPic()
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

        DrawTitle(choice)         -- ����ѡ��
    end

    return choice
end

-- ѡ������Ϸ���������ǳ�ʼ����
function NewGame()
    Cls()
    ShowScreen()
    LoadRecord(0)

    -- ����NPC�������ɣ���upedit����

    -- ѡ��������ǳ��루���棩
    -- page763

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

-- ������Ҫ��ȡ������ͼ��fileid
-- 1 ͷ��2 ��Ʒ��3 ��Ч��4 ������5 UI
function SetAllPNGAddress()
    -- ͷ��
    LoadPNGPath(cc.head_path, 1, cc.head_num, LimitX(cc.fit_width * 100, 0, 100))
    -- ��Ʒ
    LoadPNGPath(cc.thing_path, 2, cc.thing_num, LimitX(cc.fit_width * 100, 0, 100))
    -- ��Ч
    LoadPNGPath(cc.eft_path, 3, cc.eft_num, LimitX(cc.fit_width * 100, 0, 100))
    -- ������
    LoadPNGPath(cc.body_path, 4, cc.body_num, LimitX(cc.fit_width * 100, 0, 100))
    -- UI
    LoadPNGPath(cc.ui_path, 5, cc.ui_num, LimitX(cc.fit_width * 100, 0, 100))
end

-- �ü������(x1, y1)-(x2, y2)�����ڵĻ��棬��������Ϸ״̬��ʾ����ͼ
-- ���û�в����������������Ļ����
-- �ܹ���6��������ֱ��ǣ�
-- ��Ϸ��ʼ�����ͼ��������ս�����������Լ�����
-- ע��ú�������ֱ��ˢ����ʾ��Ļ
function Cls(x1, y1, x2, y2)
    -- ��һ������Ϊnil����ʾû�в�������ȱʡ
    if not x1 then
        x1, y1, x2, y2 = 0, 0, 0, 0
    end

    SetClip(x1, y1, x2, y2)         -- �ü�����
    -- ��Ϸ״̬ΪGAME_START�����뿪ʼ����
    if (jy.status == GAME_START) then
        FillColor(0, 0, 0, 0, 0)
        LoadPicture(cc.title_image, -1, -1)
    -- ��Ϸ״̬ΪGAME_MMAP��������ͼ����
    elseif (jy.status == GAME_MMAP) then
        DrawMMap(jy.base["��X"], jy.base["��Y"], GetMyPic())
    -- ��Ϸ״̬ΪGAME_SMAP�����볡������
    elseif (jy.status == GAME_SMAP) then
        DrawSMap()
    -- ��Ϸ״̬ΪGAME_WMAP������ս������
    elseif (jy.status == GAME_WMAP) then
        WarDrawMap(0)
    -- ��Ϸ״̬ΪGAME_DEAD������ʧ�ܻ���
    elseif (jy.status == GAME_DEAD) then
        FillColor(0, 0, 0, 0, 0)
        LoadPicture(cc.dead_image, -1, -1)
    -- �����������
    else
        FillColor(0, 0, 0, 0, 0)
    end
    SetClip(0, 0, 0, 0)             -- �ü�ȫ��
end

-- ����Menu_Exit�Ļ���
-- choice ��ǰѡ��
function DrawMenuExit(choice)
    local size = cc.font_size_30        -- ����
    local pos = {                       -- ѡ��λ��
        {468, 327},
        {468, 387},
        {468, 447}
    }
    local str = {'������Ϸ', '���س�ʼ', '�뿪��Ϸ'}

    Cls()
    for i = 1, #pos do
        local color = C_SLATEGRAY     -- ������ɫ
        local s = str[i]              -- ��ǰѡ������
        if choice == i then
            color = C_RED              -- ѡ��ʱ���ı�������ɫ
        end
        -- x��λ��
        local bx = cc.fit_width * 212 + cc.fit_width * pos[i][1] - string.len(s) / 4 * size
        -- y��λ��
        local by = cc.fit_high * 33 + cc.fit_high * pos[i][2] - size / 2
        DrawStr(bx, by, s, color, size)
    end

    ShowScreen()
end

-- ����TitleSelection��ѡ��
---@param choice number ��ǰѡ��
function DrawTitle(choice)
    -- δѡ��ʱ��ui��ͼ��ѡ��ʱ��ui��ͼ��x��λ�ã�y��λ��
    local buttons = {
        {3, 6, 560, 350},
        {4, 7, 560, 450},
        {5, 8, 560, 550}
    }
    local picid                 -- ͼ��id

    Cls()
    for i = 1, #buttons do
        -- -- ѡ����ͼ
        picid = buttons[i][1]
        if i == choice then
            picid = buttons[i][2]
        end
        
        -- UI��fileid = 5
        LoadPNG(5, picid * 2, buttons[i][3], buttons[i][4], 1)
    end
    -- ��ʾ�汾��
    DrawStr(610, 260, cc.version, C_INDIGO, cc.font_size_40)
    ShowScreen()
end

-- menu_item ��ÿ���һ���ӱ�����Ϊһ���˵���Ķ���
--           {
--          ItemName���˵��������ַ���
--          ItemFunction�� �˵����ú��������û����Ϊnil
--          Visible���Ƿ�ɼ���0���ɼ���1�ɼ�, 2��ǰѡ����
--                   ֻ����һ��Ϊ2��������ֻȡ��һ��Ϊ2�ģ�û�����һ���˵���Ϊ��ǰѡ����
--                   ��ֻ��ʾ���ֲ˵�������´�ֵ��Ч����ֵĿǰֻ�����Ƿ�˵�ȱʡ��ʾ������
--           }
-- num_item �ܲ˵������
-- num_show ��ʾ�˵���Ŀ������ܲ˵���ܶ࣬һ����ʾ���£�����Զ����ֵ
--          =0��ʾ��ʾȫ���˵���
-- (x1,y1),(x2,y2) �˵���������ϽǺ����½����꣬���x2��y2 = 0,������ַ������Ⱥ���ʾ�˵����Զ�����x2��y2
-- is_box �Ƿ���Ʊ߿�0�����ƣ�1����
--        �����ƣ�����(x1, y1, x2, y2)�ľ��λ��ư�ɫ���򣬲�ʹ�����ڱ����䰵
-- is_esc Esc���Ƿ������ã�0�������ã�1������
-- Size �˵��������С
-- color �����˵�����ɫ����ΪRGB
-- select_color ѡ�в˵�����ɫ
-- ����ֵ =0 Esc����
--        >0 ѡ�еĲ˵���(1��ʾ��һ��)
--        <0 ѡ�еĲ˵�����ú���Ҫ���˳����˵�����������˳����˵�
function ShowMenu(menu_item, num_item, num_show, x1, y1, x2, y2, is_box, is_esc, size, color, select_color)
    local w = 0                 -- ��
    local h = 0                 -- ��
    local i = 0                 --
    local num = 0               -- ����
    local new_num_item = 0      -- �²˵�����
    local new_menu = {}         -- �²˵���
    -- �Ѵ���ı����˵������Ƶ����ر����²˵���
    for i = 1, num_item do
        if (menu_item[i][3] > 0) then
            new_num_item = new_num_item + 1
            new_menu[new_num_item] = {menu_item[i][1], menu_item[i][2], menu_item[i][3], i}
        end
    end
    -- û�в˵�ֱ�ӷ���
    if (new_num_item == 0) then
        return 0
    end
    -- ��ʾһ�л�����ʾ���в˵�
    if (num_show == 0) or (new_num_item < num_show) then
        num = new_num_item
    else
        num = num_show
    end
    -- �趨�˵��Ŀ�͸�
    local max_length = 0
    if (x2 == 0) and (y2 == 0) then
        for i = 1, new_num_item do
            if (max_length < string.len(new_menu[i][1])) then
                max_length = string.len(new_menu[i][1])
            end
        end
        w = size * max_length / 2 + 2 * cc.menu_border_pixel
        h = (size + cc.row_pixel) * num + cc.menu_border_pixel
    else
        w = x2 - x1
        h = y2 - y1
    end
    -- ��ȡ��ǰ�˵�ѡ����
    local start = 1
    local current = 1
    for i = 1, new_num_item do
        if new_menu[i][3] == 2 then
            current = i
        end
    end
    -- ��û��ָ������Ĭ��Ϊ��һ��
    if (num_show ~= 0) then
        current = 1
    end

    -- ս����ݼ�ʱ���ж�
    local in_battle = false
    if (jy.status == GAME_WMAP) and (num_item >= 8) and (menu_item[8][1] == "�Զ�") then
        in_battle = true
    end
    -- ս���˵��ж�
    local in_tactics = false
    if (jy.status == GAME_WMAP) and (num_item >= 3) and (menu_item[3][1] == "�ȴ�") then
        in_tactics = true
    end
    -- �����˵��ж�
    local in_other = false
    if (jy.status == GAME_WMAP) and (num_item >= 5) and (menu_item[3][1] == "ҽ��") then
        in_other = true
    end
    -- �޸�ս���˵�bx�Ա���ʾ��ݼ�
    if (in_battle == true) or (in_tactics == true) or (in_other == true) then
        w = w + 15
    end
    local surid = lib.SaveSur(0, 0, cc.screen_w, cc.screen_h)
    local return_value = 0
    if (is_box == 1) then
        DrawBox(x1, y1, x1 + (w), y1 + (h), C_WHITE)
    end
    -- ��ݼ���ʾ��ʾ����
    local function ShowShortCutKey(str, i)
        DrawString(x1 + cc.menu_border_pixel + size * 2, y1 + cc.menu_border_pixel + (i - start) * (size + cc.row_pixel) + 2, str, LimeGreen, cc.font_small2)
    end
    -- ս����ݼ�����
    local function FightShortCutKey()
        ClsN()
        lib.LoadSur(surid, 0, 0)
        if (is_box == 1) then
            DrawBox(x1, y1, x1 + w, y1 + h, C_WHITE)
        end
    end

    while (true) do
        -- lib.GetKey()
        if (jy.restart == 1) then
            break
        end
        -- ������ʾ
        if (num ~= 0) then
            ClsN()
            lib.LoadSur(surid, 0, 0)
            if (is_box == 1) then
                DrawBox(x1, y1, x1 + (w), y1 + (h), C_WHITE)
            end
        end
        -- ���Ʋ˵�
        for i = start, start + num - 1 do
            local draw_color = color
            if (i == current) then
                draw_color = select_color
                lib.Background(x1 + cc.menu_border_pixel, y1 + cc.menu_border_pixel + (i - start) * (size + cc.row_pixel), x1 - cc.menu_border_pixel + (w), y1 + cc.menu_border_pixel + (i - start) * (size + cc.row_pixel) + size, 128, color)
            end
            DrawString(x1 + cc.menu_border_pixel, y1 + cc.menu_border_pixel + (i - start) * (size + cc.row_pixel), new_menu[i][1], draw_color, size)
            
            -- ��ݼ���ʾ��ʾ
            if (in_battle == true) then
                if (new_menu[i][1] == "����") then
                    ShowShortCutKey("A", i)
                elseif (new_menu[i][1] == "�˹�") then
                    ShowShortCutKey("G", i)
                elseif (new_menu[i][1] == "ս��") then
                    ShowShortCutKey("S", i)
                elseif (new_menu[i][1] == "����") then
                    ShowShortCutKey("H", i)
                elseif (new_menu[i][2] == War_SpecialMenu) then
                    ShowShortCutKey("T", i)
                end
            end
            if (in_tactics == true) then
                if (new_menu[i][1] == "����") then
                    ShowShortCutKey("P", i)
                elseif (new_menu[i][1] == "����") then
                    ShowShortCutKey("D", i)
                elseif (new_menu[i][1] == "�ȴ�") then
                    ShowShortCutKey("W", i)
                elseif (new_menu[i][1] == "����") then
                    ShowShortCutKey("J", i)
                elseif (new_menu[i][1] == "��Ϣ") then
                    ShowShortCutKey("R", i)
                end
            end
            if (in_other == true) then
                if (new_menu[i][1] == "�ö�") then
                    ShowShortCutKey("V", i)
                elseif (new_menu[i][1] == "�ⶾ") then
                    ShowShortCutKey("Q", i)
                elseif (new_menu[i][1] == "ҽ��") then
                    ShowShortCutKey("F", i)
                elseif (new_menu[i][1] == "��Ʒ") then
                    ShowShortCutKey("E", i)
                elseif (new_menu[i][1] == "״̬") then
                    ShowShortCutKey("Z", i)
                end
            end
        end

        ShowScreen()
        local key_press, ktype, mx, my = GetKey()
        lib.Delay(cc.frame)
        -- ESC��������Ҽ�ȡ��
        if (key_press == VK_ESCAPE) or (ktype == 4) then
            if is_esc == 1 then
                break
            end
        -- �¼�������������ѡ����һ��
        elseif (key_press == VK_DOWN) or (ktype == 7) then
            current = current + 1
            if current > (start + num - 1) then
                start = start + 1
            end
            if current > new_num_item then
                start = 1
                current = 1
            end
        -- �ϼ�������������ѡ����һ��
        elseif (key_press == VK_UP) or (ktype == 6) then
            current = current - 1
            if current < start then
                start = start - 1
            end
            if current < 1 then
                current = new_num_item
                start = current - num + 1
            end
        -- �Ҽ�ѡ����ʮ��
        elseif (key_press == VK_RIGHT) then
            current = current + 10
            if start + num - 1 < current then
                start = start + 10
            end
            if new_num_item < current + start then
                current = new_num_item
                start = current - num + 1
            end
        -- ���ѡ����ʮ��
        elseif (key_press == VK_LEFT) then
            current = current - 10
            if (current < start) then
                start = start - 10
            end
            if (current < 1) then
                start = 1
                current = 1
            elseif (current < num) then
                start = 1
            end
        -- ս����ݼ�
        -- ����
        elseif (in_battle == true) and (key_press == VK_A) and (menu_item[2][3] == 1) then
        -- 1-9ѡ����ʽ
        elseif (in_battle == true) and ((key_press >= 49) and (key_press <=57)) and (menu_item[2][3] == 1) then
            local r = War_FightMenu(nil, nil, key_press - 48)
            if r == 1 then
                return_value = -2
                break
            end
            FightShortCutKey()
        -- �˹�
        elseif (in_battle == true) and (key_press == VK_G) then
            local r = War_YunGongMenu()
            if r == 10 or r == 20 then
                return_value = r
                break
            end
            FightShortCutKey()
        -- ս��
        elseif (in_battle == true) and (key_press == VK_S) then
            local r = War_TacticsMenu()
            if (r == 1) then
                return_value = -4
                break
            elseif (r == 20) then
                return_value = 20
                break
            end
            FightShortCutKey()
        -- ����
        elseif (in_battle == true) and (key_press == VK_H) then
            local r = War_OtherMenu()
            if (r == 1) then
                return_value = -5
                break
            end
            FightShortCutKey()
        end
    end
end

-- �������ǵ�ǰ��ͼ
function GetMyPic()
    local my_pic

    -- �˴�ʱƫ�Ƽ���
    if (jy.status == Game_MMAP) and (jy.base["�˴�"] == 1) then
        if jy.my_current_pic >= 4 then
            jy.my_current_pic = 0
        end
    else
        if jy.my_current_pic > 6 then
            jy.my_current_pic = 1
        end
    end

    -- �ƶ�ʱ������ͼ
    if jy.base["�˴�"] == 0 then
        -- ����
        if jy.person[0]["�Ա�"] == 0 then
            my_pic = cc.my_start_pic_m + jy.base["�˷���"] * 7 + jy.my_current_pic
        -- Ů��
        else
            my_pic = cc.my_start_pic_f + jy.base["�˷���"] * 7 + jy.my_current_pic
        end
    -- ��
    else
        my_pic = cc.boat_start_pic + jy.base["�˷���"] * 4 + jy.my_current_pic
    end

    return my_pic
end

-- ���Ƴ�����ͼ
function DrawSMap()
    -- x�����ĵ�
    local x0 = jy.sub_scene_x + jy.base["��X1"] - 1
    -- y�����ĵ�
    local y0 = jy.sub_scene_y + jy.base["��Y1"] - 1
    -- �������
    local sceneid = jy.sub_scene
    -- ��������
    local x, y = jy.base["��X1"], jy.base["��Y1"]
    -- x������ƫ��
    local xoff = LimitX(x0, 12, 45) - jy.base["��X1"]
    -- y������ƫ��
    local yoff = LimitX(y0, 12, 45) - jy.base["��Y1"]
    -- ������ͼ
    local mypic = jy.my_pic

    if CONFIG.Zoom == 100 then
        lib.DrawSMap(sceneid, x, y, xoff, yoff, mypic)
    else
        lib.DrawSMap(sceneid, x, y, jy.sub_scene_x, jy.sub_scene_y, mypic)
    end
end

-- ����ս������
-- flag =0 ���ƻ���ս����ͼ
--      =1 ��ʾ���ƶ���·����(v1, v2)��ǰ�ƶ����꣬��ɫ������ѩ��ս����
--      =2 ��ʾ���ƶ���·����(v1, v2)��ǰ�ƶ����꣬��ɫ����
--      =3 ���е������ð�ɫ������ʾ
--      =4 ս������������v1ս������pic��v2��ͼ�����ļ����ļ�id��v3�书Ч��pic��-1��ʾû���书Ч��
-- xy ս��������
function DrawWarMap(flag, v1, v2, v3, v4, v5, ex, ey, px, py)
    local x = war.person[war.cur_id]["����X"]       -- ��ǰ����x������
    local y = war.person[war.cur_id]["����Y"]       -- ��ǰ����y������

    if not v4 then
        v4 = jy.sub_scene
    end
    if not v5 then
        v5 = -1
    end

    px = px or 0
    py = py or 0

    -- ���ƻ���ս����ͼ
    if flag == 0 then
        lib.DrawWarMap(0, x, y, 0, 0, -1, v4)
    -- ���ƿ��ƶ���·����(v1, v2)Ϊ��ǰ�ƶ�����
    elseif flag == 1 then
        -- ��ɫ������ѩ��ս����
        -- 0 ��ʷ壬2 ѩɽ��3 ���ݣ�39 �����ǣ�107 �����ǣ�111 ��ɽ����
        if v4 == 0 or v4 == 2 or v4 == 3 or v4 == 39 or v4 == 107 or v4 == 111 then
            lib.DrawWarMap(1, x, y, v1, v2, -1, v4)
        -- ��ɫ����
        else
            lib.DrawWarMap(2, x, y, v1, v2, -1, v4)
        end
    -- ������������Ч��
    elseif flag == 3 then
        lib.DrawWarMap(3, x, y, 0, 0, -1, v4)
    -- ����ս����������
    elseif flag == 4 then
        lib.DrawWarMap(4, x, y, v1, v2, v3, v4, v5, ex, ey)
    -- ���Ƶ��˶���
    elseif flag == 6 then
        lib.DrawWarMap(6, x, y, v1, v2, v3, v4, v5, ex, ey, px, py)
    -- ���Ʒ�������
    elseif flag == 7 then
        lib.DrawWarMap(7, x, y, 0, 0, v3, v4, v5, ex, ey, px, py)
    end

    -- ��ʾͷ��
    if war.show_head == 1 then
        WarShowHead()
    end

    -- ����ģ��ͷ��������Ѫ
    if CONFIG.HPDisplay == 1 then
        if war.show_hp == 1 then
            HpDisplayWhenIdle()
        end
    end
end

-- ��ʾ�����ս����Ϣ������ͷ��������������
-- id Ҫ��ʾ������id
function WarShowHead(id)
    if not id then
        id = war.cur_id
    end
    if id < 0 then
        return
    end

    local bx, by = cc.screen_w / 1360, cc.screen_h / 768            -- ��߱���
    local pid = war.person[id]["������"]                          -- ս��������
    local p = jy.person[pid]                                        -- ������
    local h = cc.font_small7                                        -- ����
    local width = cc.font_small7 * 11 - 6                           -- �����
    local height = (cc.font_small7 + cc.row_pixel) * 9 - 12         -- �����
    local x1, y1 = nil, nil                                         -- 
    local i = 1                                                     --
    local size = cc.font_small4                                     -- �����С
    local head_id = jy.person[pid]["������"]                        -- ͷ��id
    local head_w, head_h = lib.GetPNGXY(1, p["������"])                 -- ͷ���͸�
    local head_x = (width - head_w) / 2                             -- ͷ��x��
    local head_y = (cc.screen_h / 5 - head_h) / 2                   -- ͷ��y��

    -- ����ս�����UI
    -- �ҷ���ɫ
    if war.person[id]["�ҷ�"] == true then
        x1 = cc.screen_w - width - 6
        y1 = cc.screen_h - height - cc.screen_h / 6 - 6
        lib.LoadPNG(5, 28 * 2, x1, y1 + height + cc.screen_h / 30 - 253, 1)
    -- �з���ɫ
    else
        x1 = 10
        y1 = 35
        lib.LoadPNG(5, 28 * 2, x1, y1 - 35 + by * 20, 1)
    end

    -- ����ս��ͷ��UI
    -- �ҷ���ɫ
    if war.person[id]["�ҷ�"] then
        lib.LoadPNG(1, head_id * 2, cc.screen_w / 1360 * 849 + bx * 415, cc.screen_h / 768 * 421 + by * 60, 2)
    -- �з���ɫ
    else
        lib.LoadPNG(1, head_id * 2, cc.screen_w / 1360 * 99, cc.screen_h / 768 * 73 + by * 20, 2)
    end

    -- ����ս�����UI 2
    -- �ҷ���ɫ
    if war.person[id]["�ҷ�"] == true then
        x1 = cc.screen_w - width - 6
        y1 = cc.screen_h - height - cc.screen_h / 6 - 6
        lib.LoadPNG(5, 62 * 2, x1, y1 + height + cc.screen_h / 30 - 253, 1)
    -- �з���ɫ
    else
        x1 = 10
        y1 = 35
        lib.LoadPNG(5, 62 * 2, x1, y1 - 35 + by * 20, 1)
    end
end

-- ��̬Ѫ����ʾ
function HpDisplayWhenIdle()
    local x0 = war.person[war.cur_id]["����X"]
    local y0 = war.person[war.cur_id]["����Y"]

    for k = 0, war.person_num - 1 do
        local tmppid = war.person[k]["������"]
        if war.person[k]["����"] == false then
            local dx = war.person[k]["����X"] - x0
            local dy = war.person[k]["����Y"] - y0
            local rx = cc.x_scale * (dx - dy) + cc.screen_w / 2
            local ry = cc.y_scale * (dx + dy) + cc.screen_h / 2
            local hb = GetS(jy.sub_scene, dx + x0, dy + y0, 4)
            ry = ry - hb - cc.y_scale * 7
            local pid = war.person[k]["������"]
            local color = RGB(238, 44, 44)
            local hp_max = jy.person[pid]["�������ֵ"]
            local mp_max = jy.person[pid]["�������ֵ"]
            local ph_max = 100
            local current_hp = LimitX(jy.person[pid]["����"], 0, hp_max)
            local current_mp = LimitX(jy.person[pid]["����"], 0, mp_max)
            local current_ph = LimitX(jy.person[pid]["����"], 0, ph_max)

            -- �Ѿ�NPC��ʾΪ��ɫѪ��
            if war.person[k]["�ҷ�"] == true then
                color = RGB(0, 238, 0)
            end

            -- ��������
            lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 9, rx + cc.x_scale * 1.4, ry - cc.y_scale * 30 / 17, C_GRAY22)
            if hp_max > 0 then
                -- ����
                lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 9, rx - cc.x_scale * 1.4 + (current_hp / hp_max) * (2.8 * cc.x_scale), ry - cc.y_scale * 30 / 17, color)
            end
            DrawBox3(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 9, rx + cc.x_scale * 1.4, ry - cc.y_scale * 30 / 17, C_BLACK)
            
            -- ��������
            lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 11 + 0.5, rx + cc.x_scale * 1.4, ry - cc.y_scale * 30 / 21, C_GRAY22)
            if mp_max > 0 then
                -- ����
                lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 11 + 0.5, rx - cc.x_scale * 1.4 + (current_mp / mp_max) * (2.8 * cc.x_scale), ry - cc.y_scale * 30 / 21, C_BLUE)
            end
            DrawBox3(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 11 + 0.5, rx + cc.x_scale * 1.4, ry - cc.y_scale * 30 / 21, C_BLACK)

            -- ��������
            lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 13 + 1, rx + cc.x_scale * 1.4, ry - cc.y_scale * 60 / 54 + 1, C_GRAY22)
            if ph_max > 0 then
                -- ����
                lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 13 + 1, rx - cc.x_scale * 1.4 + (current_ph / ph_max) * (2.8 * cc.x_scale), ry - cc.y_scale * 60 / 54 + 1, S_Yellow)
            end
            DrawBox3(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 13 + 1, rx + cc.x_scale * 1.4, ry - cc.y_scale * 60 / 54 + 1, C_BLACK)
        end
    end
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
        -- QZXS('�˴浵���ݲ�ȫ�����ܶ�ȡ����ѡ�������浵�����¿�ʼ')
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

    LoadSMap(sFile, jy.scene_num, dFile)
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
    table_struct['����'] = {idx[1]+8, 2, 10}
    table_struct['����'] = {idx[1]+122, 0, 2}
    table_struct['����'] = {idx[0]+2, 0, 2}
    table_struct['�Ѷ�'] = {idx[0]+24, 0, 2}
    table_struct['��׼'] = {idx[0]+26, 0, 2}
    table_struct['����'] = {idx[0]+28, 0, 2}
    table_struct['����'] = {idx[0]+30, 0, 2}
    table_struct['��������'] = {idx[0]+36, 0, 2}
    table_struct['�书����'] = {idx[0]+38, 0, 2}
    table_struct['��������'] = {idx[3]+2, 2, 10}
    table_struct['��Ƭ'] = {idx[0]+40, 0, 2}
    -- ���Ǳ��
    table_struct['����1'] = {idx[0]+52, 0, 2}

    -- ��ȡR*.grp�ļ�
    local len = FileLength(cc.r_grp_filename[0])
    local data = Byte.create(len)

    -- ��ȡSMAP.grp
    local slen = FileLength(cc.s_filename[0])
    local sdata = Byte.create(slen)
    local menu = {}
    for i = 1, cc.save_num do
        local name = ''
        local sname = ''
        local nd = ''           -- �Ѷ�
        local time = ''
        local tssl = ''         -- ��������
        local zjlx = ''         -- ��������
        local zz = ''           -- ����

        if PD_ExistFile(string.format('data/save/Save_%d', i)) then
            Byte.loadfilefromzip(data, string.format('data/save/Save_%d', i), 'r.grp', 0, len)
            local pid = GetDataFromStruct(data, 0, table_struct, '����1')
            name = GetDataFromStruct(data, pid * cc.person_size, table_struct, '����')
            zz = GetDataFromStruct(data, pid * cc.person_size, table_struct, '����')
            local wy = GetDataFromStruct(data, 0, table_struct, '����')
            if wy == -1 then
                sname = '���ͼ'
            else
                sname = GetDataFromStruct(data, wy * cc.scene_size, table_struct, '��������') .. ''
            end
            local lxid1 = GetDataFromStruct(data, 0, table_struct, '��׼')
            local lxid2 = GetDataFromStruct(data, 0, table_struct, '����')
            local lxid3 = GetDataFromStruct(data, 0, table_struct, '����')
            if lxid1 > 0 then
                zjlx = '��׼'
            elseif lxid2 > 0 then
                zjlx = '����'
            elseif lxid3 > 0 then
                zjlx = '����'
            end
            local wz = GetDataFromStruct(data, 0, table_struct, '�Ѷ�')
            tssl = GetDataFromStruct(data, 0, table_struct, '��������') .. '��'
            nd = MODEXZ2[wz]
        end

        if i < 10 then
            menu[i] = {string.format('�浵%02d %-4s %-10s %-4s %4s %4s %-10s', i, zjlx, name, nd, zz, tssl, sname), nil, 1}
        else
            menu[i] = {string.format('�Զ��� %-4s %-10s %-4s %4s %4s %-10s', zjlx, name, nd, zz, tssl, sname), nil, 1}
        end
    end

    local menu_x = (cc.screen_w - 24 * cc.default_font - 2 * cc.menu_border_pixel) / 2
    local menu_y = (cc.screen_h - 9 * (cc.default_font + cc.row_pixel)) / 2
    local r = ShowMenu(menu, cc.save_num, 10, menu_x, menu_y, 0, 0, 1, 1, cc.default_font, C_WHITE, C_GOLD)
    CleanMemory()

    return r
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- orionids��
-- ����Ϊͨ�ú�����һ������£�����Ҫ�޸�

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

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

-- ��ȡ�ļ�����
function FileLength(filename)
    local inp = io.open(filename, 'rb')
    local l = inp:seek('end')
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

-- ����һ����������Ӱ�ķ����Ľǰ���
-- x1 x����ʼ����
-- y1 y����ʼ����
-- x2 x���������
-- y2 y���������
-- color �߿���ɫ
function DrawBox(x1, y1, x2, y2, color)
    local s = 4
	Background(x1 + 4, y1, x2 - 4, y1 + s, 88)
	Background(x1 + 1, y1 + 1, x1 + s, y1 + s, 88)
	Background(x2 - s, y1 + 1, x2 - 1, y1 + s, 88)
	Background(x1, y1 + 4, x2, y2 - 4, 88)
	Background(x1 + 1, y2 - s, x1 + s, y2 - 1, 88)
	Background(x2 - s, y2 - s, x2 - 1, y2 - 1, 88)
	Background(x1 + 4, y2 - s, x2 - 4, y2, 88)
    local r, g, b = GetRGB(color)
    DrawBox1(x1 + 1, y1 + 1, x2, y2, RGB(math.modf(r / 2), math.modf(g / 2), math.modf(b / 2)))
    DrawBox1(x1, y1, x2 - 1, y2 - 1, color)
end

-- ����һ�������Ľǰ���
-- x1 x����ʼ����
-- y1 y����ʼ����
-- x2 x���������
-- y2 y���������
-- color �߿���ɫ
function DrawBox1(x1, y1, x2, y2, color)
    local s = 4
	DrawRect(x1 + s, y1, x2 - s, y1, color)
	DrawRect(x1 + s, y2, x2 - s, y2, color)
	DrawRect(x1, y1 + s, x1, y2 - s, color)
	DrawRect(x2, y1 + s, x2, y2 - s, color)
	DrawRect(x1 + 2, y1 + 1, x1 + s - 1, y1 + 1, color)
	DrawRect(x1 + 1, y1 + 2, x1 + 1, y1 + s - 1, color)
	DrawRect(x2 - s + 1, y1 + 1, x2 - 2, y1 + 1, color)
	DrawRect(x2 - 1, y1 + 2, x2 - 1, y1 + s - 1, color)
	DrawRect(x1 + 2, y2 - 1, x1 + s - 1, y2 - 1, color)
	DrawRect(x1 + 1, y2 - s + 1, x1 + 1, y2 - 2, color)
	DrawRect(x2 - s + 1, y2 - 1, x2 - 2, y2 - 1, color)
	DrawRect(x2 - 1, y2 - s + 1, x2 - 1, y2 - 2, color)
end

-- ��ʾһ�����߿�����֣��߿��Ľǰ���������Ӱ
-- xy xy���꣬�����Ϊ-1��������Ļ�м���ʾ
-- str Ҫ��ʾ���ַ���
-- color ��ɫ
-- size ���ִ�С
-- boxcolor �߿���ɫ
function DrawStrBox(x, y, str, color, size, boxcolor)
    local len = #str                                            -- �ַ�����
    local w = size * len / 2 + 2 * cc.menu_border_pixel         -- �߿�Ŀ�
    local h = size + 2 * cc.menu_border_pixel                   -- �߿�ĸ�
    boxcolor = boxcolor or C_WHITE                              -- ����ָ������ɫ����Ĭ�ϰ�ɫ

    if x == -1 then
        x = (cc.screen_w - size / 2 * len - 2 * cc.menu_border_pixel) / 2
    end
    if y == -1 then
        y = (cc.screen_h - size - 2 * cc.menu_border_pixel) / 2
    end

    DrawBox(x, y, x + w - 1, y + h - 1, boxcolor)
    DrawStr(x + cc.menu_border_pixel, y + cc.menu_border_pixel, str, color, size)
end

-- ��ʾһ�����֣��б߿򣬴��������ѡ��
-- xy xy���꣬�����Ϊ-1��������Ļ�м���ʾ
-- str Ҫ��ʾ���ַ���
-- color ��ɫ
-- size ���ִ�С
-- boxcolor �߿���ɫ
function DrawStrBoxYesNo(x, y, str, color, size, boxcolor)
    if jy.restart == 1 then
        return
    end

    GetKey()
    -- �ַ�����
    local len = #str
    -- �Ի�����
    local w = size * len / 2 + 2 * cc.menu_border_pixel
    -- �Ի���߶�
    local h = size + 2 * cc.menu_border_pixel

    -- ��Ļ�м���ʾ
    if x == -1 then
        x = (cc.screen_w - size / 2 * len - 2 * cc.menu_border_pixel) / 2
    end
    if y == -1 then
        y = (cc.screen_h - size / 2 * cc.menu_border_pixel) / 2
    end

    Cls()
    -- ���ƶԻ���
    DrawStrBox(x, y, str, color, size, boxcolor)
    -- �Ƿ�˵�
    local menu = {
        {"ȷ��/��", nil, 1},
        {"ȡ��/��", nil, 2}
    }
    -- ���Ʋ˵�
    local r = ShowMenu(menu, 2, 0, x + w - 4 * size - 2 * cc.menu_border_pixel, y + h + cc.menu_border_pixel, 0, 0, 1, 0, cc.default_font, C_ORANGE, C_WHITE)
    -- �жϷ���
    if r == 1 then
        return true
    else
        return false
    end
end

-- ����Ļ�м���ʾһ�����֣��б߿򣬰�����������ݲ���ʧ
-- str Ҫ��ʾ���ַ���
-- color ��ɫ
-- size ���ִ�С
-- boxcolor �߿���ɫ
function DrawStrBoxWaitKey(str, color, size, flag, boxcolor)
    if jy.restart == 1 then
        return
    end

    GetKey()
    Cls()
    -- �ֿ�����
    if flag == nil then
        if boxcolor == nil then
            DrawStrBox(-1, -1, str, color, size)
        else
            DrawStrBox(-1, -1, str, color, size, boxcolor)
        end
    else
        DrawStrBox3(-1, -1, str, color, size, flag)
    end
    ShowScreen()
    GetKey()
end

-- ��ʾ�Ի���
-- str �Ի�����ʾ���ַ���
-- pid ������
-- flag �Ի���λ�ã�1 ���ϣ�2 ���£�3 ���ϣ�4 ���£�5 ������ͷ��6 ����
-- name �Ի�ʱ��ʾ������
function Say(str, pid, flag, name)
    if jy.restart == 1 then
        return
    end

    local bx = cc.fit_width         -- �����
    local by = cc.fit_high          -- ���߶�
    local picw = 130                -- ͷ��ͼƬ�����
    local pich = 130                -- ͷ��ͼƬ���߶�
    local talkxnum = 30             -- �������
    local talkynum = 3              -- �������
    local dx = 2                    -- Ĭ�Ͽ��
    local dy = 2                    -- Ĭ�ϸ߶�
    local boxpicw = picw + 10       -- �Ի���ͼƬ���
    local boxpich = pich + 10       -- �Ի���ͼƬ�߶�
    -- �Ի����ܿ��
    local boxtalkw = talkxnum * cc.default_font + 10
    local boxtalkh = boxpich - 27   -- �Ի����ܸ߶�
    local headid = pid              -- ����ͷ��id

    -- ������nameΪ�գ����ȡpid����İ�����
    if name == nil then
        headid = jy.person[pid]["������"]
    end
    -- ��ȡpid���������
    name = name or jy.person[pid]["����"]
    local talkborder = (pich - talkynum * cc.default_font) / (talkynum + 1) - 5

    -- ͷ��ͶԻ�������table
    local xy = {
        -- 1 ����
        {headx = dx, heady = dy, 
        talkx = dx + boxpicw + 2, talky = dy + 27, 
        namex = dx + boxpicw + 2, namey = dy, 
        showhead = 1},
        -- 2 ����
        {headx = dx + 68, heady = cc.screen_h - dy - boxpich + 40,
        talkx = dx + boxpicw + 2 + 160, talky = cc.screen_h - dy - boxpich + 27, 
        namex = dx + boxpicw - 50, namey = cc.screen_h - dy - boxpich + 100, 
        showhead = 1},
        -- 3 ����
        {headx = cc.screen_w - 1 - dx - boxpicw, heady = dy,
        talkx = cc.screen_w - 1 - dx - boxpicw - boxtalkw - 2, talky = dy + 27, 
        namex = cc.screen_w - 1 - dx - boxpicw - 96, namey = dy, 
        showhead = 1},
        -- 4 ����
        {headx = cc.screen_w - 1 - dx - boxpicw - 80, heady = cc.screen_h - dy - boxpich + 40,
        talkx = cc.screen_w - 1 - dx - boxpicw - boxtalkw - 2 - 150, talky = cc.screen_h - dy - boxpich + 27, 
        namex = cc.screen_w - 1 - dx - boxpicw - 26, namey = cc.screen_h - dy - boxpich + 100, 
        showhead = 1},
        -- 5 ���У���ͷ��
        {headx = dx, heady = dy, 
        talkx = dx + boxpicw - 43, talky = dy + 27, 
        namex = dx + boxpicw + 2, namey = dy, 
        showhead = 0},
        -- 6 ����
        {headx = cc.screen_w - 1 - dx - boxpicw, heady = cc.screen_h - dy - boxpich,
        talkx = cc.screen_w - 1 - dx - boxpicw - boxtalkw - 2, talky = cc.screen_h - dy - boxpich + 27, 
        namex = cc.screen_w - 1 - dx - boxpicw - 96, namey = cc.screen_h - dy - boxpich, 
        showhead = 1}
    }

    -- Ĭ�����ǶԻ���ͷ�������£�������������
    if pid == 0 then
        if name ~= jy.person[pid]["����"] then
            flag = 2
        else
            flag = 4
        end
    else
        flag = 2
    end

    -- ��ͷ��
    if xy[flag].showhead == 0 then
        headid = -1
    end

    GetKey()

    local function ReadStr(str)
        local T1 = {}
        local T2 = {}
        local T3 = {}
        -- �����������Բ�ͬ����ͬһ����ʾ����Ҫ΢�������꣬�Լ��ֺ�
        -- ��Ĭ�ϵ�����Ϊ��׼�����������ƣ�ϸ��������
    end

    local page, cx, cy = 0, 0, 0        -- test
    local color = C_WHITE
    local t = 0
    local font = cc.font_name

    while string.len(s) >= 1 do
        GetKey()
        if jy.restart == 1 then
            break
        end
        if page == 0 then
            Cls()
            if headid >= 0 then
                local w, h = lib.GetPNGXY(1, headid * 2)
                local x = (picw - w) / 2
                local y = (pich - h) / 2
                lib.LoadPicture(cc.say_box_file, -1, -1)
                lib.LoadPNG(90, headid * 2, xy[flag].headx + 5 + x - 76, xy[flag].heady + 5 + y - by * 220, 1)
                lib.LoadPicture(cc.say_box_file, xy[flag].namex - 35, xy[flag].namey - 10, 1)
                MyDrawString(xy[flag].namex, xy[flag].namex + 96, xy[flag].namey + 1, name, C_CYGOLD, 24)
            end
            page = 1
        end

        local strsub
        strsub = string.sub(str, 1, 1)
        if strsub == "*" then
            str = string.sub(str, 2, -1)
        else
            -- �жϵ�˫�ַ�
            if string.byte(str, 1, 1) > 127 then
                strsub = string.sub(str, 1, 2)
                str = string.sub(str, 3, -1)
            else
                strsub = string.sub(str, 1, 1)
                str = string.sub(str, 2, -1)
            end
        end

        -- ��ʼ�����߼�
        if strsub == "*" then
        elseif strsub == "��" then
            cx = 0
            cy = cy + 1
            if cy == 3 then
                cy = 0
                page = 0
            end
        elseif strsub == "��" then
            cx = 0
            cy = 0
            page = 0
        elseif strsub == "��" then
            ShowScreen()
            Delay(50)
        elseif strsub == "��" then
            ShowScreen()
            GetKey()
        elseif strsub == "��" then
            str = jy.person[pid]["����"] .. str
        elseif strsub == "��" then
            str = jy.person[0]["����"] .. str
        else
            local kz1, kz2 = ReadStr(str)
            if kz1 == 1 then
                t = kz2
            elseif kz1 == 2 then
                color = kz2
            elseif kz1 == 3 then
                font = kz2
            else
                lib.DrawStr()
            end
        end
    end
end

-- ������ɫRGB
function RGB(r, g, b)
    return r * 65536 + g * 256 + b
end

-- ������ɫ��RGB����
function GetRGB(color)
    color = color % (65536 * 256)
    local r = math.floor(color / 65536)
    color = color % 65536
    local g = math.floor(color / 256)
    local b = color % 256

    return r, g, b
end

function DrawStrBox2(x, y, str, color, size, bjcolor)
    local strarray = {}
    local num, maxlen = nil, 0
    num, strarray = Split(str, "*")

    for i = 1, num do
        local len = string.len(strarray[i])
        if maxlen < len then
            maxlen = len
        end
    end

    local w = size * maxlen / 2 + 2 * cc.menu_border_pixel
    local h = 2 * cc.menu_border_pixel + size * num

    if x == -1 then
        x = (cc.screen_w - size / 2 * maxlen - 2 * cc.menu_border_pixel) / 2
    end
    if y == -1 then
        y = (cc.screen_h - size * num - 2 * cc.menu_border_pixel) / 2
    end

    DrawBox2(x, y, x + w - 1, y + h -1, C_WHITE, bjcolor)

    for i = 1, num do
        DrawString(x + cc.menu_border_pixel, y + cc.menu_border_pixel + size * (i - 1), strarray[i], color, size)
    end
end

-- ��Ӷ���ɫת����֧��
function DrawStrBox3(x, y, str, color, size, flag)
    local len = #str - flag * 2
    local w = size * len / 2 + 2 * cc.menu_border_pixel
    local h = size + 2 * cc.menu_border_pixel
    local function StrColorSwitch(s)
        local color_switch = {{"��", C_RED}, {"��", C_GOLD}, {"��", C_BLACK}, {"��", C_WHITE}, {"��", C_ORANGE}}
        local numbers = {{"1", 10}, {"2", 15}, {"3", 15}, {"4", 15}, {"5", 15}, {"6", 15}, {"7", 15}, {"8", 15}, {"9", 15}, {"0", 15}}
        for i = 1, 5 do
            if color_switch[i][1] == s then
                return 1, color_switch[i][2]
            end
        end
        for i = 1, 10 do
            if numbers[i][1] == s then
                return 2, numbers[i][2]
            end
        end
        
        return 0
    end

    if x == -1 then
        x = (cc.screen_w - size / 2 * len - 2 * cc.menu_border_pixel) / 2
    end
    if y == -1 then
        y = (cc.screen_h - size - 2 * cc.menu_border_pixel) / 2
    end

    -- ������ɫ7 - 31
    DrawBox(x, y, x + w - 1, y + h -1, LimeGreen)
    local space = 0
    while string.len(s) >= 1 do
        local str2
        str2 = string.sub(str, 1, 1)
        -- �жϵ�˫�ַ�
        if string.byte(str, 1, 1) > 127 then
            str2 = string.sub(str, 1, 2)
            str = string.sub(str, 3, -1)
        else
            str2 = string.sub(str, 1, 1)
            str = string.sub(str, 2, -1)
        end

        local cs, cs2 = StrColorSwitch(str2)
        if cs == 1 then
            color = cs2
        elseif cs == 2 then
            DrawString(x + cc.menu_border_pixel + space, y + cc.menu_border_pixel, str, color, size)
            space  = space + cs2
        else
            DrawString(x + cc.menu_border_pixel + space, y + cc.menu_border_pixel, str, color, size)
            space = space + size
        end
    end
end

-- ��ʾ���߿������
function DrawBoxTitle(w, h, str, color)
    local s = 4
    local x1, y1, x2, y2, tx1, tx2 = nil, nil, nil, nil, nil, nil
    local fontsize = s + cc.default_font
    local len = string.len(str) * fontsize / 2

    x1 = (cc.screen_w - w) / 2
    x2 = (cc.screen_w + w) / 2
    y1 = (cc.screen_h - h) / 2
    y2 = (cc.screen_h + h) / 2
    tx1 = (cc.screen_w - len) / 2
    tx2 = (cc.screen_w + len) / 2

    lib.Background(x1, y1 + s, x1 + s, y2 - s, 128)
    lib.Background(x1 + s, y1, x2 - s, y2, 128)
    lib.Background(x2 - s, y1 + s, x2, y2 - s, 128)
    lib.Background(tx1, y1 - fontsize / 2 + s, tx2, y1, 128)
    lib.Background(tx1 + s, y1 - fontsize / 2, tx2 - s, y1 - fontsize / 2 + s, 128)
    local r, g, b = GetRGB(color)
    DrawBoxTitleSub(x1 + 1, y1 + 1, x2, y2, tx1 + 1, y1 - fontsize / 2 + 1, tx2, y1 + fontsize / 2, RGB(math.modf(r / 2), math.modf(g / 2), math.modf(b / 2)))
    DrawBoxTitleSub(x1, y1, x2 - 1, y2 - 1, tx1, y1 - fontsize / 2, tx2 - 1, y1 + fontsize / 2 - 1, color)
    DrawString(tx1 + 2 * s, y1 - (fontsize - s) / 2, str, color, cc.default_font)
end

-- ��ʾ���߿������
function DrawBoxTitleSub(x1, y1, x2, y2, tx1, ty1, tx2, ty2, color)
    local s = 4
    lib.DrawRect(x1 + s, y1, tx1, y1, color)
    lib.DrawRect(tx2, y1, x2 - s, y1, color)
    lib.DrawRect(x2 - s, y1, x2 - s, y1 + s, color)
    lib.DrawRect(x2 - s, y1 + s, x2, y1 + s, color)
    lib.DrawRect(x2, y1 + s, x2, y2 - s, color)
    lib.DrawRect(x2, y2 - s, x2 - s, y2 - s, color)
    lib.DrawRect(x2 - s, y2 - s, x2 - s, y2, color)
    lib.DrawRect(x2 - s, y2, x1 + s, y2, color)
    lib.DrawRect(x1 + s, y2, x1 + s, y2 - s, color)
    lib.DrawRect(x1 + s, y2 - s, x1, y2 - s, color)
    lib.DrawRect(x1, y2 - s, x1, y1 + s, color)
    lib.DrawRect(x1, y1 + s, x1 + s, y1 + s, color)
    lib.DrawRect(x1 + s, y1 + s, x1 + s, y1, color)
    DrawBox1(tx1, ty1, tx2, ty2, color)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- orionids��
-- ����Ϊ�ײ�C�����ṩ�ĺ���������ʹ��lua�������·�װ�����ޱ�Ҫ�������޸�

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- �л�ȫ���ʹ��ڣ�����һ�Σ��ı�һ��״̬
function FullScreen()
    lib.FullScreen()
end

-- �ü����ڣ������Ժ����жԱ���Ļ�ͼ������ֻӰ��(x1, y1)-(x2, y2)�ľ��ο��ڲ�
-- ���x1, y1, x2, y2��Ϊ0����ü�����Ϊ��������
-- ���������ڲ�ά��һ���ü������б�ShowScreen����ʹ�ô��б�������ʵ�ʵ���Ļ��ʾ
-- ÿ����һ�Σ��ü���������+1�����Ϊ20��
-- ��x1, y1, x2, y2��Ϊ0ʱ�����ȫ���ü�����
-- ������ʱ������������Ĭ��xy��Ϊ0
function SetClip(x1, y1, x2, y2)
    -- ʡ��ʱ��Ĭ��ֵ
    if not x1 then
        x1, y1, x2, y2 = 0, 0, 0, 0
    end

    lib.SetClip(x1, y1, x2, y2)
end

-- ����ɫcolor��������ľ���(x1, y1)-(x2, y2)��colorΪ32λRGB���Ӹߵ����ֽ�ΪRGB
-- ���x1, y1, x2, y2��Ϊ0���������������
-- ����ľ���(x1, y1)-(x2, y2)��Ҫ�ڲü�����SetClip��Χ�ڣ�������Ч
-- ������ʱ������������Ĭ��xy��Ϊ0����ɫΪ��ɫ
function FillColor(x1, y1, x2, y2, color)
    -- ʡ��ʱ��Ĭ��ֵ
    if not x1 then
        x1, y1, x2, y2, color = 0, 0, 0, 0, 0
    end

    -- �������
    if color < 0 then
        error('color����')
    end

    lib.FillColor(x1, y1, x2, y2, color)
end

-- ˢ����Ļ�����ǲ�����������������иı仭��Ĳ�������������ȷ��ʾ����
-- flag =0 or nil ��ʾȫ�����棬=1 ����SetClip���õľ�����ʾ�����û�о��Σ�����ʾ
function ShowScreen(flag)
    -- ʡ��ʱ��Ĭ��ֵ
    if not flag then
        flag = 0
    end

    -- �������
    if flag ~= 0 and flag ~= 1 then
        error('flag����')
    end

    lib.ShowSurface(flag)
end

-- �ѱ��滺����ʾ����Ļ
-- tΪ����ÿ�仯һ�εļ����������Ϊ��16/32λ���ݣ�һ����32�����ȱ仯
-- flag: 0 �Ӱ�������1 ��������
function ShowSlow(t, flag)
    -- �������
    if not t or not flag then
        error('����ʡ�Դ���')
    elseif t < 0 or t > 32 then
        error('t����')
    elseif flag ~= 0 and flag ~= 1 then
        error('flag����')
    end

    lib.ShowSlow(t, flag)
end

-- �ѱ������(x1, y1)-(x2, y2)�����е�����Ƚ���Ϊbright��
-- brightȡֵΪ0-255��0��ʾȫ�ڣ�255��ʾ���Ȳ���
-- ������ʱ������������Ĭ��ȫ��
function Background(x1, y1, x2, y2, bright)
    -- ʡ��ʱ��Ĭ��ֵ
    if not x1 then
        x1, y1, x2, y2, bright = 0, 0, 0, 0, 0
    end

    -- �������
    if bright < 0 or bright > 255 then
        error('bright����')
    end

    lib.Background(x1, y1, x2, y2, bright)
end

-- ���ƾ���(x1,y1)-(x2,y2)���߿�Ϊ�������أ���ɫΪcolor
-- ������ʱ������������Ĭ��xy��Ϊ0����ɫΪ��ɫ
function DrawRect(x1, y1, x2, y2, color)
    -- ʡ��ʱ��Ĭ��ֵ
    if not x1 then
        x1, y1, x2, y2, color = 0, 0, 0, 0, 0
    end

    -- �������
    if color < 0 then
        error('color����')
    end

    lib.DrawRect(x1, y1, x2, y2, color)
end

-- ��(x, y)λ��д�ַ���
-- �˺���ֱ����ʾ��Ӱ�֣���lua�в��ô�����Ӱ���ˣ�������������ַ�����ʾ�ٶ�
-- str����Ҫд���ַ���
-- color��������ɫ
-- size���������ش�С
function DrawStr(x, y, str, color, size)
    local fontname = cc.font_name
    local charset = cc.src_char_set
    local os_charset = cc.os_char_set

    -- x�����м�
    if x == -1 then
        local len = #str
        x = (cc.screen_w - size / 2 * len - 2 * cc.menu_border_pixel) / 2
    end
    -- y�����м�
    if y == -1 then
        y = (cc.screen_h - size - 2 * cc.menu_border_pixel) / 2
    end

    -- �������
    if type(str) ~= 'string' then
        error('str����')
    elseif color < 0 then
        error('color����')
    elseif size < 0 then
        error('size����')
    end

    lib.DrawStr(x, y, str, color, size, fontname, charset, os_charset)
end

-- �ڱ����������ͼ
-- (x, y) ��������
-- mypic ������ͼ���(ע��������ʵ�ʱ�ţ����ó�2)
function DrawMMap(x, y, mypic)
    lib.DrawMMap(x, y, mypic)
end

-- ��������ͼ��5���ṹ�ļ�*.002
-- ��ͼ�ļ�����Ϊearth��surface��building��buildx��buildy
-- xmax��ymaxΪ����ͼ���ߣ�Ŀǰ��Ϊ480
-- x, yΪ��������
function LoadMMap(filename1, filename2, filename3, filename4, filename5, xmax, ymax, x, y)
    lib.LoadMMap(filename1, filename2, filename3, filename4, filename5, xmax, ymax, x, y)
end

-- ��ʼ����ͼCache��Ĭ�ϼ���ԭ����256ɫ��ɫ��
-- ��ת������ǰ���ã�������б������ͼ�ļ���Ϣ
function PicInit()
    -- ��һ�ε���ʱ��Ҫ���ص�ɫ�壬�Ժ�Ͳ���Ҫ�ˣ�����strΪ���ַ�������
    lib.PicInit(cc.palette_file)
end

-- ������ͼ�ļ���Ϣ�����ڰ�ͼƬ��idx��grp�������ļ��м���
-- idxfilename / grpfilename idx / grp�ļ���
-- id ���ر�ţ�0-39�����ɼ���40�������ԭ�����У��򸲸�ԭ����
function PicLoadFile(idxfilename, grpfilename, id)
    -- �������
    if type(idxfilename) ~= 'string' then
        error('idxfilename����')
    elseif type(grpfilename) ~= 'string' then
        error('grpfilename����')
    end
    
    lib.PicLoadFile(idxfilename, grpfilename, id)
end

-- ����id��ָʾ����ͼ�ļ��б��Ϊpicid / 2��Ϊ���ּ��ݣ�������Ȼ��2������ͼ�������(x, y)����
-- ���ڰ�ͼƬ��idx��grp�������ļ��м���
-- fileidΪlib.PicLoadFile���ص��ļ��ļ��ر��
-- flag����ͬbit����ͬ���壬ȱʡ��Ϊ0
-- bit0 =0 ����ƫ��x��ƫ��y
--       =1 ������ƫ����
-- ������ͼ�ļ���˵��ԭ�е�RLE8�����ʽ������һ��ƫ�������ݣ���ʾ��ͼʱʵ�ʵ�ƫ��
-- ����֧���µ�PNG��ʽ��������ֱ�Ӳ���png�ļ������grp�ļ���û�п��Ա���ƫ�����ĵط�
-- ��˶Բ���Ҫƫ�Ƶ���ͼ������Ʒͼ������ͷ��ֱ�Ӱ�����ͼ��С���棬����ʱ���ô�λΪ1����
-- ������Ҫ����ƫ�����ط������ô�λΪ0
-- ��Ϊ�˴���png�е�ƫ���������Ǽ�������png�ļ�ƫ��������ͼ�����м�
-- �������Ҫ�����µ�png��ͼ������Ŵ�png�ļ��Ĵ�С��ʹƫ�Ƶ�պ�λ��ͼ���м�
-- bit1 =0 ��ʾ͸��
--       =1 ��Ҫ����Alpha���
-- �뱳��alpla�����ʾ, valueΪalphaֵ(0-256)
-- ע��Ŀǰ��֧��png�ļ������еĵ������ص�alphaͨ����ֻ����͸���벻͸���������ǵ�������Alpha���
-- bit2 =1 ȫ��
-- ����ͼ�Ƚ���ȫ�ڴ���Ȼ����Alpha��ֻ��bit1 = 1ʱ��������
-- bit3 =1 ȫ��
-- ����ͼ�Ƚ���ȫ�״���Ȼ����Alpha��ֻ��bit1 = 1ʱ��������
-- value����flag����alphaʱ��Ϊalphaֵ
-- ��flag = 0ʱ��flag��value������Ϊ�գ���ֻ��Ҫ����ǰ������������
-- ������������ͼ������ʱ��flag = 0
-- ��ս�����ֹ�ѡ���ƶ�����ս��λ�ú����ﱻ����ʱ����Ҫ�����Ч�������Ǿ�Ҫʹ��bit1,bit2,bit3
-- ����lua��֧�ֵ�����λ�������ֻ�ܼ��üӷ����
-- �� bit1��bit2��Ϊ1��flag = 2 + 4��bit1��bit3��Ϊ1��flag = 2 + 8
function PicLoadCache(fileid, picid, x, y, flag, value, color, w, h)
    if not flag then
        flag = 0
    end

    -- �������
    if type(picid) ~= 'number' then
        error('picid����')
    elseif flag ~=0 and flag ~= 1 and flag ~= 2 and flag ~= 6 and flag ~= 10 then
        error('flag����')
    end

    lib.PicLoadCache(fileid, picid, x, y, flag, value, color, w, h)
end

-- ��ʾͼƬ�ļ�filename��λ��x, y
-- ֧�ֵ��ļ���չ��Ϊbmp / png / jpg��
-- ��x = -1, y = -1������ʾ����Ļ�м�
-- ���������ڴ��б�����һ�μ��ص�ͼƬ�ļ����Լӿ��ظ����ص��ٶ�
-- ʡ�Բ���ʱ���ռ�õ��ڴ�
function LoadPicture(filename, x, y)
    -- ʡ��ʱ��Ĭ��ֵ
    if not filename then
        filename, x, y = '', 0, 0
    end

    -- �������
    if type(filename) ~= 'string' then
        error('filename����')
    end

    lib.LoadPicture(filename, x, y)
end

-- ����pngͼƬ·��
-- path pngͼƬ�ļ���·��
-- fileid ָ��id
-- num ����ͼƬ����
-- percent ��������Χ��0 - 100
function LoadPNGPath(path, fileid, num, percent)
    -- �������
    if type(path) ~= 'string' then
        error('path����')
    elseif fileid < 0 or fileid >= 100 then
        error('fileid����')
    elseif num < 0 then
        error('num����')
    elseif percent < 0 or percent > 100 then
        error('percent����')
    end

    lib.LoadPNGPath(path, fileid, num, percent)
end

-- ����ָ��pngͼƬ
-- fileid ָ��id����LoadPNGPath����ָ��
-- picid ָ��ͼƬ��id����2��������Ҫ�����pngͼƬ��2.png����ô����picidҪ��4��ͼƬ��һ��Ҫ������
-- (xy) XY����
-- flag 0 Խ�磬1 ��Խ�磨Ҳ������Ϊ1�Ļ���ͼƬ��������xy�������ô����������ʾ��ȫ��
function LoadPNG(fileid, picid, x, y, flag)
    -- �������
    if fileid < 0 or fileid >= 100 then
        error('fileid����')
    elseif type(picid) ~= 'number' then
        error('picid����')
    elseif flag ~=0 and flag ~= 1 then
        error('flag����')
    end

    lib.LoadPNG(fileid, picid, x, y, flag)
end

-- ���س�����ͼ����S*��D*
-- Sfilename��s*�ļ���
-- num����������
-- Dfilename��D*�ļ���
function LoadSMap(Sfilename, num, Dfilename)
    local tempfilename = cc.temp_s_filename     -- ������ʱS*���ļ���
    local x_max = cc.s_width                    -- ������
    local y_max = cc.s_height                   -- ������
    local d_num1 = cc.d_num1                    -- ÿ����������D����
    local d_num2 = cc.d_num2                    -- ÿ��D��������

    -- �������
    if type(Sfilename) ~= 'string' then
        error('Sfilename����')
    elseif num < 0 then
        error('num����')
    elseif type(Dfilename) ~= 'string' then
        error('Dfilename����')
    end
    
    lib.LoadSMap(Sfilename, tempfilename, num, x_max, y_max, Dfilename, d_num1, d_num2)
end

-- ����ս����ͼ
-- mapid ս����ͼ���
function LoadWarMap(mapid)
    local WarIDXfilename = cc.war_map_file[1]       -- ս����ͼ�ļ���idx
    local WarGRPfilename = cc.war_map_file[2]       -- ս����ͼ�ļ���grp
    -- ս����ͼ���ݲ���
    -- num ս����ͼ���ݲ�����
    --      =0 �������ݣ�=1 ������=2 ս����ս�����
    --      =3 �ƶ�ʱ��ʾ���ƶ���λ�ã�=4 ����Ч����=5 ս���˶�Ӧ����ͼ
    -- ս����ͼֻ��ȡ�������ݣ�����Ϊ����������
    -- ����̶�Ϊ12���ײ�C����������2��Ҳ���ǻᴫ24��ȥ
    -- ���ȡR*.idx�ļ�ʱ������Byte.create(6 * 4)��ֵ���
    -- ��ʱû�㶮��Ϊʲô
    local num = 12
                                        
    local x_max = cc.war_width          -- ս����ͼ��
    local y_max = cc.war_height         -- ս����ͼ��

    -- �������
    if not mapid then
        error('����ʡ�Դ���')
    elseif mapid < 0 then
        error('mapid����')
    end

    lib.LoadWarMap(WarIDXfilename, WarGRPfilename, mapid, num, x_max, y_max)
end

-- ����mpeg1��Ƶ��keyΪֹͣ���Ű����ļ��룬һ����ΪEsc��
function PlayMPEG(filename, key)
    -- �������
    if not filename or not key then
        error('����ʡ�Դ���')
    elseif type(filename) ~= 'string' then
        error('filename����')
    end

    lib.PlayMPEG(filename, key)
end

-- ��S*
-- id���������
-- xy������
-- level��������ͼ���ݲ���
--      =0 �������ݣ�=1 ������=2 ս����ս�����
--      =3 �ƶ�ʱ��ʾ���ƶ���λ�ã�=4 ����Ч����=5 ս���˶�Ӧ����ͼ
function GetS(id, x, y, level)
    if id < 0 then
        error('id����')
    elseif level < 0 or level > 5 then
        error('level����')
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
    if id < 0 then
        error('id����')
    elseif level < 0 or level > 5 then
        error('level����')
    elseif type(v) ~= 'number' then
        error('v����')
    end

    return lib.SetS(id, x, y, level)
end

-- ��D*
-- sceneid���������
-- id���ó���D*���
-- i���ڼ�������
function GetD(sceneid, id, i)
    if sceneid < 0 then
        error('sceneid����')
    elseif id < 0 then
        error('id����')
    elseif i < 0 then
        error('i����')
    end

    return lib.GetD(sceneid, id, i)
end

-- дD*
-- sceneid���������
-- id���ó���D*���
-- i���ڼ�������
-- v��д���ֵ
function SetD(sceneid, id, i, v)
    if sceneid < 0 then
        error('sceneid����')
    elseif id < 0 then
        error('id����')
    elseif i < 0 then
        error('i����')
    elseif type(v) ~= 'number' then
        error('v����')
    end

    return lib.SetD(sceneid, id, i, v)
end

-- ȡ���ͼ�ṹ��Ӧ�����ֵ
-- flag�� =0 earth, =1 surface, =2 building, =3 buildx, =4 buildy
-- ����һ��ֵ��Ϊflag��Ĵ��ͼ��������
function GetMMap(x, y, flag)
    return lib.GetMMap(x, y, flag)
end

-- ȡս����ͼ����
-- xy������
-- level��ս����ͼ���ݲ���
--      =0 �������ݣ�=1 ������=2 ս����ս�����
--      =3 �ƶ�ʱ��ʾ���ƶ���λ�ã�=4 ����Ч����=5 ս���˶�Ӧ����ͼ
-- ����һ��ֵ��Ϊ�ò��ս����ͼ��������
function GetWarMap(x, y, level)
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
    lib.SetWarMap(x, y, level, v)
end

-- ����S*��D*
function SaveSMap(Sfilename, Dfilename)
    if type(Sfilename) ~= 'string' then
        error('Sfilename����')
    elseif type(Dfilename) ~= 'string' then
        error('Dfilename����')
    end

    lib.SaveSMap(Sfilename, Dfilename)
end

-- �õ�PNGͼƬ��XYֵ
-- fileid��ָ��id����LoadPNGPath����ָ��
-- picid��picid��ָ��ͼƬ��id����2��������Ҫ�����pngͼƬ��2.png����ô����picidҪ��4��ͼƬ��һ��Ҫ������
-- ��������ֵ���ֱ�Ϊx��y����ʾ��ѯͼƬ�Ŀ�͸�
function GetPNGXY(fileid, picid)
    return lib.GetPNGXY(fileid, picid)
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
    if delay < 0 then
        error('delay����')
    elseif interval < 0 then
        error('interval����')
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
    if type(str) ~= 'string' then
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

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- ����
function instruct_0()
    Cls()
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
        DrawStrBoxWaitKey(string.format('�õ���Ʒ%sX%d', '����'..jy.thing[thingid]['����']..'�ϡ�', num), C_ORANGE, cc.default_font, 1)
    else
        DrawStrBoxWaitKey(string.format('ʧȥ��Ʒ%sX%d', '����'..jy.thing[thingid]['����']..'�ϡ�', -num), C_ORANGE, cc.default_font, 1)
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