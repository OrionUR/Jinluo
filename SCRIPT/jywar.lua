-- 设置战斗全局变量
function WarSetGlobal()
    war.person = {}         -- 战斗人物数据
    war.person_num = -1     -- 战斗人物数量
    war.cur_id = -1         -- 当前行动人物id
    war.show_head = -1      -- 显示头像
    war.show_hp = -1        -- 显示生命
end

-- 特色指令
function War_SpecialMenu() 
end

-- 战斗武功选择菜单
-- sb、star为无意义参数，仅为防止代码语法错误跳出
function War_FightMenu(sb, star, wgnum, ...)
    local pid = war.person[war.cur_id]["人物编号"]
    local wugong_num = 0
    local menu = {}
    local canuse = {}
    local c = 0
    local zs = 0
    local zswz = 0
    local tmp = jy.person[pid]["优先使用"]
    local arg = select(1, ...)

    if (SkillInfo[tmp] ~= nil) then
        local zs = SkillInfo.tmp
        for i = 1, #zs do
            for j = 1, jy.base["武功数量"] do
                if (jy.person[pid]["武功" .. j] == jy.person[pid]["优先使用"]) then
                    zs = cc.wugong_zs[j][i]
                    if (arg > 0) or (i < 3) then
                        jy.person[pid]["武功招式" .. zs] = 1
                    end
                    zswz = SkillInfo[tmp][i]
                end
            end
            menu[i] = {SkillInfo[tmp][i][1], nil, 1}
            
            -- 内力少不显示
            if (jy.person[pid]["内力"] < jy.wugong[tmp]["消耗内力点数"]) then
                menu[i][3] = 0
            end

            -- 体力低于10不显示
            if (jy.person[pid]["体力"] < 10) then
                menu[i][3] = 0
            end

            wugong_num = wugong_num + 1

            if (menu[i][3] == 1) then
                c = c + 1
                canuse[c] = i
            end
        end
    end

    if (c == 0) then
        return 0
    end

    if (wgnum == nil) then
        local r = nil
        r = Cat("菜单", menu, wugong_num, 0, cc.main_menu_x, cc.main_menu_y, 0, 0, 1, 1, cc.default_font, C_ORANGE, C_WHITE)
        if (r == 0) then
            return 0
        end
    end
end

-- 运功选择菜单
function War_YunGongMenu()
end

-- 战术菜单
function War_TacticsMenu()
end

function War_OtherMenu()
end

-- 给level层战斗数据全部赋值v
function War_CleanWarMap(level, v)
    local err = -1      -- 错误码
    if not level or not v then
        err = 1         -- 参数省略错误
    elseif level < 0 or level > 5 then
        err = 2         -- level错误
    elseif type(v) ~= "number" then
        err = 3         -- v错误
    end

    -- 错误时返回错误码
    if err > 0 then
        Debug("War_CleanWarMap Error, error code: " .. err)
        return
    end

    lib.CleanWarMap(level, v)
end