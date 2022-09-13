--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- orionids：以下为常量设置
-- 函数采用大驼峰式命名方法，变量使用小下划线命名方法
-- 一般常量使用大下划线命名方法，cc常量使用小下划线命名方法

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- 设置全局变量CC，保存游戏中使用的常数
function SetGlobalConst()
    -- 基本完整的SDL2键码，便于设置快捷键
    VK_ESCAPE = 27
    VK_SPACE = 32           -- 注意这里的空格实际上不需要定义，因为底层会自动把空格转换成回车
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

    -- 游戏中颜色定义
    C_BLACK = Gra_RGB(0, 0, 0)                  -- 黑
    C_GRAY = Gra_RGB(68, 68, 68)                -- 灰
    C_SILVER = Gra_RGB(192, 192, 192)           -- 银
    C_BLUE = Gra_RGB(7, 99, 219)                -- 蓝
    C_RED = Gra_RGB(216, 20, 24)                -- 红
    C_WHITE = Gra_RGB(236, 236, 236)            -- 白
    C_ORANGE = Gra_RGB(252, 148, 16)            -- 橘
    C_GOLD = Gra_RGB(236, 200, 40)              -- 金
    C_MATTEDGOLD = Gra_RGB(216, 214, 175)       -- 哑金
    C_DARKRED = Gra_RGB(132, 0, 4)              -- 暗红
    C_INDIGO = Gra_RGB(75, 0, 130)              -- 靓蓝色
    C_SLATEGRAY = Gra_RGB(112, 128, 144)        -- 灰石
    C_LIMEGREEN = Gra_RGB(100,200, 90)          -- 灰灰绿

    -- 游戏状态定义
    GAME_START = 0          -- 开始画面
    GAME_FIRSTMMAP = 1      -- 第一次显示大地图
    GAME_MMAP = 2           -- 主地图
    GAME_FIRSTSMAP = 3      -- 第一次显示场景地图
    GAME_SMAP = 4           -- 场景地图
    GAME_WMAP = 5           -- 战斗地图
    GAME_DEAD = 6           -- 死亡画面
    GAME_END  = 7           -- 结束
    GAME_BLACK = 8          -- 黑屏状态

    -- 游戏数据全局变量
    cc = {}                 -- 定义游戏中使用的常量

    -- data目录下各文件路径地址及说明
    cc.r_idx_filename = {CONFIG.DataPath .. 'ranger.idx'}       -- R*文件目录
    cc.r_grp_filename = {CONFIG.DataPath .. 'ranger.grp'}       -- R*文件数据
    -- S和D由于是固定大小，因此不再定义idx了
    cc.s_filename = {CONFIG.DataPath .. 'allsin.grp'}           -- S*文件数据
    cc.d_filename = {CONFIG.DataPath .. 'alldef.grp'}           -- D*文件数据
    cc.temp_s_filename = CONFIG.DataPath .. 'allsinbk.grp'      -- 临时的S*文件
    cc.palette_file = CONFIG.DataPath .. 'mmap.col'             -- 256调色板
    cc.mmap_pic_file = {                                        -- 大地图贴图
        CONFIG.DataPath .. 'mmap.idx', CONFIG.DataPath .. 'mmap.grp'
    }
    cc.smap_pic_file = {                                        -- 场景贴图
        CONFIG.DataPath .. 'smap.idx', CONFIG.DataPath .. 'smap.grp'
    }
    cc.wmap_pic_file = {                                        -- 战场贴图
        CONFIG.DataPath .. 'wmap.idx', CONFIG.DataPath .. 'wmap.grp'
    }
    cc.mmap_file = {                                            -- 大地图5个结构文件
        CONFIG.DataPath .. 'earth.002',
        CONFIG.DataPath .. 'surface.002',
        CONFIG.DataPath .. 'building.002',
        CONFIG.DataPath .. 'buildx.002',
        CONFIG.DataPath .. 'buildy.002'
    }
    cc.eft_file = {                                             -- 特效贴图
        CONFIG.DataPath .. 'eft.idx', CONFIG.DataPath .. 'eft.grp'
    }
    cc.fight_pic_file = {                                       -- 战斗贴图
        CONFIG.DataPath .. 'fight/fight%03d.idx', CONFIG.DataPath .. 'fight/fight%03d.grp'
    }
    cc.thing_pic_file = {                                       -- 物品贴图
        CONFIG.DataPath .. 'thing.idx', CONFIG.DataPath .. 'thing.grp'
    }
    cc.war_file = CONFIG.DataPath .. 'war.sta'                  -- 战斗相关文件
    cc.war_map_file = {                                         -- 战斗相关文件
        CONFIG.DataPath .. 'warfld.idx', CONFIG.DataPath .. 'warfld.grp'
    }

    -- pic目录下各文件路径地址及说明
    cc.eft_path = CONFIG.PicturePath .. 'eft/'                  -- 特效贴图
    cc.eft_num = 6000
    cc.body_path = CONFIG.PicturePath .. 'body/'                -- 人物身体图案
    cc.body_num = 1110
    cc.head_path = CONFIG.PicturePath .. 'head/'                -- 人物头像图案
    cc.head_num = 1110
    cc.thing_path = CONFIG.PicturePath .. 'thing/'              -- 物品贴图
    cc.thing_num = 1110
    cc.icon_path = CONFIG.PicturePath .. 'icons/'               -- 图标图案
    cc.icon_num = 1010
    cc.ui_path = CONFIG.PicturePath .. 'ui/'                    -- UI图案
    cc.ui_num = 1100
    cc.title_image = CONFIG.PicturePath .. 'title.png'          -- 游戏开始画面

    -- save目录下各文件路径地址及说明
    cc.save_path = CONFIG.CurrentPath .. 'save/'                -- 存档路径
    cc.r_grp = cc.save_path..'r%d.grp'                          -- 存档R文件
    cc.s_grp = cc.save_path..'s%d.grp'                          -- 存档S文件
    cc.d_grp = cc.save_path..'d%d.grp'                          -- 存档D文件
    
    -- sound目录下各文件路径地址及说明
    cc.atk_file = CONFIG.SoundPath .. 'atk%02d.wav'             -- 攻击音效
    cc.e_file = CONFIG.SoundPath .. 'e%02d.wav'                 -- 其他音效
    if CONFIG.MP3 == 1 then
        cc.midi_file = CONFIG.SoundPath .. 'game%02d.mp3'       -- 播放MP3
    else
        cc.midi_file = CONFIG.SoundPath .. 'game%02d.mid'       -- 播放MID
    end

    -- 画面窗口相关常量
    cc.screen_w = lib.GetScreenW()          -- 窗口设定的最大宽度
    cc.screen_h = lib.GetScreenH()          -- 窗口设定的最大高度
    cc.fit_width = cc.screen_w / 1360       -- 最佳比例宽度
    cc.fit_high = cc.screen_h / 768         -- 最佳比例高度
    cc.m_width = 480                        -- 大地图宽
    cc.m_height = 480                       -- 大地图高
    cc.s_width = 64                         -- 场景地图宽
    cc.s_height = 64                        -- 场景地图高
    cc.d_num1 = 200                         -- 每个场景几个D数据，应为200
    cc.d_num2 = 11                          -- 每个D几个数据，应为11
    cc.war_width = 64                       -- 战斗地图宽
    cc.war_height = 64                      -- 战斗地图高
    cc.x_scale = CONFIG.XScale              -- 贴图一半的宽
    cc.y_scale = CONFIG.YScale              -- 贴图一半的高
    cc.menu_border_pixel = 5                -- 菜单四周边框留的像素数，也用于绘制字符串的box四周留的像素

    -- 设定相关常量
    cc.src_char_set = 0                     -- 源代码的字符集，0 BGK，1 Big5，用于转换R×
    cc.os_char_set = CONFIG.CharSet         -- OS字符集，0 简体, 1 繁体
    cc.font_name = CONFIG.FontName          -- 显示字体
    cc.frame = CONFIG.FrameRate             -- 每帧毫秒数
    cc.battle_delay = CONFIG.BattleDelay    -- 战斗延迟
    cc.font_size_15 = 15                    -- 字体大小15
    cc.font_size_20 = 20                    -- 字体大小20
    cc.font_size_25 = 25                    -- 字体大小25
    cc.font_size_30 = 30                    -- 字体大小30
    cc.font_size_35 = 35                    -- 字体大小35
    cc.font_size_40 = 40                    -- 字体大小40
    cc.save_num = 10                        -- 存档数量
    
    -- 其他常量
    cc.run_str = {                          -- 动态显示的内容
        '最新补丁请在qq群号758446108下载',
        '本游戏部分素材取自铁血丹心论坛/游侠网/人在江湖/金书红颜录/黑山群侠传/金书群侠传/金门群侠传'
    }

    -- 定义记录文件R×结构
    -- lua不支持结构，无法直接从二进制文件中读取，因此需要这些定义，用table中不同的名字来仿真结构
    cc.base_s = {}                          -- 保存基本数据的结构
    -- 起始位置（从0开始），数据类型（0有符号，1无符号，2字符串），长度
    cc.base_s['乘船'] = {0, 0, 2}
    cc.base_s['无用'] = {2, 0, 2}
    cc.base_s['人X'] = {4, 0, 2}
    cc.base_s['人Y'] = {6, 0, 2}
    cc.base_s['人X1'] = {8, 0, 2}
    cc.base_s['人Y1'] = {10, 0, 2}
    cc.base_s['人方向'] = {12, 0, 2}
    cc.base_s['船X'] = {14, 0, 2}
    cc.base_s['船Y'] = {16, 0, 2}
    cc.base_s['船X1'] = {18, 0, 2}
    cc.base_s['船Y1'] = {20, 0, 2}
    cc.base_s['船方向'] = {22, 0, 2}
    cc.base_s['难度'] = {24, 0, 2}
    cc.base_s['标准'] = {26, 0, 2}
    cc.base_s['畅想'] = {28, 0, 2}
    cc.base_s['特殊'] = {30, 0, 2}
    cc.base_s['单通'] = {32, 0, 2}
    cc.base_s['周目'] = {34, 0, 2}
    cc.base_s['天书数量'] = {36, 0, 2}
    cc.base_s['武功数量'] = {38, 0, 2}
    cc.base_s['碎片'] = {40, 0, 2}
    cc.base_s['备用5'] = {42, 0, 2}
    cc.base_s['备用4'] = {44, 0, 2}
    cc.base_s['备用3'] = {46, 0, 2}
    cc.base_s['备用2'] = {48, 0, 2}
    cc.base_s['备用1'] = {50, 0, 2}
    for i = 1, cc.team_num do
        cc.base_s['队伍' .. i] = {52 + 2 * (i - 1), 0, 2}
    end
    for i = 1, cc.my_thing_num do
        cc.base_s['物品' .. i] = {82 + 4 * (i - 1), 0, 2}
        cc.base_s['物品数量' .. i] = {84 + 4 * (i - 1), 0, 2}
    end

    cc.person_size = 602                     -- 每个人物数据占用字节
    cc.person_s = {}                        -- 保存人物数据的结构
    cc.person_s['代号'] = {0, 0, 2}
    cc.person_s['头像代号'] = {2, 0, 2}
    cc.person_s['生命增长'] = {4, 0, 2}
    cc.person_s['无用'] = {6, 0, 2}
    cc.person_s['姓名'] = {8, 2, 10}
    cc.person_s['外号'] = {18, 2, 10}
    cc.person_s['性别'] = {28, 0, 2}
    cc.person_s['等级'] = {30, 0, 2}
    cc.person_s['经验'] = {32, 1, 2}
    cc.person_s['生命'] = {34, 0, 2}
    cc.person_s['生命最大值'] = {36, 0, 2}
    cc.person_s['受伤程度'] = {38, 0, 2}
    cc.person_s['中毒程度'] = {40, 0, 2}
    cc.person_s['体力'] = {42, 0, 2}
    cc.person_s['物品修炼点数'] = {44, 0, 2}
    cc.person_s['武器'] = {46, 0, 2}
    cc.person_s['防具'] = {48, 0, 2}
    for i = 1, 5 do
        cc.person_s['出招动画帧数' .. i] = {50 + 2 * (i - 1), 0, 2}
        cc.person_s['出招动画延迟' .. i] = {60 + 2 * (i - 1), 0, 2}
        cc.person_s['武功音效延迟' .. i] = {70 + 2 * (i - 1), 0, 2}
    end
    cc.person_s['内力性质'] = {80, 0, 2}
    cc.person_s['内力'] = {82, 0, 2}
    cc.person_s['内力最大值'] = {84, 0, 2}
    cc.person_s['攻击力'] = {86, 0, 2}
    cc.person_s['轻功'] = {88, 0, 2}
    cc.person_s['防御力'] = {90, 0, 2}
    cc.person_s['医疗'] = {92, 0, 2}
    cc.person_s['用毒'] = {94, 0, 2}
    cc.person_s['解毒'] = {96, 0, 2}
    cc.person_s['抗毒'] = {98, 0, 2}
    cc.person_s['拳掌'] = {100, 0, 2}
    cc.person_s['指法'] = {102, 0, 2}
    cc.person_s['御剑'] = {104, 0, 2}
    cc.person_s['耍刀'] = {106, 0, 2}
    cc.person_s['奇门'] = {108, 0, 2}
    cc.person_s['暗器'] = {110, 0, 2}
    cc.person_s['武学常识'] = {112, 0, 2}
    cc.person_s['品德'] = {114, 0, 2}
    cc.person_s['攻击带毒'] = {116, 0, 2}
    cc.person_s['左右互博'] = {118, 0, 2}
    cc.person_s['声望'] = {120, 0, 2}
    cc.person_s['资质'] = {122, 0, 2}
    cc.person_s['修炼物品'] = {124, 0, 2}
    cc.person_s['修炼点数'] = {126, 0, 2}
    for i = 1, 15 do
        cc.person_s['所会武功' .. i] = {128 + 2 * (i - 1), 0, 2}
        cc.person_s['所会武功等级' .. i] = {158 + 2 * (i - 1), 0, 2}
    end
    for i = 1, 4 do
        cc.person_s['携带物品' .. i] = {188 + 2 * (i - 1), 0, 2}
        cc.person_s['携带物品数量' .. i] = {196 + 2 * (i - 1), 0, 2}
    end
    for i = 1, 2 do
        cc.person_s['天赋外功' .. i] = {204 + 2 * (i - 1), 0, 2}
    end
    cc.person_s['属性点数'] = {208, 0, 2}
    cc.person_s['武学点数'] = {210, 0, 2}
    cc.person_s['天赋内功'] = {212, 0, 2}
    cc.person_s['天赋轻功'] = {214, 0, 2}
    cc.person_s['实战'] = {216, 0, 2}
    cc.person_s['出战'] = {218, 0, 2}
    cc.person_s['命中'] = {220, 0, 2}
    cc.person_s['主运内功'] = {222, 0, 2}
    cc.person_s['主运轻功'] = {224, 0, 2}
    cc.person_s['六如觉醒'] = {226, 0, 2}
    cc.person_s['个人觉醒'] = {228, 0, 2}
    cc.person_s['畅想分阶'] = {230, 0, 2}
    cc.person_s['外号2'] = {232, 2, 10}
    cc.person_s['灼烧程度'] = {242, 0, 2}
    cc.person_s['冰封程度'] = {244, 0, 2}
    cc.person_s['论剑奖励'] = {246, 0, 2}
    cc.person_s['血量翻倍'] = {248, 0, 2}
    cc.person_s['行为模式'] = {250, 0, 2}
    cc.person_s['优先使用'] = {252, 0, 2}
    cc.person_s['是否吃药'] = {254, 0, 2}
    cc.person_s['能量'] = {256, 0, 2}
    cc.person_s['格挡'] = {258, 0, 2}
    cc.person_s['特色指令'] = {260, 0, 2}
    cc.person_s['坐骑'] = {262, 0, 2}
    cc.person_s['中庸'] = {264, 0, 2}
    cc.person_s['半身像'] = {266, 0, 2}
    cc.person_s['迷踪步'] = {268, 0, 2}
    cc.person_s['门派'] = {270, 0, 2}
    cc.person_s['心魔'] = {272, 0, 2}
    for i = 1, 25 do
        cc.person_s['拳掌奇穴等级' .. i] = {274 + 2 * (i - 1), 0, 2}
        cc.person_s['指法奇穴等级' .. i] = {324 + 2 * (i - 1), 0, 2}
        cc.person_s['御剑奇穴等级' .. i] = {374 + 2 * (i - 1), 0, 2}
        cc.person_s['耍刀奇穴等级' .. i] = {424 + 2 * (i - 1), 0, 2}
        cc.person_s['奇门奇穴等级' .. i] = {474 + 2 * (i - 1), 0, 2}
        cc.person_s['内功奇穴等级' .. i] = {524 + 2 * (i - 1), 0, 2}
    end
    for i = 1, 150 do
        cc.person_s['武功招式' .. i] = {574 + 2 * (i - 1), 0, 2}
    end
    cc.person_s['门派位阶'] = {874, 0, 2}
    for i = 1, 8 do
        cc.person_s['门派技能' .. i] = {876 + 2 * (i - 1), 0, 2}
    end
    cc.person_s['流血程度'] = {892, 0, 2}
    cc.person_s['封穴程度'] = {894, 0, 2}

    cc.thing_size = 202                      -- 每个物品数据占用字节
    cc.thing_s = {}                         -- 保存物品数据的结构
    cc.thing_s['代号'] = {0, 0, 2}
    cc.thing_s['名称'] = {2, 2, 20}
    cc.thing_s['名称2'] = {22, 2, 20}
    cc.thing_s['物品说明'] = {42, 2, 30}
    cc.thing_s['练出武功'] = {72, 0, 2}
    cc.thing_s['暗器动画编号'] = {74, 0, 2}
    cc.thing_s['使用人'] = {76, 0, 2}
    cc.thing_s['装备类型'] = {78, 0, 2}
    cc.thing_s['显示物品说明'] = {80, 0, 2}
    cc.thing_s['类型'] = {82, 0, 2}
    cc.thing_s['未知5'] = {84, 0, 2}
    cc.thing_s['未知6'] = {86, 0, 2}
    cc.thing_s['未知7'] = {88, 0, 2}
    cc.thing_s['加生命'] = {90, 0, 2}
    cc.thing_s['加生命最大值'] = {92, 0, 2}
    cc.thing_s['加中毒解毒'] = {94, 0, 2}
    cc.thing_s['加体力'] = {96, 0, 2}
    cc.thing_s['改变内力性质'] = {98, 0, 2}
    cc.thing_s['加内力'] = {100, 0, 2}
    cc.thing_s['加内力最大值'] = {102, 0, 2}
    cc.thing_s['加攻击力'] = {104, 0, 2}
    cc.thing_s['加轻功'] = {106, 0, 2}
    cc.thing_s['加防御力'] = {108, 0, 2}
    cc.thing_s['加医疗'] = {110, 0, 2}
    cc.thing_s['加使毒'] = {112, 0, 2}
    cc.thing_s['加解毒'] = {114, 0, 2}
    cc.thing_s['加抗毒'] = {116, 0, 2}
    cc.thing_s['加拳掌'] = {118, 0, 2}
    cc.thing_s['加指法'] = {120, 0, 2}
    cc.thing_s['加御剑'] = {122, 0, 2}
    cc.thing_s['加耍刀'] = {124, 0, 2}
    cc.thing_s['加奇门'] = {126, 0, 2}
    cc.thing_s['加暗器'] = {128, 0, 2}
    cc.thing_s['加武学常识'] = {130, 0, 2}
    cc.thing_s['加品德'] = {132, 0, 2}
    cc.thing_s['加攻击次数'] = {134, 0, 2}
    cc.thing_s['加功夫带毒'] = {136, 0, 2}
    cc.thing_s['仅修炼人物'] = {138, 0, 2}
    cc.thing_s['需内力性质'] = {140, 0, 2}
    cc.thing_s['需内力'] = {142, 0, 2}
    cc.thing_s['需攻击力'] = {144, 0, 2}
    cc.thing_s['需轻功'] = {146, 0, 2}
    cc.thing_s['需用毒'] = {148, 0, 2}
    cc.thing_s['需医疗'] = {150, 0, 2}
    cc.thing_s['加命中'] = {152, 0, 2}
    cc.thing_s['需拳掌'] = {154, 0, 2}
    cc.thing_s['需指法'] = {156, 0, 2}
    cc.thing_s['需御剑'] = {158, 0, 2}
    cc.thing_s['需耍刀'] = {160, 0, 2}
    cc.thing_s['需奇门'] = {162, 0, 2}
    cc.thing_s['需暗器'] = {164, 0, 2}
    cc.thing_s['需资质'] = {166, 0, 2}
    cc.thing_s['需经验'] = {168, 0, 2}
    cc.thing_s['练出物品需经验'] = {170, 0, 2}
    cc.thing_s['需材料'] = {172, 0, 2}
    for i = 1, 5 do
        cc.thing_s['练出物品' .. i] = {174 + 2 * (i - 1), 0, 2}
        cc.thing_s['需要物品数量' .. i] = {184 + 2 * (i - 1), 0, 2}
    end
    cc.thing_s['是否特效'] = {194, 0, 2}
    cc.thing_s['装备经验'] = {196, 0, 2}
    cc.thing_s['装备等级'] = {198, 0, 2}
    cc.thing_s['装备系别'] = {200, 0, 2}
    cc.thing_s['加招架'] = {202, 0, 2}

    cc.scene_size = 54                       -- 每个场景数据占用字节
    cc.scene_s = {}                         -- 保存场景数据的结构
    cc.scene_s['代号'] = {0, 0, 2}
    cc.scene_s['名称'] = {2, 2, 10}
    cc.scene_s['出门音乐'] = {12, 0, 2}
    cc.scene_s['进门音乐'] = {14, 0, 2}
    cc.scene_s['跳转场景'] = {16, 0, 2}
    cc.scene_s['进入条件'] = {18, 0, 2}
    cc.scene_s['外景入口X1'] = {20, 0, 2}
    cc.scene_s['外景入口Y1'] = {22, 0, 2}
    cc.scene_s['外景入口X2'] = {24, 0, 2}
    cc.scene_s['外景入口Y2'] = {26, 0, 2}
    cc.scene_s['入口X'] = {28, 0, 2}
    cc.scene_s['入口Y'] = {30, 0, 2}
    cc.scene_s['出口X1'] = {32, 0, 2}
    cc.scene_s['出口X2'] = {34, 0, 2}
    cc.scene_s['出口X3'] = {36, 0, 2}
    cc.scene_s['出口Y1'] = {38, 0, 2}
    cc.scene_s['出口Y2'] = {40, 0, 2}
    cc.scene_s['出口Y3'] = {42, 0, 2}
    cc.scene_s['跳转口X1'] = {44, 0, 2}
    cc.scene_s['跳转口Y1'] = {46, 0, 2}
    cc.scene_s['跳转口X2'] = {48, 0, 2}
    cc.scene_s['跳转口Y2'] = {50, 0, 2}
    cc.scene_s['场景类型'] = {52, 0, 2}

    cc.wugong_size = 148                     -- 每个武功数据占用字节
    cc.wugong_s = {}                        -- 保存武功数据的结构
    cc.wugong_s['代号'] = {0, 0, 2}
    cc.wugong_s['名称'] = {2, 2, 10}
    for i = 1, 5 do
        cc.wugong_s['未知' .. i] = {12 + 2 * (i - 1), 0, 2}
    end
    cc.wugong_s['出招音效'] = {22, 0, 2}
    cc.wugong_s['武功类型'] = {24, 0, 2}
    cc.wugong_s['武功动画&音效'] = {26, 0, 2}
    cc.wugong_s['伤害类型'] = {28, 0, 2}
    cc.wugong_s['攻击范围'] = {30, 0, 2}
    cc.wugong_s['消耗内力点数'] = {32, 0, 2}
    cc.wugong_s['敌人中毒点数'] = {34, 0, 2}
    for i = 1, 10 do
        cc.wugong_s['攻击力' .. i] = {36 + 2 * (i - 1), 0, 2}
        cc.wugong_s['移动范围' .. i] = {56 + 2 * (i - 1), 0, 2}
        cc.wugong_s['杀伤范围' .. i] = {76 + 2 * (i - 1), 0, 2}
        cc.wugong_s['加内力' .. i] = {96 + 2 * (i - 1), 0, 2}
        cc.wugong_s['杀内力' .. i] = {116 + 2 * (i - 1), 0, 2}
    end
    cc.wugong_s['冰封系数'] = {136, 0, 2}
    cc.wugong_s['灼烧系数'] = {138, 0, 2}
    cc.wugong_s['门派'] = {140, 2, 10}
    cc.wugong_s['格档'] = {150, 0, 2}
    cc.wugong_s['灵巧系数'] = {152, 0, 2}
    cc.wugong_s['暂时无用'] = {154, 0, 2}
    cc.wugong_s['层级'] = {156, 0, 2}
    for i = 1, 4 do
        cc.wugong_s['特效' .. i] = {158 + 2 * (i - 1), 0, 2}
    end
    for i = 1, 10 do
        cc.wugong_s['招式'] = {166 + 2 * (i - 1), 0, 2}
    end
    
    cc.shop_size = 36                           -- 每个商店数据占用字节
    cc.shop_s = {}                              -- 保存商店数据的结构
    for i = 1, 6 do
        cc.shop_s['物品' .. i] = {0 + 2 * (i - 1), 0, 2}
        cc.shop_s['物品数量' .. i] = {12 + 2 * (i - 1), 0, 2}
        cc.shop_s['物品价格' .. i] = {24 + 2 * (i - 1), 0, 2}
    end

    cc.shop_scene = {}                       -- 小宝商店场景数据
    -- sceneid：场景id，d_shop：小宝位置D*, d_leave：小宝离开D*，一般在场景出口，路过触发
    cc.shop_scene[0] = {sceneid = 153, d_shop = 16, d_leave = {17, 18}, }
    cc.shop_scene[1] = {sceneid = 3, d_shop = 14, d_leave = {15, 16}, }
    cc.shop_scene[2] = {sceneid = 40, d_shop = 20, d_leave = {21, 22}, }
    cc.shop_scene[3] = {sceneid = 60, d_shop = 16, d_leave = {17, 18}, }
    cc.shop_scene[4] = {sceneid = 159, d_shop = 9, d_leave = {10, 11, 12}, }
end
