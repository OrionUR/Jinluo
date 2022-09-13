--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- orionids������Ϊ��������
-- �������ô��շ�ʽ��������������ʹ��С�»�����������
-- һ�㳣��ʹ�ô��»�������������cc����ʹ��С�»�����������

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- ����ȫ�ֱ���CC��������Ϸ��ʹ�õĳ���
function SetGlobalConst()
    -- ����������SDL2���룬�������ÿ�ݼ�
    VK_ESCAPE = 27
    VK_SPACE = 32           -- ע������Ŀո�ʵ���ϲ���Ҫ���壬��Ϊ�ײ���Զ��ѿո�ת���ɻس�
    VK_RETURN = 13
    VK_F1 = 1073741882
    VK_F2 = 1073741883
    VK_F3 = 1073741884
    VK_F4 = 1073741885
    VK_A = 97
    VK_B = 98
    VK_C = 99
    VK_D = 100
    VK_E = 101
    VK_F = 102
    VK_G = 103
    VK_H = 104
    VK_I = 105
    VK_J = 106
    VK_K = 107
    VK_L = 108
    VK_M = 109
    VK_N = 110
    VK_O = 111
    VK_P = 112
    VK_Q = 113
    VK_R = 114
    VK_S = 115
    VK_T = 116
    VK_U = 117
    VK_V = 118
    VK_W = 119
    VK_X = 120
    VK_Y = 121
    VK_Z = 122
    VK_BACKSPACE = 8
    VK_UP = 1073741906
    VK_DOWN = 1073741905
    VK_LEFT = 1073741904
    VK_RIGHT = 1073741903
    VK_PGUP = 1073741899
    VK_PGDN = 1073741902

    -- ��Ϸ����ɫ����
    C_BLACK = Gra_RGB(0, 0, 0)                  -- ��
    C_GRAY = Gra_RGB(68, 68, 68)                -- ��
    C_SILVER = Gra_RGB(192, 192, 192)           -- ��
    C_BLUE = Gra_RGB(7, 99, 219)                -- ��
    C_RED = Gra_RGB(216, 20, 24)                -- ��
    C_WHITE = Gra_RGB(236, 236, 236)            -- ��
    C_ORANGE = Gra_RGB(252, 148, 16)            -- ��
    C_GOLD = Gra_RGB(236, 200, 40)              -- ��
    C_MATTEDGOLD = Gra_RGB(216, 214, 175)       -- �ƽ�
    C_DARKRED = Gra_RGB(132, 0, 4)              -- ����
    C_INDIGO = Gra_RGB(75, 0, 130)              -- ����ɫ
    C_SLATEGRAY = Gra_RGB(112, 128, 144)        -- ��ʯ
    C_LIMEGREEN = Gra_RGB(100,200, 90)          -- �һ���

    -- ��Ϸ״̬����
    GAME_START = 0          -- ��ʼ����
    GAME_FIRSTMMAP = 1      -- ��һ����ʾ���ͼ
    GAME_MMAP = 2           -- ����ͼ
    GAME_FIRSTSMAP = 3      -- ��һ����ʾ������ͼ
    GAME_SMAP = 4           -- ������ͼ
    GAME_WMAP = 5           -- ս����ͼ
    GAME_DEAD = 6           -- ��������
    GAME_END  = 7           -- ����
    GAME_BLACK = 8          -- ����״̬

    -- ��Ϸ����ȫ�ֱ���
    cc = {}                 -- ������Ϸ��ʹ�õĳ���

    -- dataĿ¼�¸��ļ�·����ַ��˵��
    cc.r_idx_filename = {CONFIG.DataPath .. 'ranger.idx'}       -- R*�ļ�Ŀ¼
    cc.r_grp_filename = {CONFIG.DataPath .. 'ranger.grp'}       -- R*�ļ�����
    -- S��D�����ǹ̶���С����˲��ٶ���idx��
    cc.s_filename = {CONFIG.DataPath .. 'allsin.grp'}           -- S*�ļ�����
    cc.d_filename = {CONFIG.DataPath .. 'alldef.grp'}           -- D*�ļ�����
    cc.temp_s_filename = CONFIG.DataPath .. 'allsinbk.grp'      -- ��ʱ��S*�ļ�
    cc.palette_file = CONFIG.DataPath .. 'mmap.col'             -- 256��ɫ��
    cc.mmap_pic_file = {                                        -- ���ͼ��ͼ
        CONFIG.DataPath .. 'mmap.idx', CONFIG.DataPath .. 'mmap.grp'
    }
    cc.smap_pic_file = {                                        -- ������ͼ
        CONFIG.DataPath .. 'smap.idx', CONFIG.DataPath .. 'smap.grp'
    }
    cc.wmap_pic_file = {                                        -- ս����ͼ
        CONFIG.DataPath .. 'wmap.idx', CONFIG.DataPath .. 'wmap.grp'
    }
    cc.mmap_file = {                                            -- ���ͼ5���ṹ�ļ�
        CONFIG.DataPath .. 'earth.002',
        CONFIG.DataPath .. 'surface.002',
        CONFIG.DataPath .. 'building.002',
        CONFIG.DataPath .. 'buildx.002',
        CONFIG.DataPath .. 'buildy.002'
    }
    cc.eft_file = {                                             -- ��Ч��ͼ
        CONFIG.DataPath .. 'eft.idx', CONFIG.DataPath .. 'eft.grp'
    }
    cc.fight_pic_file = {                                       -- ս����ͼ
        CONFIG.DataPath .. 'fight/fight%03d.idx', CONFIG.DataPath .. 'fight/fight%03d.grp'
    }
    cc.thing_pic_file = {                                       -- ��Ʒ��ͼ
        CONFIG.DataPath .. 'thing.idx', CONFIG.DataPath .. 'thing.grp'
    }
    cc.war_file = CONFIG.DataPath .. 'war.sta'                  -- ս������ļ�
    cc.war_map_file = {                                         -- ս������ļ�
        CONFIG.DataPath .. 'warfld.idx', CONFIG.DataPath .. 'warfld.grp'
    }

    -- picĿ¼�¸��ļ�·����ַ��˵��
    cc.eft_path = CONFIG.PicturePath .. 'eft/'                  -- ��Ч��ͼ
    cc.eft_num = 6000
    cc.body_path = CONFIG.PicturePath .. 'body/'                -- ��������ͼ��
    cc.body_num = 1110
    cc.head_path = CONFIG.PicturePath .. 'head/'                -- ����ͷ��ͼ��
    cc.head_num = 1110
    cc.thing_path = CONFIG.PicturePath .. 'thing/'              -- ��Ʒ��ͼ
    cc.thing_num = 1110
    cc.icon_path = CONFIG.PicturePath .. 'icons/'               -- ͼ��ͼ��
    cc.icon_num = 1010
    cc.ui_path = CONFIG.PicturePath .. 'ui/'                    -- UIͼ��
    cc.ui_num = 1100
    cc.title_image = CONFIG.PicturePath .. 'title.png'          -- ��Ϸ��ʼ����

    -- saveĿ¼�¸��ļ�·����ַ��˵��
    cc.save_path = CONFIG.CurrentPath .. 'save/'                -- �浵·��
    cc.r_grp = cc.save_path..'r%d.grp'                          -- �浵R�ļ�
    cc.s_grp = cc.save_path..'s%d.grp'                          -- �浵S�ļ�
    cc.d_grp = cc.save_path..'d%d.grp'                          -- �浵D�ļ�
    
    -- soundĿ¼�¸��ļ�·����ַ��˵��
    cc.atk_file = CONFIG.SoundPath .. 'atk%02d.wav'             -- ������Ч
    cc.e_file = CONFIG.SoundPath .. 'e%02d.wav'                 -- ������Ч
    if CONFIG.MP3 == 1 then
        cc.midi_file = CONFIG.SoundPath .. 'game%02d.mp3'       -- ����MP3
    else
        cc.midi_file = CONFIG.SoundPath .. 'game%02d.mid'       -- ����MID
    end

    -- ���洰����س���
    cc.screen_w = lib.GetScreenW()          -- �����趨�������
    cc.screen_h = lib.GetScreenH()          -- �����趨�����߶�
    cc.fit_width = cc.screen_w / 1360       -- ��ѱ������
    cc.fit_high = cc.screen_h / 768         -- ��ѱ����߶�
    cc.m_width = 480                        -- ���ͼ��
    cc.m_height = 480                       -- ���ͼ��
    cc.s_width = 64                         -- ������ͼ��
    cc.s_height = 64                        -- ������ͼ��
    cc.d_num1 = 200                         -- ÿ����������D���ݣ�ӦΪ200
    cc.d_num2 = 11                          -- ÿ��D�������ݣ�ӦΪ11
    cc.war_width = 64                       -- ս����ͼ��
    cc.war_height = 64                      -- ս����ͼ��
    cc.x_scale = CONFIG.XScale              -- ��ͼһ��Ŀ�
    cc.y_scale = CONFIG.YScale              -- ��ͼһ��ĸ�
    cc.menu_border_pixel = 5                -- �˵����ܱ߿�������������Ҳ���ڻ����ַ�����box������������

    -- �趨��س���
    cc.src_char_set = 0                     -- Դ������ַ�����0 BGK��1 Big5������ת��R��
    cc.os_char_set = CONFIG.CharSet         -- OS�ַ�����0 ����, 1 ����
    cc.font_name = CONFIG.FontName          -- ��ʾ����
    cc.frame = CONFIG.FrameRate             -- ÿ֡������
    cc.battle_delay = CONFIG.BattleDelay    -- ս���ӳ�
    cc.font_size_15 = 15                    -- �����С15
    cc.font_size_20 = 20                    -- �����С20
    cc.font_size_25 = 25                    -- �����С25
    cc.font_size_30 = 30                    -- �����С30
    cc.font_size_35 = 35                    -- �����С35
    cc.font_size_40 = 40                    -- �����С40
    cc.save_num = 10                        -- �浵����
    
    -- ��������
    cc.run_str = {                          -- ��̬��ʾ������
        '���²�������qqȺ��758446108����',
        '����Ϸ�����ز�ȡ����Ѫ������̳/������/���ڽ���/�������¼/��ɽȺ����/����Ⱥ����/����Ⱥ����'
    }

    -- �����¼�ļ�R���ṹ
    -- lua��֧�ֽṹ���޷�ֱ�ӴӶ������ļ��ж�ȡ�������Ҫ��Щ���壬��table�в�ͬ������������ṹ
    cc.base_s = {}                          -- ����������ݵĽṹ
    -- ��ʼλ�ã���0��ʼ�����������ͣ�0�з��ţ�1�޷��ţ�2�ַ�����������
    cc.base_s['�˴�'] = {0, 0, 2}
    cc.base_s['����'] = {2, 0, 2}
    cc.base_s['��X'] = {4, 0, 2}
    cc.base_s['��Y'] = {6, 0, 2}
    cc.base_s['��X1'] = {8, 0, 2}
    cc.base_s['��Y1'] = {10, 0, 2}
    cc.base_s['�˷���'] = {12, 0, 2}
    cc.base_s['��X'] = {14, 0, 2}
    cc.base_s['��Y'] = {16, 0, 2}
    cc.base_s['��X1'] = {18, 0, 2}
    cc.base_s['��Y1'] = {20, 0, 2}
    cc.base_s['������'] = {22, 0, 2}
    cc.base_s['�Ѷ�'] = {24, 0, 2}
    cc.base_s['��׼'] = {26, 0, 2}
    cc.base_s['����'] = {28, 0, 2}
    cc.base_s['����'] = {30, 0, 2}
    cc.base_s['��ͨ'] = {32, 0, 2}
    cc.base_s['��Ŀ'] = {34, 0, 2}
    cc.base_s['��������'] = {36, 0, 2}
    cc.base_s['�书����'] = {38, 0, 2}
    cc.base_s['��Ƭ'] = {40, 0, 2}
    cc.base_s['����5'] = {42, 0, 2}
    cc.base_s['����4'] = {44, 0, 2}
    cc.base_s['����3'] = {46, 0, 2}
    cc.base_s['����2'] = {48, 0, 2}
    cc.base_s['����1'] = {50, 0, 2}
    for i = 1, cc.team_num do
        cc.base_s['����' .. i] = {52 + 2 * (i - 1), 0, 2}
    end
    for i = 1, cc.my_thing_num do
        cc.base_s['��Ʒ' .. i] = {82 + 4 * (i - 1), 0, 2}
        cc.base_s['��Ʒ����' .. i] = {84 + 4 * (i - 1), 0, 2}
    end

    cc.person_size = 602                     -- ÿ����������ռ���ֽ�
    cc.person_s = {}                        -- �����������ݵĽṹ
    cc.person_s['����'] = {0, 0, 2}
    cc.person_s['ͷ�����'] = {2, 0, 2}
    cc.person_s['��������'] = {4, 0, 2}
    cc.person_s['����'] = {6, 0, 2}
    cc.person_s['����'] = {8, 2, 10}
    cc.person_s['���'] = {18, 2, 10}
    cc.person_s['�Ա�'] = {28, 0, 2}
    cc.person_s['�ȼ�'] = {30, 0, 2}
    cc.person_s['����'] = {32, 1, 2}
    cc.person_s['����'] = {34, 0, 2}
    cc.person_s['�������ֵ'] = {36, 0, 2}
    cc.person_s['���˳̶�'] = {38, 0, 2}
    cc.person_s['�ж��̶�'] = {40, 0, 2}
    cc.person_s['����'] = {42, 0, 2}
    cc.person_s['��Ʒ��������'] = {44, 0, 2}
    cc.person_s['����'] = {46, 0, 2}
    cc.person_s['����'] = {48, 0, 2}
    for i = 1, 5 do
        cc.person_s['���ж���֡��' .. i] = {50 + 2 * (i - 1), 0, 2}
        cc.person_s['���ж����ӳ�' .. i] = {60 + 2 * (i - 1), 0, 2}
        cc.person_s['�书��Ч�ӳ�' .. i] = {70 + 2 * (i - 1), 0, 2}
    end
    cc.person_s['��������'] = {80, 0, 2}
    cc.person_s['����'] = {82, 0, 2}
    cc.person_s['�������ֵ'] = {84, 0, 2}
    cc.person_s['������'] = {86, 0, 2}
    cc.person_s['�Ṧ'] = {88, 0, 2}
    cc.person_s['������'] = {90, 0, 2}
    cc.person_s['ҽ��'] = {92, 0, 2}
    cc.person_s['�ö�'] = {94, 0, 2}
    cc.person_s['�ⶾ'] = {96, 0, 2}
    cc.person_s['����'] = {98, 0, 2}
    cc.person_s['ȭ��'] = {100, 0, 2}
    cc.person_s['ָ��'] = {102, 0, 2}
    cc.person_s['����'] = {104, 0, 2}
    cc.person_s['ˣ��'] = {106, 0, 2}
    cc.person_s['����'] = {108, 0, 2}
    cc.person_s['����'] = {110, 0, 2}
    cc.person_s['��ѧ��ʶ'] = {112, 0, 2}
    cc.person_s['Ʒ��'] = {114, 0, 2}
    cc.person_s['��������'] = {116, 0, 2}
    cc.person_s['���һ���'] = {118, 0, 2}
    cc.person_s['����'] = {120, 0, 2}
    cc.person_s['����'] = {122, 0, 2}
    cc.person_s['������Ʒ'] = {124, 0, 2}
    cc.person_s['��������'] = {126, 0, 2}
    for i = 1, 15 do
        cc.person_s['�����书' .. i] = {128 + 2 * (i - 1), 0, 2}
        cc.person_s['�����书�ȼ�' .. i] = {158 + 2 * (i - 1), 0, 2}
    end
    for i = 1, 4 do
        cc.person_s['Я����Ʒ' .. i] = {188 + 2 * (i - 1), 0, 2}
        cc.person_s['Я����Ʒ����' .. i] = {196 + 2 * (i - 1), 0, 2}
    end
    for i = 1, 2 do
        cc.person_s['�츳�⹦' .. i] = {204 + 2 * (i - 1), 0, 2}
    end
    cc.person_s['���Ե���'] = {208, 0, 2}
    cc.person_s['��ѧ����'] = {210, 0, 2}
    cc.person_s['�츳�ڹ�'] = {212, 0, 2}
    cc.person_s['�츳�Ṧ'] = {214, 0, 2}
    cc.person_s['ʵս'] = {216, 0, 2}
    cc.person_s['��ս'] = {218, 0, 2}
    cc.person_s['����'] = {220, 0, 2}
    cc.person_s['�����ڹ�'] = {222, 0, 2}
    cc.person_s['�����Ṧ'] = {224, 0, 2}
    cc.person_s['�������'] = {226, 0, 2}
    cc.person_s['���˾���'] = {228, 0, 2}
    cc.person_s['����ֽ�'] = {230, 0, 2}
    cc.person_s['���2'] = {232, 2, 10}
    cc.person_s['���ճ̶�'] = {242, 0, 2}
    cc.person_s['����̶�'] = {244, 0, 2}
    cc.person_s['�۽�����'] = {246, 0, 2}
    cc.person_s['Ѫ������'] = {248, 0, 2}
    cc.person_s['��Ϊģʽ'] = {250, 0, 2}
    cc.person_s['����ʹ��'] = {252, 0, 2}
    cc.person_s['�Ƿ��ҩ'] = {254, 0, 2}
    cc.person_s['����'] = {256, 0, 2}
    cc.person_s['��'] = {258, 0, 2}
    cc.person_s['��ɫָ��'] = {260, 0, 2}
    cc.person_s['����'] = {262, 0, 2}
    cc.person_s['��ӹ'] = {264, 0, 2}
    cc.person_s['������'] = {266, 0, 2}
    cc.person_s['���ٲ�'] = {268, 0, 2}
    cc.person_s['����'] = {270, 0, 2}
    cc.person_s['��ħ'] = {272, 0, 2}
    for i = 1, 25 do
        cc.person_s['ȭ����Ѩ�ȼ�' .. i] = {274 + 2 * (i - 1), 0, 2}
        cc.person_s['ָ����Ѩ�ȼ�' .. i] = {324 + 2 * (i - 1), 0, 2}
        cc.person_s['������Ѩ�ȼ�' .. i] = {374 + 2 * (i - 1), 0, 2}
        cc.person_s['ˣ����Ѩ�ȼ�' .. i] = {424 + 2 * (i - 1), 0, 2}
        cc.person_s['������Ѩ�ȼ�' .. i] = {474 + 2 * (i - 1), 0, 2}
        cc.person_s['�ڹ���Ѩ�ȼ�' .. i] = {524 + 2 * (i - 1), 0, 2}
    end
    for i = 1, 150 do
        cc.person_s['�书��ʽ' .. i] = {574 + 2 * (i - 1), 0, 2}
    end
    cc.person_s['����λ��'] = {874, 0, 2}
    for i = 1, 8 do
        cc.person_s['���ɼ���' .. i] = {876 + 2 * (i - 1), 0, 2}
    end
    cc.person_s['��Ѫ�̶�'] = {892, 0, 2}
    cc.person_s['��Ѩ�̶�'] = {894, 0, 2}

    cc.thing_size = 202                      -- ÿ����Ʒ����ռ���ֽ�
    cc.thing_s = {}                         -- ������Ʒ���ݵĽṹ
    cc.thing_s['����'] = {0, 0, 2}
    cc.thing_s['����'] = {2, 2, 20}
    cc.thing_s['����2'] = {22, 2, 20}
    cc.thing_s['��Ʒ˵��'] = {42, 2, 30}
    cc.thing_s['�����书'] = {72, 0, 2}
    cc.thing_s['�����������'] = {74, 0, 2}
    cc.thing_s['ʹ����'] = {76, 0, 2}
    cc.thing_s['װ������'] = {78, 0, 2}
    cc.thing_s['��ʾ��Ʒ˵��'] = {80, 0, 2}
    cc.thing_s['����'] = {82, 0, 2}
    cc.thing_s['δ֪5'] = {84, 0, 2}
    cc.thing_s['δ֪6'] = {86, 0, 2}
    cc.thing_s['δ֪7'] = {88, 0, 2}
    cc.thing_s['������'] = {90, 0, 2}
    cc.thing_s['���������ֵ'] = {92, 0, 2}
    cc.thing_s['���ж��ⶾ'] = {94, 0, 2}
    cc.thing_s['������'] = {96, 0, 2}
    cc.thing_s['�ı���������'] = {98, 0, 2}
    cc.thing_s['������'] = {100, 0, 2}
    cc.thing_s['���������ֵ'] = {102, 0, 2}
    cc.thing_s['�ӹ�����'] = {104, 0, 2}
    cc.thing_s['���Ṧ'] = {106, 0, 2}
    cc.thing_s['�ӷ�����'] = {108, 0, 2}
    cc.thing_s['��ҽ��'] = {110, 0, 2}
    cc.thing_s['��ʹ��'] = {112, 0, 2}
    cc.thing_s['�ӽⶾ'] = {114, 0, 2}
    cc.thing_s['�ӿ���'] = {116, 0, 2}
    cc.thing_s['��ȭ��'] = {118, 0, 2}
    cc.thing_s['��ָ��'] = {120, 0, 2}
    cc.thing_s['������'] = {122, 0, 2}
    cc.thing_s['��ˣ��'] = {124, 0, 2}
    cc.thing_s['������'] = {126, 0, 2}
    cc.thing_s['�Ӱ���'] = {128, 0, 2}
    cc.thing_s['����ѧ��ʶ'] = {130, 0, 2}
    cc.thing_s['��Ʒ��'] = {132, 0, 2}
    cc.thing_s['�ӹ�������'] = {134, 0, 2}
    cc.thing_s['�ӹ������'] = {136, 0, 2}
    cc.thing_s['����������'] = {138, 0, 2}
    cc.thing_s['����������'] = {140, 0, 2}
    cc.thing_s['������'] = {142, 0, 2}
    cc.thing_s['�蹥����'] = {144, 0, 2}
    cc.thing_s['���Ṧ'] = {146, 0, 2}
    cc.thing_s['���ö�'] = {148, 0, 2}
    cc.thing_s['��ҽ��'] = {150, 0, 2}
    cc.thing_s['������'] = {152, 0, 2}
    cc.thing_s['��ȭ��'] = {154, 0, 2}
    cc.thing_s['��ָ��'] = {156, 0, 2}
    cc.thing_s['������'] = {158, 0, 2}
    cc.thing_s['��ˣ��'] = {160, 0, 2}
    cc.thing_s['������'] = {162, 0, 2}
    cc.thing_s['�谵��'] = {164, 0, 2}
    cc.thing_s['������'] = {166, 0, 2}
    cc.thing_s['�辭��'] = {168, 0, 2}
    cc.thing_s['������Ʒ�辭��'] = {170, 0, 2}
    cc.thing_s['�����'] = {172, 0, 2}
    for i = 1, 5 do
        cc.thing_s['������Ʒ' .. i] = {174 + 2 * (i - 1), 0, 2}
        cc.thing_s['��Ҫ��Ʒ����' .. i] = {184 + 2 * (i - 1), 0, 2}
    end
    cc.thing_s['�Ƿ���Ч'] = {194, 0, 2}
    cc.thing_s['װ������'] = {196, 0, 2}
    cc.thing_s['װ���ȼ�'] = {198, 0, 2}
    cc.thing_s['װ��ϵ��'] = {200, 0, 2}
    cc.thing_s['���м�'] = {202, 0, 2}

    cc.scene_size = 54                       -- ÿ����������ռ���ֽ�
    cc.scene_s = {}                         -- ���泡�����ݵĽṹ
    cc.scene_s['����'] = {0, 0, 2}
    cc.scene_s['����'] = {2, 2, 10}
    cc.scene_s['��������'] = {12, 0, 2}
    cc.scene_s['��������'] = {14, 0, 2}
    cc.scene_s['��ת����'] = {16, 0, 2}
    cc.scene_s['��������'] = {18, 0, 2}
    cc.scene_s['�⾰���X1'] = {20, 0, 2}
    cc.scene_s['�⾰���Y1'] = {22, 0, 2}
    cc.scene_s['�⾰���X2'] = {24, 0, 2}
    cc.scene_s['�⾰���Y2'] = {26, 0, 2}
    cc.scene_s['���X'] = {28, 0, 2}
    cc.scene_s['���Y'] = {30, 0, 2}
    cc.scene_s['����X1'] = {32, 0, 2}
    cc.scene_s['����X2'] = {34, 0, 2}
    cc.scene_s['����X3'] = {36, 0, 2}
    cc.scene_s['����Y1'] = {38, 0, 2}
    cc.scene_s['����Y2'] = {40, 0, 2}
    cc.scene_s['����Y3'] = {42, 0, 2}
    cc.scene_s['��ת��X1'] = {44, 0, 2}
    cc.scene_s['��ת��Y1'] = {46, 0, 2}
    cc.scene_s['��ת��X2'] = {48, 0, 2}
    cc.scene_s['��ת��Y2'] = {50, 0, 2}
    cc.scene_s['��������'] = {52, 0, 2}

    cc.wugong_size = 148                     -- ÿ���书����ռ���ֽ�
    cc.wugong_s = {}                        -- �����书���ݵĽṹ
    cc.wugong_s['����'] = {0, 0, 2}
    cc.wugong_s['����'] = {2, 2, 10}
    for i = 1, 5 do
        cc.wugong_s['δ֪' .. i] = {12 + 2 * (i - 1), 0, 2}
    end
    cc.wugong_s['������Ч'] = {22, 0, 2}
    cc.wugong_s['�书����'] = {24, 0, 2}
    cc.wugong_s['�书����&��Ч'] = {26, 0, 2}
    cc.wugong_s['�˺�����'] = {28, 0, 2}
    cc.wugong_s['������Χ'] = {30, 0, 2}
    cc.wugong_s['������������'] = {32, 0, 2}
    cc.wugong_s['�����ж�����'] = {34, 0, 2}
    for i = 1, 10 do
        cc.wugong_s['������' .. i] = {36 + 2 * (i - 1), 0, 2}
        cc.wugong_s['�ƶ���Χ' .. i] = {56 + 2 * (i - 1), 0, 2}
        cc.wugong_s['ɱ�˷�Χ' .. i] = {76 + 2 * (i - 1), 0, 2}
        cc.wugong_s['������' .. i] = {96 + 2 * (i - 1), 0, 2}
        cc.wugong_s['ɱ����' .. i] = {116 + 2 * (i - 1), 0, 2}
    end
    cc.wugong_s['����ϵ��'] = {136, 0, 2}
    cc.wugong_s['����ϵ��'] = {138, 0, 2}
    cc.wugong_s['����'] = {140, 2, 10}
    cc.wugong_s['��'] = {150, 0, 2}
    cc.wugong_s['����ϵ��'] = {152, 0, 2}
    cc.wugong_s['��ʱ����'] = {154, 0, 2}
    cc.wugong_s['�㼶'] = {156, 0, 2}
    for i = 1, 4 do
        cc.wugong_s['��Ч' .. i] = {158 + 2 * (i - 1), 0, 2}
    end
    for i = 1, 10 do
        cc.wugong_s['��ʽ'] = {166 + 2 * (i - 1), 0, 2}
    end
    
    cc.shop_size = 36                           -- ÿ���̵�����ռ���ֽ�
    cc.shop_s = {}                              -- �����̵����ݵĽṹ
    for i = 1, 6 do
        cc.shop_s['��Ʒ' .. i] = {0 + 2 * (i - 1), 0, 2}
        cc.shop_s['��Ʒ����' .. i] = {12 + 2 * (i - 1), 0, 2}
        cc.shop_s['��Ʒ�۸�' .. i] = {24 + 2 * (i - 1), 0, 2}
    end

    cc.shop_scene = {}                       -- С���̵곡������
    -- sceneid������id��d_shop��С��λ��D*, d_leave��С���뿪D*��һ���ڳ������ڣ�·������
    cc.shop_scene[0] = {sceneid = 153, d_shop = 16, d_leave = {17, 18}, }
    cc.shop_scene[1] = {sceneid = 3, d_shop = 14, d_leave = {15, 16}, }
    cc.shop_scene[2] = {sceneid = 40, d_shop = 20, d_leave = {21, 22}, }
    cc.shop_scene[3] = {sceneid = 60, d_shop = 16, d_leave = {17, 18}, }
    cc.shop_scene[4] = {sceneid = 159, d_shop = 9, d_leave = {10, 11, 12}, }
end
