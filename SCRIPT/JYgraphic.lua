--------------------
--
-- orionids�����½�Ϊ���������������Ϸ�����л�����Ƶĺ������ڴ�
-- 
--------------------



-- ������Ҫ��ȡ������ͼ��fileid
-- ͷ��1����Ʒ2����Ч3��������4��UI5
-- ������Ҫ�õ���C����˵��
-- lib.LoadPNGPath(path, fileid, num, percent)
-- ����pngͼƬ·��
-- path��pngͼƬ�ļ���
-- fileid�����ļ��д���id
-- num������ͼƬ����
-- percent����������Χ��0 - 100
function Gra_SetAllPNGAddress()
    -- ͷ��
    lib.LoadPNGPath(cc.head_path, 1, cc.head_num, LimitX(cc.screen_w / 1360 * 100, 0, 100))
    -- ��Ʒ
    lib.LoadPNGPath(cc.thing_path, 2, cc.thing_num, LimitX(cc.screen_w / 1360 * 100, 0, 100))
    -- ��Ч
    lib.LoadPNGPath(cc.eft_path, 3, cc.eft_num, LimitX(cc.screen_w / 1360 * 100, 0, 100))
    -- ������
    lib.LoadPNGPath(cc.body_path, 4, cc.body_num, LimitX(cc.screen_w / 1360 * 100, 0, 100))
    -- UI
    lib.LoadPNGPath(cc.ui_path, 5, cc.ui_num, LimitX(cc.screen_w / 1360 * 100, 0, 100))
end

-- ������ɫRGB
function Gra_RGB(r, g, b)
    return r * 65536 + g * 256 + b
end

-- ˢ����Ļ
-- ���ǲ�����������������иı仭��Ĳ�������������ȷ��ʾ����
-- ����������ǽ�lib.ShowSurface�������·�װʹ��
-- flag��=0 or nil ��ʾȫ������
--       =1 ����SetClip���õľ���������ʾ�����û�о��Σ�����ʾ
function Gra_ShowScreen(flag)
    if flag == nil then
        flag = 0
    end
    lib.ShowSurface(flag)
end

-- ���òü����ڣ������Ժ����жԱ���Ļ�ͼ������ֻӰ��(x1, y1)-(x2, y2)�ľ��ο��ڲ�
-- ���x1, y1, x2, y2��Ϊ0����ü�����Ϊ��������
-- ���������ڲ�ά��һ���ü������б���ShowScreen����ʹ�ô��б�������ʵ�ʵ���Ļ��ʾ
-- ÿ����һ�Σ��ü���������+1�����Ϊ20��
-- ��x1, y1, x2, y2��Ϊ0ʱ�����ȫ���ü�����
-- ������ʱ������������Ĭ�Ͼ�Ϊ0
function Gra_SetClip(x1, y1, x2, y2)
    if (x1 == nil) then
        x1, y1, x2, y2 = 0, 0, 0, 0
    end
    lib.SetClip(x1, y1, x2, y2)
end

-- ����ɫcolor��������ľ���(x1, y1)-(x2, y2)��colorΪ32λRGB��������ֽ�����ΪR, G, B
-- ���x1, y1, x2, y2��Ϊ0���������������
-- ����ľ���(x1, y1)-(x2, y2)��Ҫ�ڲü�����Gra_SetClip��Χ�ڣ�������Ч
function Gra_FillColor(x1, y1, x2, y2, color)
    if (x1 == nil) then
        x1, y1, x2, y2, color = 0, 0, 0, 0, 0
    end
    lib.FillColor(x1, y1, x2, y2, color)
end

-- ��ʾͼƬ�ļ�filename��λ��x, y
-- ֧�ֵ��ļ���չ��Ϊbmp / png / jpg��
-- ��x = -1, y = -1������ʾ����Ļ�м�
-- ���������ڴ��б�����һ�μ��ص�ͼƬ�ļ����Լӿ��ظ����ص��ٶ�
-- �ÿ��ļ������ý������ռ�õ��ڴ�
function Gra_LoadPicture(filename, x, y)
    if (filename == nil) then
        filename, x, y = "", 0, 0
    end
    lib.LoadPicture(filename, x, y)
end

-- �ڱ����������ͼ
-- (x, y)����������
-- mypic��������ͼ���(ע��������ʵ�ʱ�ţ����ó�2)
function Gra_DrawMMap(x, y, mypic)
    lib.DrawMMap(x, y, mypic)
end

-- �ü������(x1, y1)-(x2, y2)�����ڵĻ���
-- ���û�в����������������Ļ����
-- ע��ú�������ֱ��ˢ����ʾ��Ļ
function Gra_Cls(x1, y1, x2, y2)
    -- ��һ������Ϊnil����ʾû�в�������ȱʡ
    if x1 == nil then
        x1, y1, x2, y2 = 0, 0, 0, 0
    end

    Gra_SetClip(x1, y1, x2, y2)         -- �ü�����
    Gra_SetBackGround()                 -- ������Ϸ״̬��ʾ����ͼ
    Gra_SetClip(0, 0, 0, 0)             -- �ü�ȫ��
end

-- ������Ϸ״̬��ʾ����ͼ
-- �ܹ���6��������ֱ��ǣ�
-- ��Ϸ��ʼ�����ͼ��������ս�����������Լ�����
function Gra_SetBackGround()
    -- ��Ϸ״̬ΪGAME_START
    if (jy.status == GAME_START) then
        Gra_FillColor(0, 0, 0, 0, 0)
        Gra_LoadPicture(cc.title_image, -1, -1)
    -- ��Ϸ״̬ΪGAME_MMAP
    elseif (jy.status == Game_MMAP) then
        Gra_DrawMMap(jy.base["��X"], jy.base["��Y"], Gra_GetMyPic())
    -- ��Ϸ״̬ΪGAME_SMAP
    elseif (jy.status == GAME_SMAP) then
        Gra_DrawSMap()
    -- ��Ϸ״̬ΪGAME_WMAP
    elseif (jy.status == GAME_WMAP) then
        Gra_WarDrawMap(0)
    -- ��Ϸ״̬ΪGAME_DEAD
    elseif (jy.status == GAME_DEAD) then
        Gra_FillColor(0, 0, 0, 0, 0)
        Gra_LoadPicture(cc.dead_image, -1, -1)
    -- �����������
    else
        Gra_FillColor(0, 0, 0, 0, 0)
    end
end

-- menu_item������ÿ���һ���ӱ�������Ϊһ���˵���Ķ���
--           {
--          ItemName���˵��������ַ���
--          ItemFunction�� �˵����ú��������û����Ϊnil
--          Visible���Ƿ�ɼ���0���ɼ���1�ɼ�, 2��ǰѡ����
--                   ֻ����һ��Ϊ2��������ֻȡ��һ��Ϊ2�ģ�û�����һ���˵���Ϊ��ǰѡ����
--                   ��ֻ��ʾ���ֲ˵�������´�ֵ��Ч����ֵĿǰֻ�����Ƿ�˵�ȱʡ��ʾ������
--           }
-- num_item���ܲ˵������
-- num_show����ʾ�˵���Ŀ������ܲ˵���ܶ࣬һ����ʾ���£�����Զ����ֵ
--          =0��ʾ��ʾȫ���˵���
-- (x1,y1),(x2,y2)���˵���������ϽǺ����½����꣬���x2��y2 = 0,������ַ������Ⱥ���ʾ�˵����Զ�����x2��y2
-- is_box���Ƿ���Ʊ߿�0�����ƣ�1����
--        �����ƣ�����(x1, y1, x2, y2)�ľ��λ��ư�ɫ���򣬲�ʹ�����ڱ����䰵
-- is_esc��Esc���Ƿ������ã�0�������ã�1������
-- Size���˵��������С
-- color�������˵�����ɫ����ΪRGB
-- select_color��ѡ�в˵�����ɫ
-- ����ֵ��=0 Esc����
--        >0 ѡ�еĲ˵���(1��ʾ��һ��)
--        <0 ѡ�еĲ˵�����ú���Ҫ���˳����˵�����������˳����˵�
function Gra_ShowMenu(menu_item, num_item, num_show, x1, y1, x2, y2, is_box, is_esc, size, color, select_color)
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
    -- �趨�˵��Ŀ��͸�
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
        Gra_DrawBox(x1, y1, x1 + (w), y1 + (h), C_WHITE)
    end
    -- ��ݼ���ʾ��ʾ����
    local function ShowShortCutKey(str, i)
        Gra_DrawString(x1 + cc.menu_border_pixel + size * 2, y1 + cc.menu_border_pixel + (i - start) * (size + cc.row_pixel) + 2, str, LimeGreen, cc.font_small2)
    end
    -- ս����ݼ�����
    local function FightShortCutKey()
        Gra_ClsN()
        lib.LoadSur(surid, 0, 0)
        if (is_box == 1) then
            Gra_DrawBox(x1, y1, x1 + w, y1 + h, C_WHITE)
        end
    end

    while (true) do
        -- lib.GetKey()
        if (jy.restart == 1) then
            break
        end
        -- ������ʾ
        if (num ~= 0) then
            Gra_ClsN()
            lib.LoadSur(surid, 0, 0)
            if (is_box == 1) then
                Gra_DrawBox(x1, y1, x1 + (w), y1 + (h), C_WHITE)
            end
        end
        -- ���Ʋ˵�
        for i = start, start + num - 1 do
            local draw_color = color
            if (i == current) then
                draw_color = select_color
                lib.Background(x1 + cc.menu_border_pixel, y1 + cc.menu_border_pixel + (i - start) * (size + cc.row_pixel), x1 - cc.menu_border_pixel + (w), y1 + cc.menu_border_pixel + (i - start) * (size + cc.row_pixel) + size, 128, color)
            end
            Gra_DrawString(x1 + cc.menu_border_pixel, y1 + cc.menu_border_pixel + (i - start) * (size + cc.row_pixel), new_menu[i][1], draw_color, size)
            
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

        Gra_ShowScreen()
        local key_press, ktype, mx, my = WaitKey(1)
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
function Gra_GetMyPic()
    local my_pic
    -- �ڴ��ͼ���뺣��ʱ����ͼ��Ϊ�˴���ͼ
    if (jy.status == Game_MMAP) and (jy.base["�˴�"] == 1) then
        if jy.my_current_pic >= 4 then
            jy.my_current_pic = 0
        end
    else
        if jy.my_current_pic > 6 then 
            jy.my_current_pic = 1
        end
    end

    if jy.base["�˴�"] == 0 then
        if jy.base["����"] == 757 then
            my_pic = cc.my_start_pic_cg + jy.base["�˷���"] * 7 + jy.my_current_pic
        elseif jy.person[0]["�Ա�"] == 0 then
            my_pic = cc.my_start_pic_m + jy.base["�˷���"] * 7 + jy.my_current_pic
        else
            my_pic = cc.my_start_pic_f + jy.base["�˷���"] * 7 + jy.my_current_pic
        end
    else
        my_pic = cc.boat_start_pic + jy.base["�˷���"] * 4 + jy.my_current_pic
    end

    return my_pic
end

-- ���Ƴ�����ͼ
function Gra_DrawSMap()
    local x0 = jy.sub_scene_x + jy.base["��X1"] - 1         -- ��ͼ���ĵ�
    local y0 = jy.sub_scene_y + jy.base["��Y1"] - 1

    local x = LimitX(x0, 12, 45) - jy.base["��X1"]
    local y = LimitX(y0, 12, 45) - jy.base["��Y1"]

    if CONFIG.Zoom == 100 then
        lib.DrawSMap(jy.sub_scene, jy.base["��X1"], jy.base["��Y1"], x, y, jy.my_pic)
    else
        lib.DrawSMap(jy.sub_scene, jy.base["��X1"], jy.base["��Y1"], jy.sub_scene_x, jy.sub_scene_y, jy.my_pic)
    end
end

-- ����ս����ͼ
-- flag = 0�����ƻ���ս����ͼ
--      = 1����ʾ���ƶ���·����(v1, v2)��ǰ�ƶ����꣬��ɫ������ѩ��ս����
--      = 2����ʾ���ƶ���·����(v1, v2)��ǰ�ƶ����꣬��ɫ����
--      = 3�����е������ð�ɫ������ʾ
--      = 4��ս������������v1ս������pic��v2��ͼ�����ļ����ļ�id��v3�书Ч��pic��-1��ʾû���书Ч��
function Gra_WarDrawMap(flag, v1, v2, v3, v4, v5, ex, ey, px, py)
    local x = war.person[war.cur_id]["����X"]
    local y = war.person[war.cur_id]["����Y"]

    -- if jy.status == GAME_WMAP then
    --     x = war.person[war.cur_id]["����X"]
    --     y = war.person[war.cur_id]["����Y"]
    -- else
    --     x = jy.base["��X1"]
    --     y = jy.base["��Y1"]
    -- end

    if not v4 then
        v4 = jy.sub_scene
    end
    if not v5 then
        v5 = -1
    end

    px = px or 0
    py = py or 0

    if flag == 0 then
        lib.DrawWarMap(0, x, y, 0, 0, -1, v4)
    elseif flag == 1 then
        -- ��쳾ӣ�ѩɽ���м��ջ�������ǣ������ǣ���ɽ����
        if v4 == 0 or v4 == 2 or v4 == 3 or v4 == 39 or v4 == 107 or v4 == 111 then
            lib.DrawWarMap(1, x, y, v1, v2, -1, v4)
        else
            lib.DrawWarMap(2, x, y, v1, v2, -1, v4)
        end
    elseif flag == 2 then
        lib.DrawWarMap(3, x, y, 0, 0, -1, v4)
    elseif flag == 4 then
        lib.DrawWarMap(4, x, y, v1, v2, v3, v4, v5, ex, ey)
    -- ���˶���
    elseif flag == 6 then
        lib.DrawWarMap(6, x, y, v1, v2, v3, v4, v5, ex, ey, px, py)
    -- ��������
    elseif flag == 7 then
        lib.DrawWarMap(7, x, y, 0, 0, v3, v4, v5, ex, ey, px, py)
    end

    if war.show_head == 1 then
        Gra_WarShowHead()
    end

    if CONFIG.HPDisplay == 1 then
        if war.show_hp == 1 then
            Gra_HpDisplayWhenIdle()          -- ս��ʱ����ģ��ͷ����Ѫ
        end
    end
end

-- ��ʾ�����ս����Ϣ������ͷ��������������
-- id��Ҫ��ʾ������id
function Gra_WarShowHead(id)
    if not id then
        id = war.cur_id
    end
    if id < 0 then
        return
    end

    local bx, by = cc.screen_w / 1360, cc.screen_h / 768            -- ���߱���
    local pid = war.person[id]["������"]                          -- ս��������
    local p = jy.person[pid]                                        -- ������
    local h = cc.font_small7                                        -- ����
    local width = cc.font_small7 * 11 - 6                           -- �����
    local height = (cc.font_small7 + cc.row_pixel) * 9 - 12         -- �����
    local x1, y1 = nil, nil                                         -- 
    local i = 1                                                     --
    local size = cc.font_small4                                     -- �����С
    local head_id = jy.person[pid]["������"]                        -- ͷ��id
    local head_w, head_h = lib.GetPNGXY(1, p["������"])                 -- ͷ����͸�
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
function Gra_HpDisplayWhenIdle()
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
            local color = Gra_RGB(238, 44, 44)
            local hp_max = jy.person[pid]["�������ֵ"]
            local mp_max = jy.person[pid]["�������ֵ"]
            local ph_max = 100
            local current_hp = LimitX(jy.person[pid]["����"], 0, hp_max)
            local current_mp = LimitX(jy.person[pid]["����"], 0, mp_max)
            local current_ph = LimitX(jy.person[pid]["����"], 0, ph_max)

            -- �Ѿ�NPC��ʾΪ��ɫѪ��
            if war.person[k]["�ҷ�"] == true then
                color = Gra_RGB(0, 238, 0)
            end

            -- ��������
            lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 9, rx + cc.x_scale * 1.4, ry - cc.y_scale * 30 / 17, C_GRAY22)
            if hp_max > 0 then
                -- ����
                lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 9, rx - cc.x_scale * 1.4 + (current_hp / hp_max) * (2.8 * cc.x_scale), ry - cc.y_scale * 30 / 17, color)
            end
            Gra_DrawBox3(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 9, rx + cc.x_scale * 1.4, ry - cc.y_scale * 30 / 17, C_BLACK)
            
            -- ��������
            lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 11 + 0.5, rx + cc.x_scale * 1.4, ry - cc.y_scale * 30 / 21, C_GRAY22)
            if mp_max > 0 then
                -- ����
                lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 11 + 0.5, rx - cc.x_scale * 1.4 + (current_mp / mp_max) * (2.8 * cc.x_scale), ry - cc.y_scale * 30 / 21, C_BLUE)
            end
            Gra_DrawBox3(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 11 + 0.5, rx + cc.x_scale * 1.4, ry - cc.y_scale * 30 / 21, C_BLACK)

            -- ��������
            lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 13 + 1, rx + cc.x_scale * 1.4, ry - cc.y_scale * 60 / 54 + 1, C_GRAY22)
            if ph_max > 0 then
                -- ����
                lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 13 + 1, rx - cc.x_scale * 1.4 + (current_ph / ph_max) * (2.8 * cc.x_scale), ry - cc.y_scale * 60 / 54 + 1, S_Yellow)
            end
            Gra_DrawBox3(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 13 + 1, rx + cc.x_scale * 1.4, ry - cc.y_scale * 60 / 54 + 1, C_BLACK)
        end
    end
end

-- ��ʾ�ַ������ȴ��������ַ���������ʾ����Ļ�м�
function Gra_DrawStrBoxWaitKey(s, color, size, flag, boxcolor)
    if jy.restart == 1 then
        return
    end

    GetKey()
    Gra_Cls()
    
    -- �ֿ�����
    if flag == nil then
        if boxcolor == nil then
            Gra_DrawStrBox(-1, -1, s, color, size)
        else
            Gra_DrawStrBox(-1, -1, s, color, size, boxcolor)
        end
    else
        Gra_DrawStrBox3(-1, -1, s, color, size, flag)
    end
    Gra_ShowScreen()
    WaitKey()
end

-- ����һ���������İ�ɫ�����Ľǰ���
function Gra_DrawBox(x1, y1, x2, y2, color)
    local s = 4
	lib.Background(x1 + 4, y1, x2 - 4, y1 + s, 88)
	lib.Background(x1 + 1, y1 + 1, x1 + s, y1 + s, 88)
	lib.Background(x2 - s, y1 + 1, x2 - 1, y1 + s, 88)
	lib.Background(x1, y1 + 4, x2, y2 - 4, 88)
	lib.Background(x1 + 1, y2 - s, x1 + s, y2 - 1, 88)
	lib.Background(x2 - s, y2 - s, x2 - 1, y2 - 1, 88)
	lib.Background(x1 + 4, y2 - s, x2 - 4, y2, 88)
    local r, g, b = Gra_GetRGB(color)
    Gra_DrawBox1(x1 + 1, y1 + 1, x2, y2, Gra_RGB(math.modf(r / 2), math.modf(g / 2), math.modf(b / 2)))
    Gra_DrawBox1(x1, y1, x2 - 1, y2 - 1, color)
end

-- ����һ���������İ�ɫ�����Ľǰ���
function Gra_DrawBox1(x1, y1, x2, y2, color)
    local s = 4
	lib.DrawRect(x1 + s, y1, x2 - s, y1, color)
	lib.DrawRect(x1 + s, y2, x2 - s, y2, color)
	lib.DrawRect(x1, y1 + s, x1, y2 - s, color)
	lib.DrawRect(x2, y1 + s, x2, y2 - s, color)
	lib.DrawRect(x1 + 2, y1 + 1, x1 + s - 1, y1 + 1, color)
	lib.DrawRect(x1 + 1, y1 + 2, x1 + 1, y1 + s - 1, color)
	lib.DrawRect(x2 - s + 1, y1 + 1, x2 - 2, y1 + 1, color)
	lib.DrawRect(x2 - 1, y1 + 2, x2 - 1, y1 + s - 1, color)
	lib.DrawRect(x1 + 2, y2 - 1, x1 + s - 1, y2 - 1, color)
	lib.DrawRect(x1 + 1, y2 - s + 1, x1 + 1, y2 - 2, color)
	lib.DrawRect(x2 - s + 1, y2 - 1, x2 - 2, y2 - 1, color)
	lib.DrawRect(x2 - 1, y2 - s + 1, x2 - 1, y2 - 2, color)
end

-- ��ʾ������ַ���
-- (x, y)���꣬�����Ϊ-1��������Ļ�м���ʾ
function Gra_DrawStrBox(x, y, str, color, size, boxcolor)
    local len = #str                                            -- �ַ�����
    local w = size * len / 2 + 2 * cc.menu_border_pixel         -- ��ʾ��Ŀ�
    local h = size + 2 * cc.menu_border_pixel                   -- ��ʾ��ĸ�
    if (boxcolor ==  nil) then                                  -- ����ָ������ɫ����Ĭ�ϰ�ɫ
        boxcolor = C_WHITE
    end

    if (x == -1) then
        x = (cc.screen_w - size / 2 * len - 2 * cc.menu_border_pixel) / 2
    end
    if (y == -1) then
        y = (cc.screen_h - size - 2 * cc.menu_border_pixel) / 2
    end

    Gra_DrawBox(x, y, x + w - 1, y + h - 1, boxcolor)
    Gra_DrawString(x + cc.menu_border_pixel, y + cc.menu_border_pixel, str, color, size)
end

function Gra_DrawStrBox2(x, y, str, color, size, bjcolor)
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

    Gra_DrawBox2(x, y, x + w - 1, y + h -1, C_WHITE, bjcolor)

    for i = 1, num do
        Gra_DrawString(x + cc.menu_border_pixel, y + cc.menu_border_pixel + size * (i - 1), strarray[i], color, size)
    end
end

-- ���Ӷ���ɫת����֧��
function Gra_DrawStrBox3(x, y, str, color, size, flag)
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
    Gra_DrawBox(x, y, x + w - 1, y + h -1, LimeGreen)
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
            Gra_DrawString(x + cc.menu_border_pixel + space, y + cc.menu_border_pixel, str, color, size)
            space  = space + cs2
        else
            Gra_DrawString(x + cc.menu_border_pixel + space, y + cc.menu_border_pixel, str, color, size)
            space = space + size
        end
    end
end

-- ��ʾ���߿������
function Gra_DrawBoxTitle(w, h, str, color)
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
    Gra_DrawBoxTitleSub(x1 + 1, y1 + 1, x2, y2, tx1 + 1, y1 - fontsize / 2 + 1, tx2, y1 + fontsize / 2, Gra_RGB(math.modf(r / 2), math.modf(g / 2), math.modf(b / 2)))
    Gra_DrawBoxTitleSub(x1, y1, x2 - 1, y2 - 1, tx1, y1 - fontsize / 2, tx2 - 1, y1 + fontsize / 2 - 1, color)
    Gra_DrawString(tx1 + 2 * s, y1 - (fontsize - s) / 2, str, color, cc.default_font)
end

-- ��ʾ���߿������
function Gra_DrawBoxTitleSub(x1, y1, x2, y2, tx1, ty1, tx2, ty2, color)
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
    Gra_DrawBox1(tx1, ty1, tx2, ty2, color)
end

function Gra_QZXS(s)
    Gra_DrawStrBoxWaitKey(s, C_GOLD, cc.default_font)
end

-- ��ʾ��Ӱ�ַ���
function Gra_DrawString(x, y, str, color, size)
    if x == -1 then
        local len = #str
        local w = size * len / 2 + 2 * cc.menu_border_pixel
        x = (cc.screen_w - size / 2 * len - 2 * cc.menu_border_pixel) / 2
    end
    if y == -1 then
        y = (cc.screen_h - size - 2 * cc.menu_border_pixel) / 2
    end
    -- if x ~= -1 and y ~= -1 then
    lib.DrawStr(x, y, str, color, size, cc.font_name, cc.src_char_set, cc.os_char_set)
    -- else
        -- do return end
    -- end
end

-- ������ɫ��RGB����
function Gra_GetRGB(color)
    color = color % (65536 * 256)
    local r = math.floor(color / 65536)
    color = color % 65536
    local g = math.floor(color / 256)
    local b = color % 256

    return r, g, b
end

----------------------------------------
--
-- orionids�����º������������������ṩ�Ŀ�����lua�е��õĺ���
-- ע�⣬����ЩAPIû��������Ĳ����ļ�鹤�������Ҫȷ������Ĳ����Ǻ�����
-- ���������ܻ������Ҳ����ʲô������
--
----------------------------------------

-- lib.Background(x1, y1, x2, y2, Bright)
-- �ѱ����ھ���(x1, y1)-(x2, y2)�����е�����Ƚ���ΪBright��
-- BrightȡֵΪ0-256��0��ʾȫ�ڣ�256��ʾ���Ȳ���

-- lib.DrawRect(x1, y1, x2, y2, color)
-- ���ƾ���(x1,y1)-(x2,y2)���߿�Ϊ�������أ���ɫΪcolor

-- lib.DrawSMap(sceneid, x, y, xoff, yoff, mypic)
-- �泡����ͼ
-- sceneid��������ţ�x��y���������꣬xoff��yoff����������ƫ�ƣ�mypic��������ͼ*2

-- lib.DrawStr(x, y, str, color, size, fontname, charset, OScharset)
-- ��(x, y)λ��д�ַ���str
-- color��������ɫ��size���������ش�С��fontname����������
-- charset���ַ����ַ�����0 GBK, 1 BIG5
-- OScharset: 0 ��ʾ���壬1 ��ʾ����
-- �˺���ֱ����ʾ��Ӱ�֣���lua�в��ô�����Ӱ���ˣ�������������ַ�����ʾ�ٶ�

-- lib.DrawWarMap(flag, x, y, v1,v2)
-- ��ս����ͼ
-- flag = 0�����ƻ���ս����ͼ
--      = 1����ʾ���ƶ���·����(v1, v2)��ǰ�ƶ����꣬��ɫ������ѩ��ս����
--      = 2����ʾ���ƶ���·����(v1, v2)��ǰ�ƶ����꣬��ɫ����
--      = 3�����е������ð�ɫ������ʾ
--      = 4��ս������������v1ս������pic��v2��ͼ�����ļ����ļ�id��v3�书Ч��pic��-1��ʾû���书Ч��
-- xy��ս��������



-- lib.FullScreen()
-- �л�ȫ���ʹ��ڣ�����һ�Σ��ı�һ��״̬

-- lib.GetD(Sceneid, id, i)
-- ��D*����
-- sceneid��������ţ�id���ó���D��ţ�i���ڼ�������

-- lib.GetMMap(x, y, flag)
-- ȡ����ͼ�ṹ��Ӧ�����ֵ
-- flag = 0 earth, 1 surface, 2 building, 3 buildx, 4 buildy

-- lib.GetPicXY(id, picid)
-- �õ���ͼ��С��������ͼ�����ߡ�xƫ�ơ�yƫ��

-- lib.GetPNGXY(fileid, picid)
-- �õ�PNGͼƬ��XYֵ

-- lib.GetS(id, x, y, level)
-- ��S*����
-- id��������ţ�x��y�����꣬level������

-- lib.GetWarMap(x, y, level)
-- ȡս����ͼ����

-- lib.LoadMMap(filename1, filename2, filename3, filename4, filename5, xmax, ymax, x, y)
-- ��������ͼ��5���ṹ�ļ�*.002
-- ��ͼ�ļ�����Ϊearth��surface��building��buildx��buildy
-- xmax��ymaxΪ����ͼ�����ߣ�Ŀǰ��Ϊ480
-- x, yΪ��������

-- lib.LoadPicture(filename, x, y) 
-- ��ʾͼƬ�ļ�filename��λ��x, y
-- ֧�ֵ��ļ���չ��Ϊbmp / png / jpg��
-- ��x = -1, y = -1������ʾ����Ļ�м�
-- ���������ڴ��б�����һ�μ��ص�ͼƬ�ļ����Լӿ��ظ����ص��ٶ�
-- �ÿ��ļ������ý������ռ�õ��ڴ�

-- lib.LoadPNG(fileid, picid, x, y, flag)
-- ����ָ��pngͼƬ
-- fileid��ָ��id����LoadPNGPath����ָ��
-- picid��ָ��ͼƬ��id����2��������Ҫ�����pngͼƬ��2.png����ô����picidҪ��4��ͼƬ��һ��Ҫ������
-- x��y��XY����
-- flag��0 Խ�磬1 ��Խ�磨Ҳ������Ϊ1�Ļ���ͼƬ��������xy�������ô����������ʾ��ȫ��

-- lib.LoadSMap(Sfilename, tempfilename, num, x_max, y_max, Dfilename, d_num1, d_num2)
-- ���س�����ͼ����S*��D*
-- Sfilename��s*�ļ���
-- tempfilename��������ʱS*���ļ���
-- num����������
-- x_max��y_max����������
-- Dfilename��D*�ļ���
-- d_num1��ÿ����������D���ݣ�ӦΪ200
-- d_num1��ÿ��D�������ݣ�ӦΪ11

-- lib.LoadWarMap(WarIDXfilename, WarGRPfilename, mapid, num, x_max, y_max)
-- ����ս����ͼ
-- WarIDXfilename / WarGrpfilename: ս����ͼ�ļ���idx / grp
-- mapid��ս����ͼ���
-- num��ս����ͼ���ݲ�����
--      =0���������ݣ�=1��������=2��ս����ս�����
--      =3���ƶ�ʱ��ʾ���ƶ���λ�ã�=4������Ч����=5��ս���˶�Ӧ����ͼ
-- x_max��x_max����ͼ��С
-- ս����ͼֻ��ȡ�������ݣ�����Ϊ����������

-- lib.PicInit(str)
-- ��ʼ����ͼCache��strΪ��ɫ���ļ�
-- ��ת������ǰ���ã�������б������ͼ�ļ���Ϣ
-- ��һ�ε���ʱ��Ҫ���ص�ɫ�壬�Ժ�Ͳ���Ҫ�ˣ�����strΪ���ַ�������

-- lib.PicLoadCache(id, picid, x, y, flag, value)
-- ����id��ָʾ����ͼ�ļ��б��Ϊpicid / 2��Ϊ���ּ��ݣ�������Ȼ��2������ͼ�������(x, y)����
-- idΪlib.PicLoadFile���ص��ļ��ļ��ر��
-- flag����ͬbit������ͬ���壬ȱʡ��Ϊ0
-- bit0 = 0������ƫ��x��ƫ��y
--      = 1��������ƫ����
-- ������ͼ�ļ���˵��ԭ�е�RLE8�����ʽ������һ��ƫ�������ݣ���ʾ��ͼʱʵ�ʵ�ƫ��
-- ����֧���µ�PNG��ʽ��������ֱ�Ӳ���png�ļ������grp�ļ���û�п��Ա���ƫ�����ĵط�
-- ��˶Բ���Ҫƫ�Ƶ���ͼ������Ʒͼ������ͷ��ֱ�Ӱ�����ͼ��С���棬����ʱ���ô�λΪ1����
-- ������Ҫ����ƫ�����ط������ô�λΪ0
-- ��Ϊ�˴���png�е�ƫ���������Ǽ�������png�ļ�ƫ��������ͼ�����м�
-- �������Ҫ�����µ�png��ͼ������Ŵ�png�ļ��Ĵ�С��ʹƫ�Ƶ�պ�λ��ͼ���м�
-- bit1 = 0����ʾ͸��
--      = 1����Ҫ����Alpha���
-- �뱳��alpla�����ʾ, valueΪalphaֵ(0-256)
-- ע��Ŀǰ��֧��png�ļ������еĵ������ص�alphaͨ����ֻ����͸���벻͸���������ǵ�������Alpha���
-- bit2 = 1��ȫ��
-- ����ͼ�Ƚ���ȫ�ڴ�����Ȼ����Alpha��ֻ��bit1 = 1ʱ��������
-- bit3 = 1��ȫ��
-- ����ͼ�Ƚ���ȫ�״�����Ȼ����Alpha��ֻ��bit1 = 1ʱ��������
-- value����flag����alphaʱ��Ϊalphaֵ
-- ��flag = 0ʱ��flag��value������Ϊ�գ���ֻ��Ҫ����ǰ������������
-- ������������ͼ������ʱ��flag = 0
-- ��ս�����ֹ�ѡ���ƶ�����ս��λ�ú����ﱻ����ʱ����Ҫ�����Ч�������Ǿ�Ҫʹ��bit1,bit2,bit3
-- ����lua��֧�ֵ�����λ�������ֻ�ܼ��üӷ����
-- �磺bit1��bit2��Ϊ1��flag = 2 + 4��bit1��bit3��Ϊ1��flag = 2 + 8

-- lib.PicLoadFile(idxfilename, grpfilename, id)
-- ������ͼ�ļ���Ϣ
-- idxfilename / grpfilename��idx / grp�ļ���
-- id�����ر�ţ�0-39�����ɼ���40�������ԭ�����У��򸲸�ԭ����

-- lib.PlayMPEG(filename, key)
-- ����mpeg1��Ƶ��keyΪֹͣ���Ű����ļ��룬һ����ΪEsc��

-- lib.SaveSMap(Sfilename, Dfilename)
-- ����S*��D*



-- lib.SetD(Sceneid, id, i, v)
-- дD*����v

-- lib.SetS(id, x, y, level, v)
-- д��������v

-- lib.ShowSlow(t, flag)
-- �ѱ��滺����ʾ����Ļ
-- tΪ����ÿ�仯һ�εļ����������Ϊ��16/32λ���ݣ�һ����32�����ȱ仯
-- flag: 0�Ӱ�������1��������

-- lib.SetWarMap(x, y, level, v)
-- ��ս����ͼ����