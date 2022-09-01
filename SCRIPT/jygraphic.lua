--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- orionids：以下皆为画面输出函数，游戏内所有画面绘制的函数皆在此
-- 函数采用大驼峰式命名方法，变量使用小下划线命名方法，常量使用大下划线命名方法

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



-- 设置需要读取所有贴图的fileid
-- 1 头像，2 物品，3 特效，4 半身像，5 UI
function Gra_SetAllPNGAddress()
    -- 头像
    Gra_LoadPNGPath(cc.head_path, 1, cc.head_num, LimitX(cc.fit_width * 100, 0, 100))
    -- 物品
    Gra_LoadPNGPath(cc.thing_path, 2, cc.thing_num, LimitX(cc.fit_width * 100, 0, 100))
    -- 特效
    Gra_LoadPNGPath(cc.eft_path, 3, cc.eft_num, LimitX(cc.fit_width * 100, 0, 100))
    -- 半身像
    Gra_LoadPNGPath(cc.body_path, 4, cc.body_num, LimitX(cc.fit_width * 100, 0, 100))
    -- UI
    Gra_LoadPNGPath(cc.ui_path, 5, cc.ui_num, LimitX(cc.fit_width * 100, 0, 100))
end

-- 裁剪并清除(x1, y1)-(x2, y2)矩形内的画面，并根据游戏状态显示背景图
-- 如果没有参数，则清除整个屏幕表面
-- 总共有6种情况，分别是：
-- 游戏开始、大地图、场景、战斗、死亡，以及其他
-- 注意该函数并不直接刷新显示屏幕
function Gra_Cls(x1, y1, x2, y2)
    -- 第一个参数为nil，表示没有参数，用缺省
    if not x1 then
        x1, y1, x2, y2 = 0, 0, 0, 0
    end

    Gra_SetClip(x1, y1, x2, y2)         -- 裁剪窗口
    -- 游戏状态为GAME_START，载入开始画面
    if (jy.status == GAME_START) then
        Gra_FillColor(0, 0, 0, 0, 0)
        Gra_LoadPicture(cc.title_image, -1, -1)
    -- 游戏状态为GAME_MMAP，载入大地图背景
    elseif (jy.status == GAME_MMAP) then
        Gra_DrawMMap(jy.base["人X"], jy.base["人Y"], Gra_GetMyPic())
    -- 游戏状态为GAME_SMAP，载入场景背景
    elseif (jy.status == GAME_SMAP) then
        Gra_DrawSMap()
    -- 游戏状态为GAME_WMAP，载入战斗背景
    elseif (jy.status == GAME_WMAP) then
        Gra_WarDrawMap(0)
    -- 游戏状态为GAME_DEAD，载入失败画面
    elseif (jy.status == GAME_DEAD) then
        Gra_FillColor(0, 0, 0, 0, 0)
        Gra_LoadPicture(cc.dead_image, -1, -1)
    -- 其他情况黑屏
    else
        Gra_FillColor(0, 0, 0, 0, 0)
    end
    Gra_SetClip(0, 0, 0, 0)             -- 裁剪全屏
end

-- 绘制Menu_Exit的画面
-- choice 当前选项
function Gra_DrawMenuExit(choice)
    local size = cc.font_size_30        -- 字体
    local pos = {                       -- 选项位置
        {468, 327},
        {468, 387},
        {468, 447}
    }
    local str = {'继续游戏', '返回初始', '离开游戏'}

    Gra_Cls()
    for i = 1, #pos do
        local color = C_SLATEGRAY     -- 字体颜色
        local s = str[i]              -- 当前选项文字
        if choice == i then
            color = C_RED              -- 选中时，改变字体颜色
        end
        -- x轴位置
        local bx = cc.fit_width * 212 + cc.fit_width * pos[i][1] - string.len(s) / 4 * size
        -- y轴位置
        local by = cc.fit_high * 33 + cc.fit_high * pos[i][2] - size / 2
        Gra_DrawStr(bx, by, s, color, size)
    end

    Gra_ShowScreen()
end

-- 绘制TitleSelection的选项
---@param choice number 当前选项
function Gra_DrawTitle(choice)
    -- 未选中时的ui贴图，选中时的ui贴图，x轴位置，y轴位置
    local buttons = {
        {3, 6, 560, 350},
        {4, 7, 560, 450},
        {5, 8, 560, 550}
    }
    local picid                 -- 图像id

    Gra_Cls()
    for i = 1, #buttons do
        -- -- 选项贴图
        picid = buttons[i][1]
        if i == choice then
            picid = buttons[i][2]
        end
        
        -- UI的fileid = 5
        Gra_LoadPNG(5, picid * 2, buttons[i][3], buttons[i][4], 1)
    end
    -- 显示版本号
    Gra_DrawStr(610, 260, cc.version, C_INDIGO, cc.font_size_40)
    Gra_ShowScreen()
end

-- menu_item 表，每项保存一个子表，内容为一个菜单项的定义
--           {
--          ItemName：菜单项名称字符串
--          ItemFunction： 菜单调用函数，如果没有则为nil
--          Visible：是否可见，0不可见，1可见, 2当前选择项
--                   只能有一个为2，多了则只取第一个为2的，没有则第一个菜单项为当前选择项
--                   在只显示部分菜单的情况下此值无效，此值目前只用于是否菜单缺省显示否的情况
--           }
-- num_item 总菜单项个数
-- num_show 显示菜单项目，如果总菜单项很多，一屏显示不下，则可以定义此值
--          =0表示显示全部菜单项
-- (x1,y1),(x2,y2) 菜单区域的左上角和右下角坐标，如果x2、y2 = 0,则根据字符串长度和显示菜单项自动计算x2、y2
-- is_box 是否绘制边框，0不绘制，1绘制
--        若绘制，则按照(x1, y1, x2, y2)的矩形绘制白色方框，并使方框内背景变暗
-- is_esc Esc键是否起作用，0不起作用，1起作用
-- Size 菜单项字体大小
-- color 正常菜单项颜色，均为RGB
-- select_color 选中菜单项颜色
-- 返回值 =0 Esc返回
--        >0 选中的菜单项(1表示第一项)
--        <0 选中的菜单项，调用函数要求退出父菜单，这个用于退出多层菜单
function Gra_ShowMenu(menu_item, num_item, num_show, x1, y1, x2, y2, is_box, is_esc, size, color, select_color)
    local w = 0                 -- 宽
    local h = 0                 -- 高
    local i = 0                 --
    local num = 0               -- 数量
    local new_num_item = 0      -- 新菜单数量
    local new_menu = {}         -- 新菜单表
    -- 把传入的变量菜单，复制到本地变量新菜单里
    for i = 1, num_item do
        if (menu_item[i][3] > 0) then
            new_num_item = new_num_item + 1
            new_menu[new_num_item] = {menu_item[i][1], menu_item[i][2], menu_item[i][3], i}
        end
    end
    -- 没有菜单直接返回
    if (new_num_item == 0) then
        return 0
    end
    -- 显示一行还是显示多行菜单
    if (num_show == 0) or (new_num_item < num_show) then
        num = new_num_item
    else
        num = num_show
    end
    -- 设定菜单的宽和高
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
    -- 获取当前菜单选择项
    local start = 1
    local current = 1
    for i = 1, new_num_item do
        if new_menu[i][3] == 2 then
            current = i
        end
    end
    -- 若没有指定，则默认为第一项
    if (num_show ~= 0) then
        current = 1
    end

    -- 战斗快捷键时机判定
    local in_battle = false
    if (jy.status == GAME_WMAP) and (num_item >= 8) and (menu_item[8][1] == "自动") then
        in_battle = true
    end
    -- 战术菜单判定
    local in_tactics = false
    if (jy.status == GAME_WMAP) and (num_item >= 3) and (menu_item[3][1] == "等待") then
        in_tactics = true
    end
    -- 其它菜单判定
    local in_other = false
    if (jy.status == GAME_WMAP) and (num_item >= 5) and (menu_item[3][1] == "医疗") then
        in_other = true
    end
    -- 修改战斗菜单bx以便显示快捷键
    if (in_battle == true) or (in_tactics == true) or (in_other == true) then
        w = w + 15
    end
    local surid = lib.SaveSur(0, 0, cc.screen_w, cc.screen_h)
    local return_value = 0
    if (is_box == 1) then
        Gra_DrawBox(x1, y1, x1 + (w), y1 + (h), C_WHITE)
    end
    -- 快捷键提示显示函数
    local function ShowShortCutKey(str, i)
        Gra_DrawString(x1 + cc.menu_border_pixel + size * 2, y1 + cc.menu_border_pixel + (i - start) * (size + cc.row_pixel) + 2, str, LimeGreen, cc.font_small2)
    end
    -- 战斗快捷键函数
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
        -- 多行显示
        if (num ~= 0) then
            Gra_ClsN()
            lib.LoadSur(surid, 0, 0)
            if (is_box == 1) then
                Gra_DrawBox(x1, y1, x1 + (w), y1 + (h), C_WHITE)
            end
        end
        -- 绘制菜单
        for i = start, start + num - 1 do
            local draw_color = color
            if (i == current) then
                draw_color = select_color
                lib.Background(x1 + cc.menu_border_pixel, y1 + cc.menu_border_pixel + (i - start) * (size + cc.row_pixel), x1 - cc.menu_border_pixel + (w), y1 + cc.menu_border_pixel + (i - start) * (size + cc.row_pixel) + size, 128, color)
            end
            Gra_DrawString(x1 + cc.menu_border_pixel, y1 + cc.menu_border_pixel + (i - start) * (size + cc.row_pixel), new_menu[i][1], draw_color, size)
            
            -- 快捷键提示显示
            if (in_battle == true) then
                if (new_menu[i][1] == "攻击") then
                    ShowShortCutKey("A", i)
                elseif (new_menu[i][1] == "运功") then
                    ShowShortCutKey("G", i)
                elseif (new_menu[i][1] == "战术") then
                    ShowShortCutKey("S", i)
                elseif (new_menu[i][1] == "其他") then
                    ShowShortCutKey("H", i)
                elseif (new_menu[i][2] == War_SpecialMenu) then
                    ShowShortCutKey("T", i)
                end
            end
            if (in_tactics == true) then
                if (new_menu[i][1] == "蓄力") then
                    ShowShortCutKey("P", i)
                elseif (new_menu[i][1] == "防御") then
                    ShowShortCutKey("D", i)
                elseif (new_menu[i][1] == "等待") then
                    ShowShortCutKey("W", i)
                elseif (new_menu[i][1] == "集中") then
                    ShowShortCutKey("J", i)
                elseif (new_menu[i][1] == "休息") then
                    ShowShortCutKey("R", i)
                end
            end
            if (in_other == true) then
                if (new_menu[i][1] == "用毒") then
                    ShowShortCutKey("V", i)
                elseif (new_menu[i][1] == "解毒") then
                    ShowShortCutKey("Q", i)
                elseif (new_menu[i][1] == "医疗") then
                    ShowShortCutKey("F", i)
                elseif (new_menu[i][1] == "物品") then
                    ShowShortCutKey("E", i)
                elseif (new_menu[i][1] == "状态") then
                    ShowShortCutKey("Z", i)
                end
            end
        end

        Gra_ShowScreen()
        local key_press, ktype, mx, my = GetKey()
        lib.Delay(cc.frame)
        -- ESC或者鼠标右键取消
        if (key_press == VK_ESCAPE) or (ktype == 4) then
            if is_esc == 1 then
                break
            end
        -- 下键或者鼠标滚轮下选择下一项
        elseif (key_press == VK_DOWN) or (ktype == 7) then
            current = current + 1
            if current > (start + num - 1) then
                start = start + 1
            end
            if current > new_num_item then
                start = 1
                current = 1
            end
        -- 上键或者鼠标滚轮上选择上一项
        elseif (key_press == VK_UP) or (ktype == 6) then
            current = current - 1
            if current < start then
                start = start - 1
            end
            if current < 1 then
                current = new_num_item
                start = current - num + 1
            end
        -- 右键选择下十项
        elseif (key_press == VK_RIGHT) then
            current = current + 10
            if start + num - 1 < current then
                start = start + 10
            end
            if new_num_item < current + start then
                current = new_num_item
                start = current - num + 1
            end
        -- 左键选择上十项
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
        -- 战斗快捷键
        -- 攻击
        elseif (in_battle == true) and (key_press == VK_A) and (menu_item[2][3] == 1) then
        -- 1-9选择招式
        elseif (in_battle == true) and ((key_press >= 49) and (key_press <=57)) and (menu_item[2][3] == 1) then
            local r = War_FightMenu(nil, nil, key_press - 48)
            if r == 1 then
                return_value = -2
                break
            end
            FightShortCutKey()
        -- 运功
        elseif (in_battle == true) and (key_press == VK_G) then
            local r = War_YunGongMenu()
            if r == 10 or r == 20 then
                return_value = r
                break
            end
            FightShortCutKey()
        -- 战术
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
        -- 其他
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

-- 计算主角当前贴图
function Gra_GetMyPic()
    local my_pic

    -- 乘船时偏移计算
    if (jy.status == Game_MMAP) and (jy.base["乘船"] == 1) then
        if jy.my_current_pic >= 4 then
            jy.my_current_pic = 0
        end
    else
        if jy.my_current_pic > 6 then
            jy.my_current_pic = 1
        end
    end

    -- 移动时主角贴图
    if jy.base["乘船"] == 0 then
        -- 男性
        if jy.person[0]["性别"] == 0 then
            my_pic = cc.my_start_pic_m + jy.base["人方向"] * 7 + jy.my_current_pic
        -- 女性
        else
            my_pic = cc.my_start_pic_f + jy.base["人方向"] * 7 + jy.my_current_pic
        end
    -- 船
    else
        my_pic = cc.boat_start_pic + jy.base["人方向"] * 4 + jy.my_current_pic
    end

    return my_pic
end

-- 在表面绘制主地图
-- (x, y) 主角坐标
-- mypic 主角贴图编号(注意这里是实际编号，不用除2)
function Gra_DrawMMap(x, y, mypic)
    local err = -1      -- 错误码
    if not x or not y or not mypic then
        err = 1         -- 参数省略错误
    elseif x < -1 or y < -1 then
        err = 2         -- xy错误
    elseif mypic < 0 then
        err = 3         -- mypic错误
    end

    -- 错误时返回错误码
    if err > 0 then
        Debug("Gra_DrawMMap Error, error code: " .. err)
        return
    end

    lib.DrawMMap(x, y, mypic)
end

-- 加载主地图的5个结构文件*.002
-- 贴图文件依次为earth、surface、building、buildx、buildy
-- xmax、ymax为主地图宽、高，目前均为480
-- x, y为主角坐标
function Gra_LoadMMap(filename1, filename2, filename3, filename4, filename5, xmax, ymax, x, y)
    local err = -1      -- 错误码
    if not filename1 or not filename2 or not filename3 or not filename4 or not filename5 or not xmax or not ymax or not x or not y then
        err = 1         -- 参数省略错误
    end

    -- 错误时返回错误码
    if err > 0 then
        Debug("Gra_LoadMMap Error, error code: " .. err)
        return
    end

    lib.LoadMMap(filename1, filename2, filename3, filename4, filename5, xmax, ymax, x, y)
end

-- 绘制场景地图
function Gra_DrawSMap()
    -- x轴中心点
    local x0 = jy.sub_scene_x + jy.base["人X1"] - 1
    -- y轴中心点
    local y0 = jy.sub_scene_y + jy.base["人Y1"] - 1
    -- 场景编号
    local sceneid = jy.sub_scene
    -- 主角坐标
    local x, y = jy.base["人X1"], jy.base["人Y1"]
    -- x轴中心偏移
    local xoff = LimitX(x0, 12, 45) - jy.base["人X1"]
    -- y轴中心偏移
    local yoff = LimitX(y0, 12, 45) - jy.base["人Y1"]
    -- 主角贴图
    local mypic = jy.my_pic

    if CONFIG.Zoom == 100 then
        lib.DrawSMap(sceneid, x, y, xoff, yoff, mypic)
    else
        lib.DrawSMap(sceneid, x, y, jy.sub_scene_x, jy.sub_scene_y, mypic)
    end
end

-- 绘制战斗画面
-- flag =0 绘制基本战斗地图
--      =1 显示可移动的路径，(v1, v2)当前移动坐标，白色背景（雪地战斗）
--      =2 显示可移动的路径，(v1, v2)当前移动坐标，黑色背景
--      =3 命中的人物用白色轮廓显示
--      =4 战斗动作动画，v1战斗人物pic，v2贴图所属的加载文件id，v3武功效果pic，-1表示没有武功效果
-- xy 战斗人坐标
function Gra_DrawWarMap(flag, v1, v2, v3, v4, v5, ex, ey, px, py)
    local x = war.person[war.cur_id]["坐标X"]       -- 当前人物x轴坐标
    local y = war.person[war.cur_id]["坐标Y"]       -- 当前人物y轴坐标

    if not v4 then
        v4 = jy.sub_scene
    end
    if not v5 then
        v5 = -1
    end

    px = px or 0
    py = py or 0

    -- 绘制基本战斗地图
    if flag == 0 then
        lib.DrawWarMap(0, x, y, 0, 0, -1, v4)
    -- 绘制可移动的路径，(v1, v2)为当前移动坐标
    elseif flag == 1 then
        -- 白色背景（雪地战斗）
        -- 0 玉笔峰，2 雪山，3 沧州，39 凌霄城，107 北京城，111 华山绝顶
        if v4 == 0 or v4 == 2 or v4 == 3 or v4 == 39 or v4 == 107 or v4 == 111 then
            lib.DrawWarMap(1, x, y, v1, v2, -1, v4)
        -- 黑色背景
        else
            lib.DrawWarMap(2, x, y, v1, v2, -1, v4)
        end
    -- 绘制命中人物效果
    elseif flag == 3 then
        lib.DrawWarMap(3, x, y, 0, 0, -1, v4)
    -- 绘制战斗动作动画
    elseif flag == 4 then
        lib.DrawWarMap(4, x, y, v1, v2, v3, v4, v5, ex, ey)
    -- 绘制单人动画
    elseif flag == 6 then
        lib.DrawWarMap(6, x, y, v1, v2, v3, v4, v5, ex, ey, px, py)
    -- 绘制防御动画
    elseif flag == 7 then
        lib.DrawWarMap(7, x, y, 0, 0, v3, v4, v5, ex, ey, px, py)
    end

    -- 显示头像
    if war.show_head == 1 then
        Gra_WarShowHead()
    end

    -- 人物模型头上永久显血
    if CONFIG.HPDisplay == 1 then
        if war.show_hp == 1 then
            Gra_HpDisplayWhenIdle()
        end
    end
end

-- 显示人物的战斗信息，包括头像、生命、内力等
-- id 要显示的人物id
function Gra_WarShowHead(id)
    if not id then
        id = war.cur_id
    end
    if id < 0 then
        return
    end

    local bx, by = cc.screen_w / 1360, cc.screen_h / 768            -- 宽高比例
    local pid = war.person[id]["人物编号"]                          -- 战斗人物编号
    local p = jy.person[pid]                                        -- 人物编号
    local h = cc.font_small7                                        -- 字体
    local width = cc.font_small7 * 11 - 6                           -- 字体宽
    local height = (cc.font_small7 + cc.row_pixel) * 9 - 12         -- 字体高
    local x1, y1 = nil, nil                                         -- 
    local i = 1                                                     --
    local size = cc.font_small4                                     -- 字体大小
    local head_id = jy.person[pid]["半身像"]                        -- 头像id
    local head_w, head_h = lib.GetPNGXY(1, p["半身像"])                 -- 头像宽和高
    local head_x = (width - head_w) / 2                             -- 头像x轴
    local head_y = (cc.screen_h / 5 - head_h) / 2                   -- 头像y轴

    -- 人物战斗面板UI
    -- 我方角色
    if war.person[id]["我方"] == true then
        x1 = cc.screen_w - width - 6
        y1 = cc.screen_h - height - cc.screen_h / 6 - 6
        lib.LoadPNG(5, 28 * 2, x1, y1 + height + cc.screen_h / 30 - 253, 1)
    -- 敌方角色
    else
        x1 = 10
        y1 = 35
        lib.LoadPNG(5, 28 * 2, x1, y1 - 35 + by * 20, 1)
    end

    -- 人物战斗头像UI
    -- 我方角色
    if war.person[id]["我方"] then
        lib.LoadPNG(1, head_id * 2, cc.screen_w / 1360 * 849 + bx * 415, cc.screen_h / 768 * 421 + by * 60, 2)
    -- 敌方角色
    else
        lib.LoadPNG(1, head_id * 2, cc.screen_w / 1360 * 99, cc.screen_h / 768 * 73 + by * 20, 2)
    end

    -- 人物战斗面板UI 2
    -- 我方角色
    if war.person[id]["我方"] == true then
        x1 = cc.screen_w - width - 6
        y1 = cc.screen_h - height - cc.screen_h / 6 - 6
        lib.LoadPNG(5, 62 * 2, x1, y1 + height + cc.screen_h / 30 - 253, 1)
    -- 敌方角色
    else
        x1 = 10
        y1 = 35
        lib.LoadPNG(5, 62 * 2, x1, y1 - 35 + by * 20, 1)
    end
end

-- 常态血条显示
function Gra_HpDisplayWhenIdle()
    local x0 = war.person[war.cur_id]["坐标X"]
    local y0 = war.person[war.cur_id]["坐标Y"]

    for k = 0, war.person_num - 1 do
        local tmppid = war.person[k]["人物编号"]
        if war.person[k]["死亡"] == false then
            local dx = war.person[k]["坐标X"] - x0
            local dy = war.person[k]["坐标Y"] - y0
            local rx = cc.x_scale * (dx - dy) + cc.screen_w / 2
            local ry = cc.y_scale * (dx + dy) + cc.screen_h / 2
            local hb = GetS(jy.sub_scene, dx + x0, dy + y0, 4)
            ry = ry - hb - cc.y_scale * 7
            local pid = war.person[k]["人物编号"]
            local color = Gra_RGB(238, 44, 44)
            local hp_max = jy.person[pid]["生命最大值"]
            local mp_max = jy.person[pid]["内力最大值"]
            local ph_max = 100
            local current_hp = LimitX(jy.person[pid]["生命"], 0, hp_max)
            local current_mp = LimitX(jy.person[pid]["内力"], 0, mp_max)
            local current_ph = LimitX(jy.person[pid]["体力"], 0, ph_max)

            -- 友军NPC显示为绿色血条
            if war.person[k]["我方"] == true then
                color = Gra_RGB(0, 238, 0)
            end

            -- 生命背景
            lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 9, rx + cc.x_scale * 1.4, ry - cc.y_scale * 30 / 17, C_GRAY22)
            if hp_max > 0 then
                -- 生命
                lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 9, rx - cc.x_scale * 1.4 + (current_hp / hp_max) * (2.8 * cc.x_scale), ry - cc.y_scale * 30 / 17, color)
            end
            Gra_DrawBox3(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 9, rx + cc.x_scale * 1.4, ry - cc.y_scale * 30 / 17, C_BLACK)
            
            -- 内力背景
            lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 11 + 0.5, rx + cc.x_scale * 1.4, ry - cc.y_scale * 30 / 21, C_GRAY22)
            if mp_max > 0 then
                -- 内力
                lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 11 + 0.5, rx - cc.x_scale * 1.4 + (current_mp / mp_max) * (2.8 * cc.x_scale), ry - cc.y_scale * 30 / 21, C_BLUE)
            end
            Gra_DrawBox3(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 11 + 0.5, rx + cc.x_scale * 1.4, ry - cc.y_scale * 30 / 21, C_BLACK)

            -- 体力背景
            lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 13 + 1, rx + cc.x_scale * 1.4, ry - cc.y_scale * 60 / 54 + 1, C_GRAY22)
            if ph_max > 0 then
                -- 体力
                lib.FillColor(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 13 + 1, rx - cc.x_scale * 1.4 + (current_ph / ph_max) * (2.8 * cc.x_scale), ry - cc.y_scale * 60 / 54 + 1, S_Yellow)
            end
            Gra_DrawBox3(rx - cc.x_scale * 1.4, ry - cc.y_scale * 20 / 13 + 1, rx + cc.x_scale * 1.4, ry - cc.y_scale * 60 / 54 + 1, C_BLACK)
        end
    end
end

-- 绘制一个带背景阴影的方框，四角凹进
-- x1 x轴起始坐标
-- y1 y轴起始坐标
-- x2 x轴结束坐标
-- y2 y轴结束坐标
-- color 边框颜色
function Gra_DrawBox(x1, y1, x2, y2, color)
    local s = 4
	Gra_Background(x1 + 4, y1, x2 - 4, y1 + s, 88)
	Gra_Background(x1 + 1, y1 + 1, x1 + s, y1 + s, 88)
	Gra_Background(x2 - s, y1 + 1, x2 - 1, y1 + s, 88)
	Gra_Background(x1, y1 + 4, x2, y2 - 4, 88)
	Gra_Background(x1 + 1, y2 - s, x1 + s, y2 - 1, 88)
	Gra_Background(x2 - s, y2 - s, x2 - 1, y2 - 1, 88)
	Gra_Background(x1 + 4, y2 - s, x2 - 4, y2, 88)
    local r, g, b = Gra_GetRGB(color)
    Gra_DrawBox1(x1 + 1, y1 + 1, x2, y2, Gra_RGB(math.modf(r / 2), math.modf(g / 2), math.modf(b / 2)))
    Gra_DrawBox1(x1, y1, x2 - 1, y2 - 1, color)
end

-- 绘制一个方框，四角凹进
-- x1 x轴起始坐标
-- y1 y轴起始坐标
-- x2 x轴结束坐标
-- y2 y轴结束坐标
-- color 边框颜色
function Gra_DrawBox1(x1, y1, x2, y2, color)
    local s = 4
	Gra_DrawRect(x1 + s, y1, x2 - s, y1, color)
	Gra_DrawRect(x1 + s, y2, x2 - s, y2, color)
	Gra_DrawRect(x1, y1 + s, x1, y2 - s, color)
	Gra_DrawRect(x2, y1 + s, x2, y2 - s, color)
	Gra_DrawRect(x1 + 2, y1 + 1, x1 + s - 1, y1 + 1, color)
	Gra_DrawRect(x1 + 1, y1 + 2, x1 + 1, y1 + s - 1, color)
	Gra_DrawRect(x2 - s + 1, y1 + 1, x2 - 2, y1 + 1, color)
	Gra_DrawRect(x2 - 1, y1 + 2, x2 - 1, y1 + s - 1, color)
	Gra_DrawRect(x1 + 2, y2 - 1, x1 + s - 1, y2 - 1, color)
	Gra_DrawRect(x1 + 1, y2 - s + 1, x1 + 1, y2 - 2, color)
	Gra_DrawRect(x2 - s + 1, y2 - 1, x2 - 2, y2 - 1, color)
	Gra_DrawRect(x2 - 1, y2 - s + 1, x2 - 1, y2 - 2, color)
end

-- 显示一串带边框的文字，边框四角凹进，有阴影
-- xy xy坐标，如果都为-1，则在屏幕中间显示
-- str 要显示的字符串
-- color 颜色
-- size 文字大小
-- boxcolor 边框颜色
function Gra_DrawStrBox(x, y, str, color, size, boxcolor)
    local len = #str                                            -- 字符长度
    local w = size * len / 2 + 2 * cc.menu_border_pixel         -- 边框的宽
    local h = size + 2 * cc.menu_border_pixel                   -- 边框的高
    boxcolor = boxcolor or C_WHITE                              -- 若无指定背景色，则默认白色

    if x == -1 then
        x = (cc.screen_w - size / 2 * len - 2 * cc.menu_border_pixel) / 2
    end
    if y == -1 then
        y = (cc.screen_h - size - 2 * cc.menu_border_pixel) / 2
    end

    Gra_DrawBox(x, y, x + w - 1, y + h - 1, boxcolor)
    Gra_DrawStr(x + cc.menu_border_pixel, y + cc.menu_border_pixel, str, color, size)
end

-- 显示一串文字，有边框，带有是与否选项
-- xy xy坐标，如果都为-1，则在屏幕中间显示
-- str 要显示的字符串
-- color 颜色
-- size 文字大小
-- boxcolor 边框颜色
function Gra_DrawStrBoxYesNo(x, y, str, color, size, boxcolor)
    if jy.restart == 1 then
        return
    end

    GetKey()
    -- 字符长度
    local len = #str
    -- 对话框宽度
    local w = size * len / 2 + 2 * cc.menu_border_pixel
    -- 对话框高度
    local h = size + 2 * cc.menu_border_pixel

    -- 屏幕中间显示
    if x == -1 then
        x = (cc.screen_w - size / 2 * len - 2 * cc.menu_border_pixel) / 2
    end
    if y == -1 then
        y = (cc.screen_h - size / 2 * cc.menu_border_pixel) / 2
    end

    Gra_Cls()
    -- 绘制对话框
    Gra_DrawStrBox(x, y, str, color, size, boxcolor)
    -- 是否菜单
    local menu = {
        {"确定/是", nil, 1},
        {"取消/否", nil, 2}
    }
    -- 绘制菜单
    local r = Gra_ShowMenu(menu, 2, 0, x + w - 4 * size - 2 * cc.menu_border_pixel, y + h + cc.menu_border_pixel, 0, 0, 1, 0, cc.default_font, C_ORANGE, C_WHITE)
    -- 判断返回
    if r == 1 then
        return true
    else
        return false
    end
end

-- 在屏幕中间显示一串文字，有边框，按任意键后内容才消失
-- str 要显示的字符串
-- color 颜色
-- size 文字大小
-- boxcolor 边框颜色
function Gra_DrawStrBoxWaitKey(str, color, size, flag, boxcolor)
    if jy.restart == 1 then
        return
    end

    GetKey()
    Gra_Cls()
    -- 分开多种
    if flag == nil then
        if boxcolor == nil then
            Gra_DrawStrBox(-1, -1, str, color, size)
        else
            Gra_DrawStrBox(-1, -1, str, color, size, boxcolor)
        end
    else
        Gra_DrawStrBox3(-1, -1, str, color, size, flag)
    end
    Gra_ShowScreen()
    GetKey()
end

-- 显示对话框
-- str 对话框显示的字符串
-- pid 人物编号
-- flag 对话框位置，1 左上，2 左下，3 右上，4 右下，5 上中无头像，6 下中
-- name 对话时显示的名字
function Say(str, pid, flag, name)
    if jy.restart == 1 then
        return
    end

    local bx = cc.fit_width         -- 最大宽度
    local by = cc.fit_high          -- 最大高度
    local picw = 130                -- 头像图片最大宽度
    local pich = 130                -- 头像图片最大高度
    local talkxnum = 30             -- 最大列数
    local talkynum = 3              -- 最大行数
    local dx = 2                    -- 默认宽度
    local dy = 2                    -- 默认高度
    local boxpicw = picw + 10       -- 对话框图片宽度
    local boxpich = pich + 10       -- 对话框图片高度
    -- 对话框总宽度
    local boxtalkw = talkxnum * cc.default_font + 10
    local boxtalkh = boxpich - 27   -- 对话框总高度
    local headid = pid              -- 人物头像id

    -- 若参数name为空，则获取pid人物的半身像
    if name == nil then
        headid = jy.person[pid]["半身像"]
    end
    -- 获取pid人物的名字
    name = name or jy.person[pid]["姓名"]
    local talkborder = (pich - talkynum * cc.default_font) / (talkynum + 1) - 5

    -- 头像和对话的坐标table
    local xy = {
        -- 1 左上
        {headx = dx, heady = dy, 
        talkx = dx + boxpicw + 2, talky = dy + 27, 
        namex = dx + boxpicw + 2, namey = dy, 
        showhead = 1},
        -- 2 左下
        {headx = dx + 68, heady = cc.screen_h - dy - boxpich + 40,
        talkx = dx + boxpicw + 2 + 160, talky = cc.screen_h - dy - boxpich + 27, 
        namex = dx + boxpicw - 50, namey = cc.screen_h - dy - boxpich + 100, 
        showhead = 1},
        -- 3 右上
        {headx = cc.screen_w - 1 - dx - boxpicw, heady = dy,
        talkx = cc.screen_w - 1 - dx - boxpicw - boxtalkw - 2, talky = dy + 27, 
        namex = cc.screen_w - 1 - dx - boxpicw - 96, namey = dy, 
        showhead = 1},
        -- 4 右下
        {headx = cc.screen_w - 1 - dx - boxpicw - 80, heady = cc.screen_h - dy - boxpich + 40,
        talkx = cc.screen_w - 1 - dx - boxpicw - boxtalkw - 2 - 150, talky = cc.screen_h - dy - boxpich + 27, 
        namex = cc.screen_w - 1 - dx - boxpicw - 26, namey = cc.screen_h - dy - boxpich + 100, 
        showhead = 1},
        -- 5 上中，无头像
        {headx = dx, heady = dy, 
        talkx = dx + boxpicw - 43, talky = dy + 27, 
        namex = dx + boxpicw + 2, namey = dy, 
        showhead = 0},
        -- 6 下中
        {headx = cc.screen_w - 1 - dx - boxpicw, heady = cc.screen_h - dy - boxpich,
        talkx = cc.screen_w - 1 - dx - boxpicw - boxtalkw - 2, talky = cc.screen_h - dy - boxpich + 27, 
        namex = cc.screen_w - 1 - dx - boxpicw - 96, namey = cc.screen_h - dy - boxpich, 
        showhead = 1}
    }

    -- 默认主角对话框头像在左下，其他人在右下
    if pid == 0 then
        if name ~= jy.person[pid]["姓名"] then
            flag = 2
        else
            flag = 4
        end
    else
        flag = 2
    end

    -- 无头像
    if xy[flag].showhead == 0 then
        headid = -1
    end

    GetKey()

    local function ReadStr(str)
        local T1 = {}
        local T2 = {}
        local T3 = {}
        -- 美观起见，针对不同字体同一行显示，需要微调ｙ坐标，以及字号
        -- 以默认的字体为标准，启体需下移，细黑需上移
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
            Gra_Cls()
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
            -- 判断单双字符
            if string.byte(str, 1, 1) > 127 then
                strsub = string.sub(str, 1, 2)
                str = string.sub(str, 3, -1)
            else
                strsub = string.sub(str, 1, 1)
                str = string.sub(str, 2, -1)
            end
        end

        -- 开始控制逻辑
        if strsub == "*" then
        elseif strsub == "Ｈ" then
            cx = 0
            cy = cy + 1
            if cy == 3 then
                cy = 0
                page = 0
            end
        elseif strsub == "Ｐ" then
            cx = 0
            cy = 0
            page = 0
        elseif strsub == "ｐ" then
            Gra_ShowScreen()
            Delay(50)
        elseif strsub == "ｗ" then
            Gra_ShowScreen()
            GetKey()
        elseif strsub == "Ｎ" then
            str = jy.person[pid]["姓名"] .. str
        elseif strsub == "ｎ" then
            str = jy.person[0]["姓名"] .. str
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

-- 设置颜色RGB
function Gra_RGB(r, g, b)
    return r * 65536 + g * 256 + b
end

-- 分离颜色的RGB分量
function Gra_GetRGB(color)
    color = color % (65536 * 256)
    local r = math.floor(color / 65536)
    color = color % 65536
    local g = math.floor(color / 256)
    local b = color % 256

    return r, g, b
end

----------------------------------------
----------------------------------------
----------------------------------------
----------------------------------------
----------------------------------------




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

-- 添加对颜色转换的支持
function Gra_DrawStrBox3(x, y, str, color, size, flag)
    local len = #str - flag * 2
    local w = size * len / 2 + 2 * cc.menu_border_pixel
    local h = size + 2 * cc.menu_border_pixel
    local function StrColorSwitch(s)
        local color_switch = {{"Ｒ", C_RED}, {"Ｇ", C_GOLD}, {"Ｂ", C_BLACK}, {"Ｗ", C_WHITE}, {"Ｏ", C_ORANGE}}
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

    -- 方框颜色7 - 31
    Gra_DrawBox(x, y, x + w - 1, y + h -1, LimeGreen)
    local space = 0
    while string.len(s) >= 1 do
        local str2
        str2 = string.sub(str, 1, 1)
        -- 判断单双字符
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

-- 显示带边框的文字
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

-- 显示带边框的文字
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



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------- orionids：以下为graphic通用函数，如无必要，请勿修改 ---------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



-- 切换全屏和窗口，调用一次，改变一次状态
function Gra_FullScreen()
    lib.FullScreen()
end

-- 裁剪窗口，设置以后所有对表面的绘图操作都只影响(x1, y1)-(x2, y2)的矩形框内部
-- 如果x1, y1, x2, y2均为0，则裁剪窗口为整个表面
-- 本函数在内部维护一个裁剪窗口列表，ShowScreen函数使用此列表来更新实际的屏幕显示
-- 每调用一次，裁剪窗口数量+1，最多为20个
-- 当x1, y1, x2, y2均为0时，清除全部裁剪窗口
-- 若调用时不带参数，则默认xy均为0
function Gra_SetClip(x1, y1, x2, y2)
    -- 省略时的默认值
    if not x1 then
        x1, y1, x2, y2 = 0, 0, 0, 0
    end

    -- 参数检测
    if not y1 or not x2 or not y2 then
        error('参数省略错误')
    elseif x1 < 0 or y1 < 0 or x2 < 0 or y2 < 0 then
        error('xy错误')
    elseif x2 < x1 or y2 < y1 then
        error('xy错误2')
    end

    lib.SetClip(x1, y1, x2, y2)
end

-- 用颜色color来填充表面的矩形(x1, y1)-(x2, y2)，color为32位RGB，从高到低字节为RGB
-- 如果x1, y1, x2, y2均为0，则填充整个表面
-- 这里的矩形(x1, y1)-(x2, y2)，要在裁剪函数Gra_SetClip范围内，否则无效
-- 若调用时不带参数，则默认xy均为0，颜色为黑色
function Gra_FillColor(x1, y1, x2, y2, color)
    -- 省略时的默认值
    if not x1 then
        x1, y1, x2, y2, color = 0, 0, 0, 0, 0
    end

    -- 参数检测
    if not y1 or not x2 or not y2 or not color then
        error('参数省略错误')
    elseif x1 < 0 or y1 < 0 or x2 < 0 or y2 < 0 then
        error('xy错误')
    elseif color < 0 then
        error('color错误')
    end

    lib.FillColor(x1, y1, x2, y2, color)
end

-- 刷新屏幕，若是不调用这个函数，所有改变画面的操作，都不会正确显示出来
-- flag =0 or nil 显示全部表面，=1 按照SetClip设置的矩形显示，如果没有矩形，则不显示
function Gra_ShowScreen(flag)
    -- 省略时的默认值
    if not flag then
        flag = 0
    end

    -- 参数检测
    if flag ~= 0 and flag ~= 1 then
        error('flag错误')
    end

    lib.ShowSurface(flag)
end

-- 把表面缓慢显示到屏幕
-- t为亮度每变化一次的间隔毫秒数，为了16/32位兼容，一共有32阶亮度变化
-- flag: 0 从暗到亮，1 从亮到暗
function Gra_ShowSlow(t, flag)
    -- 参数检测
    if not t or not flag then
        error('参数省略错误')
    elseif t < 0 or t > 32 then
        error('t错误')
    elseif flag ~= 0 and flag ~= 1 then
        error('flag错误')
    end

    lib.ShowSlow(t, flag)
end

-- 把表面矩形(x1, y1)-(x2, y2)内所有点的亮度降低为bright倍
-- bright取值为0-255，0表示全黑，255表示亮度不变
-- 若调用时不带参数，则默认全黑
function Gra_Background(x1, y1, x2, y2, bright)
    -- 省略时的默认值
    if not x1 then
        x1, y1, x2, y2, bright = 0, 0, 0, 0, 0
    end

    -- 参数检测
    if not y1 or not x2 or not y2 or not bright then
        error('参数省略错误')
    elseif x1 < 0 or y1 < 0 or x2 < 0 or y2 < 0 then
        error('xy错误')
    elseif bright < 0 or bright > 255 then
        error('bright错误')
    end

    lib.Background(x1, y1, x2, y2, bright)
end

-- 绘制矩形(x1,y1)-(x2,y2)，线框为单个像素，颜色为color
-- 若调用时不带参数，则默认xy均为0，颜色为黑色
function Gra_DrawRect(x1, y1, x2, y2, color)
    -- 省略时的默认值
    if not x1 then
        x1, y1, x2, y2, color = 0, 0, 0, 0, 0
    end

    -- 参数检测
    if not y1 or not x2 or not y2 or not color then
        error('参数省略错误')
    elseif x1 < 0 or y1 < 0 or x2 < 0 or y2 < 0 then
        error('xy错误')
    elseif color < 0 then
        error('color错误')
    end

    lib.DrawRect(x1, y1, x2, y2, color)
end

-- 在`(x, y)`位置写字符串
-- 此函数直接显示阴影字，在lua中不用处理阴影字了，这样可以提高字符串显示速度
-- str 需要写的字符串
-- color 字体颜色
-- size 字体像素大小
-- fontname 字体名字，省略时使用默认值
-- charset 字符串字符集，0 GBK, 1 BIG5，省略时使用默认值
-- OScharset: 0 显示简体，1 显示繁体，省略时使用默认值
function Gra_DrawStr(x, y, str, color, size)
    local fontname = cc.font_name
    local charset = cc.src_char_set
    local os_charset = cc.os_char_set

    -- xy为-1时，在正中间
    if x == -1 then
        local len = #str
        x = (cc.screen_w - size / 2 * len - 2 * cc.menu_border_pixel) / 2
    end
    if y == -1 then
        y = (cc.screen_h - size - 2 * cc.menu_border_pixel) / 2
    end

    -- 参数检测
    if not x or not y or not str or not color or not size then
        error('参数省略错误')
    elseif x < 0 or y < 0 then
        error('xy错误')
    elseif type(str) ~= "string" then
        error('str错误')
    elseif color < 0 then
        error('color错误')
    elseif size < 0 then
        error('size错误')
    end

    lib.DrawStr(x, y, str, color, size, fontname, charset, os_charset)
end

-- 初始化贴图Cache，默认加载原来的256色调色板
-- 在转换场景前调用，清空所有保存的贴图文件信息
function Gra_PicInit()
    -- 第一次调用时需要加载调色板，以后就不需要了，设置str为空字符串即可
    lib.PicInit(cc.palette_file)
end

-- 加载贴图文件信息，用于把图片从idx和grp二进制文件中加载
-- idxfilename / grpfilename idx / grp文件名
-- id 加载编号，0-39，最大可加载40个，如果原来就有，则覆盖原来的
function Gra_PicLoadFile(idxfilename, grpfilename, id)
    -- 参数检测
    if not idxfilename or not grpfilename or not id then
        error('参数省略错误')
    elseif type(idxfilename) ~= "string" then
        error('idxfilename错误')
    elseif type(grpfilename) ~= "string" then
        error('grpfilename错误')
    elseif id < 0 or id > 39 then
        error('id错误')
    end
    
    lib.PicLoadFile(idxfilename, grpfilename, id)
end

-- 加载id所指示的贴图文件中编号为picid / 2（为保持兼容，这里依然除2）的贴图到表面的(x, y)坐标
-- 用于把图片从idx和grp二进制文件中加载
-- fileid为lib.PicLoadFile加载的文件的加载编号
-- flag，不同bit代表不同含义，缺省均为0
-- bit0 =0 考虑偏移x和偏移y
--       =1 不考虑偏移量
-- 对于贴图文件来说，原有的RLE8编码格式都保存一个偏移量数据，表示绘图时实际的偏移
-- 现在支持新的PNG格式，由于是直接采用png文件保存进grp文件，没有可以保存偏移量的地方
-- 因此对不需要偏移的贴图，如物品图像，人物头像，直接按照贴图大小保存，加载时设置此位为1即可
-- 对于需要考虑偏移量地方，设置此位为0
-- 而为了处理png中的偏移量，我们假设所有png文件偏移量都在图形正中间
-- 这样如果要载入新的png贴图，必须放大png文件的大小，使偏移点刚好位于图形中间
-- bit1 =0 表示透明
--       =1 需要考虑Alpha混合
-- 与背景alpla混合显示, value为alpha值(0-256)
-- 注意目前不支持png文件本身中的单个像素的alpha通道，只考虑透明与不透明，这是是单独进行Alpha混合
-- bit2 =1 全黑
-- 该贴图先进行全黑处理，然后再Alpha，只有bit1 = 1时才有意义
-- bit3 =1 全白
-- 该贴图先进行全白处理，然后再Alpha，只有bit1 = 1时才有意义
-- value，当flag设置alpha时，为alpha值
-- 当flag = 0时，flag和value都可以为空，即只需要输入前几个参数即可
-- 在正常加载贴图到表面时，flag = 0
-- 在战斗中手工选择移动或者战斗位置和人物被击中时，需要特殊的效果，这是就要使用bit1,bit2,bit3
-- 由于lua不支持单独的位或操作，只能简单用加法替代
-- 如 bit1，bit2设为1，flag = 2 + 4；bit1，bit3设为1，flag = 2 + 8
function Gra_PicLoadCache(fileid, picid, x, y, flag, value, color, w, h)
    if flag == nil then
        flag = 0
    end

    -- 参数检测
    if not fileid or not picid or not x or not y then
        error('参数省略错误')
    elseif fileid < 0 or fileid > 39 then
        error('fileid错误')
    elseif type(picid) ~= "number" then
        error('picid错误')
    elseif x < 0 or y < 0 then
        error('xy错误')
    elseif flag ~=0 and flag ~= 1 and flag ~= 2 and flag ~= 6 and flag ~= 10 then
        error('flag错误')
    end

    lib.PicLoadCache(fileid, picid, x, y, flag, value, color, w, h)
end

-- 显示图片文件filename到位置x, y
-- 支持的文件扩展名为bmp / png / jpg等
-- 若x = -1, y = -1，则显示在屏幕中间
-- 函数会在内存中保存上一次加载的图片文件，以加快重复加载的速度
-- 省略参数时清除占用的内存
function Gra_LoadPicture(filename, x, y)
    -- 省略时的默认值
    if not filename then
        filename, x, y = "", 0, 0
    end

    -- 参数检测
    if not x or not y then
        error('参数省略错误')
    elseif type(filename) ~= "string" then
        error('filename错误')
    elseif x < -1 or y < -1 then
        error('xy错误')
    end

    lib.LoadPicture(filename, x, y)
end

-- 载入png图片路径
-- path png图片文件夹路径
-- fileid 指定id
-- num 载入图片数量
-- percent 比例，范围是0 - 100
function Gra_LoadPNGPath(path, fileid, num, percent)
    -- 参数检测
    if not path or not fileid or not num or not percent then
        error('参数省略错误')
    elseif type(path) ~= "string" then
        error('path错误')
    elseif fileid < 0 or fileid >= 100 then
        error('fileid错误')
    elseif num < 0 then
        error('num错误')
    elseif percent < 0 or percent > 100 then
        error('percent错误')
    end

    lib.LoadPNGPath(path, fileid, num, percent)
end

-- 载入指定png图片
-- fileid 指定id，由LoadPNGPath函数指定
-- picid 指定图片的id乘以2，比如你要载入的png图片叫2.png，那么这里picid要填4，图片名一定要是数字
-- (xy) XY坐标
-- flag 0 越界，1 不越界（也就是设为1的话，图片不会由于xy坐标设置错误而导致显示不全）
function Gra_LoadPNG(fileid, picid, x, y, flag)
    -- 参数检测
    if not fileid or not picid or not x or not y or not flag then
        error('参数省略错误')
    elseif fileid < 0 or fileid >= 100 then
        error('fileid错误')
    elseif type(picid) ~= "number" then
        error('picid错误')
    elseif x < 0 or y < 0 then
        error('xy错误')
    elseif flag ~=0 and flag ~= 1 then
        error('flag错误')
    end

    lib.LoadPNG(fileid, picid, x, y, flag)
end

-- 加载场景地图数据S*和D*
-- Sfilename，s*文件名
-- num，场景个数
-- Dfilename，D*文件名
function Gra_LoadSMap(Sfilename, num, Dfilename)
    local tempfilename = cc.temp_s_filename     -- 保存临时S*的文件名
    local x_max = cc.s_width                    -- 场景宽
    local y_max = cc.s_height                   -- 场景高
    local d_num1 = cc.d_num1                    -- 每个场景几个D数据
    local d_num2 = cc.d_num2                    -- 每个D几个数据

    -- 参数检测
    if not Sfilename or not num or not Dfilename then
        error('参数省略错误')
    elseif type(Sfilename) ~= "string" then
        error('Sfilename错误')
    elseif num < 0 then
        error('num错误')
    elseif type(Dfilename) ~= "string" then
        error('Dfilename错误')
    end
    
    lib.LoadSMap(Sfilename, tempfilename, num, x_max, y_max, Dfilename, d_num1, d_num2)
end

-- 加载战斗地图
-- mapid 战斗地图编号
function Gra_LoadWarMap(mapid)
    local WarIDXfilename = cc.war_map_file[1]       -- 战斗地图文件名idx
    local WarGRPfilename = cc.war_map_file[2]       -- 战斗地图文件名grp
    -- 战斗地图数据层数
    -- num 战斗地图数据层数，
    --      =0 地面数据，=1 建筑，=2 战斗人战斗编号
    --      =3 移动时显示可移动的位置，=4 命中效果，=5 战斗人对应的贴图
    -- 战斗地图只读取两层数据，其余为工作数据区
    -- 这里固定为12，底层C程序里会乘以2，也就是会传24进去
    -- 与读取R*.idx文件时，创建Byte.create(6 * 4)的值相等
    -- 暂时没搞懂是为什么
    local num = 12
                                        
    local x_max = cc.war_width          -- 战斗地图宽
    local y_max = cc.war_height         -- 战斗地图高

    -- 参数检测
    if not mapid then
        error('参数省略错误')
    elseif mapid < 0 then
        error('mapid错误')
    end

    lib.LoadWarMap(WarIDXfilename, WarGRPfilename, mapid, num, x_max, y_max)
end

-- 播放mpeg1视频，key为停止播放按键的键码，一般设为Esc键
function Gra_PlayMPEG(filename, key)
    -- 参数检测
    if not filename or not key then
        error('参数省略错误')
    elseif type(filename) ~= "string" then
        error('filename错误')
    end

    lib.PlayMPEG(filename, key)
end