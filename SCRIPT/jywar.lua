-- ����ս��ȫ�ֱ���
function WarSetGlobal()
    war.person = {}         -- ս����������
    war.person_num = -1     -- ս����������
    war.cur_id = -1         -- ��ǰ�ж�����id
    war.show_head = -1      -- ��ʾͷ��
    war.show_hp = -1        -- ��ʾ����
end

-- ��ɫָ��
function War_SpecialMenu() 
end

-- ս���书ѡ��˵�
-- sb��starΪ�������������Ϊ��ֹ�����﷨��������
function War_FightMenu(sb, star, wgnum, ...)
    local pid = war.person[war.cur_id]["������"]
    local wugong_num = 0
    local menu = {}
    local canuse = {}
    local c = 0
    local zs = 0
    local zswz = 0
    local tmp = jy.person[pid]["����ʹ��"]
    local arg = select(1, ...)

    if (SkillInfo[tmp] ~= nil) then
        local zs = SkillInfo.tmp
        for i = 1, #zs do
            for j = 1, jy.base["�书����"] do
                if (jy.person[pid]["�书" .. j] == jy.person[pid]["����ʹ��"]) then
                    zs = cc.wugong_zs[j][i]
                    if (arg > 0) or (i < 3) then
                        jy.person[pid]["�书��ʽ" .. zs] = 1
                    end
                    zswz = SkillInfo[tmp][i]
                end
            end
            menu[i] = {SkillInfo[tmp][i][1], nil, 1}
            
            -- �����ٲ���ʾ
            if (jy.person[pid]["����"] < jy.wugong[tmp]["������������"]) then
                menu[i][3] = 0
            end

            -- ��������10����ʾ
            if (jy.person[pid]["����"] < 10) then
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
        r = Cat("�˵�", menu, wugong_num, 0, cc.main_menu_x, cc.main_menu_y, 0, 0, 1, 1, cc.default_font, C_ORANGE, C_WHITE)
        if (r == 0) then
            return 0
        end
    end
end

-- �˹�ѡ��˵�
function War_YunGongMenu()
end

-- ս���˵�
function War_TacticsMenu()
end

function War_OtherMenu()
end

-- ��level��ս������ȫ����ֵv
function War_CleanWarMap(level, v)
    local err = -1      -- ������
    if not level or not v then
        err = 1         -- ����ʡ�Դ���
    elseif level < 0 or level > 5 then
        err = 2         -- level����
    elseif type(v) ~= "number" then
        err = 3         -- v����
    end

    -- ����ʱ���ش�����
    if err > 0 then
        Debug("War_CleanWarMap Error, error code: " .. err)
        return
    end

    lib.CleanWarMap(level, v)
end