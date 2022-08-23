
-- 配置文件
--为了简化处理，配置文件也用lua编写
--保存C程序读取的参数和lua程序中需要经常调整的参数。lua的其他参数仍然放在jyconst.lua中

CONFIG = {}                             -- 配置变量


CONFIG.Debug = 1                        --输出调试和错误信息，0不输出，1输出信息在debug.txt和error.txt到当前目录
CONFIG.Type = 1                         -- 窗口设置类别，小于640*480(最小为320*240) 设为0，大于等于640*480 设为1
                                        -- 目前只做了这两个类别，其他分辨率虽然可用，信息都能够显示，但是显示效果不一定好看
                                        -- 如果想在其他分辨率下美化显示效果，可以自行在jyconst.lua中修改相应的数据
CONFIG.Width  = 1360                    -- 游戏图形窗口宽, 设置为0则由系统自动适应
CONFIG.Height = 768                     -- 游戏图形窗口高, 设置为0则由系统自动适应
CONFIG.bpp = 32                         -- 全屏时像素色深，一般为16或者32
                                        -- 在窗口模式时直接采用当前屏幕色深，此设置无效
                                        -- 不支持8位色深，为提高速度，建议使用16位色深
                                        -- 24位未经过测试，不保证正确显示CONFIG.FullScreen=0-- 启动时是否全屏，0窗口，1全屏CONFIG.EnableSound=1-- 是否打开声音，0关闭，1打开，关闭了在游戏中无法打开
CONFIG.XScale = 18                      -- 贴图宽度的一半
CONFIG.YScale = 9                       -- 贴图高度的一半
CONFIG.CharSet = 0                      -- 游戏字体，0简体，1繁体
CONFIG.LargeMemory = 0                  -- 设置内存使用方式，0少使用内存，1多使用内存CONFIG.PlayName="慕渊"-- 主角的名字
-- CONFIG.WoNGName = "叼炸天神功"
-- CONFIG.WoQGName = "追风轻功"CONFIG.HPDisplay=1-- 战斗血条显示，0关闭，1打开
CONFIG.CoupleDisplay = 1                -- 战斗开始前是否显示组合动画，0关闭，1打开CONFIG.FrameRate=70-- 每帧毫秒数，游戏主循环等使用，越高则走路越慢CONFIG.BattleDelay=40-- 战斗点数的显示速度，越高则显示越慢CONFIG.Softener=1-- 场景柔化，0不柔化，1柔化CONFIG.Bj=1-- 暴击震动，0不动，1动

-- 贴图大小设置CONFIG.Zoom=140-- 100时为远景，200时为近景

if CONFIG.Zoom > 100 then
	CONFIG.XScale = math.modf(CONFIG.XScale * CONFIG.Zoom / 100)            -- 贴图宽度的一半
	CONFIG.YScale = math.modf(CONFIG.YScale * CONFIG.Zoom / 100)            -- 贴图高度的一半
end

-- 设置各个数据文件的路径，如果是其他目录标志和windows不同的OS, 如linux，则改为合适的路径
CONFIG.Operation = 0                    -- 0:Windows，1:android
if CONFIG.Operation == 1 then           -- android目录
	CONFIG.CurrentPath = "/sdcard/JYLDCR/"
	CONFIG.MP3 = 0                      -- 是否打开MP3
else                                    -- Windows目录
	CONFIG.CurrentPath = "./"
	CONFIG.LargeMemory = 1              -- 内存是否足够大，0小内存，1大内存
	CONFIG.MP3 = 1                      -- 是否打开MP3
end

-- 设置游戏目录下各个文件夹代指的变量
CONFIG.DataPath = CONFIG.CurrentPath.."data/"
CONFIG.PicturePath = CONFIG.CurrentPath.."pic/"
CONFIG.SoundPath = CONFIG.CurrentPath.."sound/"
CONFIG.ScriptPath = CONFIG.CurrentPath.."script/"
CONFIG.CEventPath = CONFIG.ScriptPath .. "CEvent/"
CONFIG.WuGongPath = CONFIG.ScriptPath .. "WuGong/"
CONFIG.HelpPath = CONFIG.ScriptPath .. "Help/"
CONFIG.ScriptLuaPath = string.format("?.lua;%sscript/?.lua;%sscript/?.lua", CONFIG.CurrentPath, CONFIG.CurrentPath)
CONFIG.JYMain_Lua = CONFIG.ScriptPath .. "JYmain.lua"                           -- lua主程序名CONFIG.ZT=0--字体选择
CONFIG.FontName = CONFIG.CurrentPath..string.format("font/%s.ttf", CONFIG.ZT)   --字体

if CONFIG.MP3 == 0 then                 -- 使用FMOD播放MIDI，需要gm.dls文件
	CONFIG.MidSF2 = CONFIG.SoundPath.."mid.sf2"
else
	CONFIG.MidSF2 = ""
end

--显示主地图x和y方向增加的贴图数，以保证所有贴图能全部显示
CONFIG.MMapAddX = 2                     -- 大地图XY
CONFIG.MMapAddY = 2
CONFIG.SMapAddX = 2                     -- 场景XY
CONFIG.SMapAddY = 16
CONFIG.WMapAddX = 2                     -- 战斗XY
CONFIG.WMapAddY = 16CONFIG.MusicVolume=0-- 设置播放音乐的音量(0-128)CONFIG.SoundVolume=50-- 设置播放音效的音量(0-128)



if CONFIG.LargeMemory == 1 then
    CONFIG.MAXCacheNum = 1200           -- 贴图缓存数量，一般500-1000。如果在debug.txt中经常出现"pic cache is full"，可以适当增加
	CONFIG.CleanMemory = 0              -- 场景切换时是否清理lua内存，0不清理，1清理
	CONFIG.LoadFullS = 1                -- 0只载入当前场景，1整个S*文件载入内存，由于S*有4M多，这样可以解决很多内存
else
    CONFIG.MAXCacheNum = 500
	CONFIG.CleanMemory = 1
	CONFIG.LoadFullS = 0
end

-- 按键的位置，-1为默认位置
CONFIG.D1X = -1
CONFIG.D1Y = -1
CONFIG.D2X = -1
CONFIG.D2Y = -1
CONFIG.D3X = -1
CONFIG.D3Y = -1
CONFIG.D4X = -1
CONFIG.D4Y = -1
CONFIG.C1X = -1
CONFIG.C1Y = -1
CONFIG.C2X = -1
CONFIG.C2Y = -1
CONFIG.AX = -1
CONFIG.AY = -1
CONFIG.BX = -1
CONFIG.BY = -1