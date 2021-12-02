extends Control


const NAME = "RainyBot-Core"
const VERSION = "V2.0-Alpha-1"
const AUTHOR = "Xwdit"


func _ready():
	DisplayServer.window_set_title("RainyBot")
	GuiManager.console_print_success("成功加载模块: "+NAME+" | 版本:"+VERSION+" | 作者:"+AUTHOR)
	BotAdapter.init()
	$TabContainer.set_tab_title(0,"RainyBot控制台")


func _process(_delta):
	$Status.text = "协议后端:Mirai | %s | Bot ID:%s" % ["已连接" if BotAdapter.is_bot_connected() else "未连接", str(BotAdapter.get_bot_id())]
