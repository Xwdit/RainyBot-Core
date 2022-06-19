class_name RainyBotCore


const VERSION = "V2.0-Beta-10"


static func start():
	Console.print_warning("正在启动RainyBot核心进程.....")
	Console.print_success("成功加载模块: RainyBot-Core | 版本: %s | 作者: Xwdit" % VERSION)
	BotAdapter.start()
