class_name RainyBotCore


const VERSION:String = "V2.0-RC-9"


static func start()->void:
	GuiManager.console_print_warning("正在启动RainyBot核心进程.....")
	GuiManager.console_print_success("成功加载模块: RainyBot-Core | 版本: %s | 作者: Xwdit" % VERSION)
	BotAdapter.start()
