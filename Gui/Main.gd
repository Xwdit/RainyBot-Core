extends Control

const NAME = "RainyBot-Core"
const VERSION = "V1.1.2-Dev"
const AUTHOR = "Xwdit"


func _ready():
	DisplayServer.window_set_title("RainyBot")
	GuiManager.console_print_success("成功加载模块:"+NAME+" 版本:"+VERSION+" 作者:"+AUTHOR)
	BotAdapter.init()


func _on_MenuButton_button_down():
	GuiManager.open_gui_module("MainMenu")
