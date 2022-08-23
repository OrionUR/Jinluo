
-- �����ļ�
--Ϊ�˼򻯴��������ļ�Ҳ��lua��д
--����C�����ȡ�Ĳ�����lua��������Ҫ���������Ĳ�����lua������������Ȼ����jyconst.lua��

CONFIG = {}                             -- ���ñ���


CONFIG.Debug = 1                        --������Ժʹ�����Ϣ��0�������1�����Ϣ��debug.txt��error.txt����ǰĿ¼
CONFIG.Type = 1                         -- �����������С��640*480(��СΪ320*240) ��Ϊ0�����ڵ���640*480 ��Ϊ1
                                        -- Ŀǰֻ������������������ֱ�����Ȼ���ã���Ϣ���ܹ���ʾ��������ʾЧ����һ���ÿ�
                                        -- ������������ֱ�����������ʾЧ��������������jyconst.lua���޸���Ӧ������
CONFIG.Width  = 1360                    -- ��Ϸͼ�δ��ڿ�, ����Ϊ0����ϵͳ�Զ���Ӧ
CONFIG.Height = 768                     -- ��Ϸͼ�δ��ڸ�, ����Ϊ0����ϵͳ�Զ���Ӧ
CONFIG.bpp = 32                         -- ȫ��ʱ����ɫ�һ��Ϊ16����32
                                        -- �ڴ���ģʽʱֱ�Ӳ��õ�ǰ��Ļɫ���������Ч
                                        -- ��֧��8λɫ�Ϊ����ٶȣ�����ʹ��16λɫ��
                                        -- 24λδ�������ԣ�����֤��ȷ��ʾCONFIG.FullScreen=0-- ����ʱ�Ƿ�ȫ����0���ڣ�1ȫ��CONFIG.EnableSound=1-- �Ƿ��������0�رգ�1�򿪣��ر�������Ϸ���޷���
CONFIG.XScale = 18                      -- ��ͼ��ȵ�һ��
CONFIG.YScale = 9                       -- ��ͼ�߶ȵ�һ��
CONFIG.CharSet = 0                      -- ��Ϸ���壬0���壬1����
CONFIG.LargeMemory = 0                  -- �����ڴ�ʹ�÷�ʽ��0��ʹ���ڴ棬1��ʹ���ڴ�CONFIG.PlayName="ĽԨ"-- ���ǵ�����
-- CONFIG.WoNGName = "��ը����"
-- CONFIG.WoQGName = "׷���Ṧ"CONFIG.HPDisplay=1-- ս��Ѫ����ʾ��0�رգ�1��
CONFIG.CoupleDisplay = 1                -- ս����ʼǰ�Ƿ���ʾ��϶�����0�رգ�1��CONFIG.FrameRate=70-- ÿ֡����������Ϸ��ѭ����ʹ�ã�Խ������·Խ��CONFIG.BattleDelay=40-- ս����������ʾ�ٶȣ�Խ������ʾԽ��CONFIG.Softener=1-- �����ữ��0���ữ��1�ữCONFIG.Bj=1-- �����𶯣�0������1��

-- ��ͼ��С����CONFIG.Zoom=140-- 100ʱΪԶ����200ʱΪ����

if CONFIG.Zoom > 100 then
	CONFIG.XScale = math.modf(CONFIG.XScale * CONFIG.Zoom / 100)            -- ��ͼ��ȵ�һ��
	CONFIG.YScale = math.modf(CONFIG.YScale * CONFIG.Zoom / 100)            -- ��ͼ�߶ȵ�һ��
end

-- ���ø��������ļ���·�������������Ŀ¼��־��windows��ͬ��OS, ��linux�����Ϊ���ʵ�·��
CONFIG.Operation = 0                    -- 0:Windows��1:android
if CONFIG.Operation == 1 then           -- androidĿ¼
	CONFIG.CurrentPath = "/sdcard/JYLDCR/"
	CONFIG.MP3 = 0                      -- �Ƿ��MP3
else                                    -- WindowsĿ¼
	CONFIG.CurrentPath = "./"
	CONFIG.LargeMemory = 1              -- �ڴ��Ƿ��㹻��0С�ڴ棬1���ڴ�
	CONFIG.MP3 = 1                      -- �Ƿ��MP3
end

-- ������ϷĿ¼�¸����ļ��д�ָ�ı���
CONFIG.DataPath = CONFIG.CurrentPath.."data/"
CONFIG.PicturePath = CONFIG.CurrentPath.."pic/"
CONFIG.SoundPath = CONFIG.CurrentPath.."sound/"
CONFIG.ScriptPath = CONFIG.CurrentPath.."script/"
CONFIG.CEventPath = CONFIG.ScriptPath .. "CEvent/"
CONFIG.WuGongPath = CONFIG.ScriptPath .. "WuGong/"
CONFIG.HelpPath = CONFIG.ScriptPath .. "Help/"
CONFIG.ScriptLuaPath = string.format("?.lua;%sscript/?.lua;%sscript/?.lua", CONFIG.CurrentPath, CONFIG.CurrentPath)
CONFIG.JYMain_Lua = CONFIG.ScriptPath .. "JYmain.lua"                           -- lua��������CONFIG.ZT=0--����ѡ��
CONFIG.FontName = CONFIG.CurrentPath..string.format("font/%s.ttf", CONFIG.ZT)   --����

if CONFIG.MP3 == 0 then                 -- ʹ��FMOD����MIDI����Ҫgm.dls�ļ�
	CONFIG.MidSF2 = CONFIG.SoundPath.."mid.sf2"
else
	CONFIG.MidSF2 = ""
end

--��ʾ����ͼx��y�������ӵ���ͼ�����Ա�֤������ͼ��ȫ����ʾ
CONFIG.MMapAddX = 2                     -- ���ͼXY
CONFIG.MMapAddY = 2
CONFIG.SMapAddX = 2                     -- ����XY
CONFIG.SMapAddY = 16
CONFIG.WMapAddX = 2                     -- ս��XY
CONFIG.WMapAddY = 16CONFIG.MusicVolume=0-- ���ò������ֵ�����(0-128)CONFIG.SoundVolume=50-- ���ò�����Ч������(0-128)



if CONFIG.LargeMemory == 1 then
    CONFIG.MAXCacheNum = 1200           -- ��ͼ����������һ��500-1000�������debug.txt�о�������"pic cache is full"�������ʵ�����
	CONFIG.CleanMemory = 0              -- �����л�ʱ�Ƿ�����lua�ڴ棬0������1����
	CONFIG.LoadFullS = 1                -- 0ֻ���뵱ǰ������1����S*�ļ������ڴ棬����S*��4M�࣬�������Խ���ܶ��ڴ�
else
    CONFIG.MAXCacheNum = 500
	CONFIG.CleanMemory = 1
	CONFIG.LoadFullS = 0
end

-- ������λ�ã�-1ΪĬ��λ��
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