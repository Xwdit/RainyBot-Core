class_name RainyBotCore


const NAME = "RainyBot-Core"
const VERSION = "V2.0-Beta-3"
const AUTHOR = "Xwdit"


static func start():
	Console.print_warning("正在启动RainyBot核心进程.....")
	Console.print_success("成功加载模块: "+NAME+" | 版本:"+VERSION+" | 作者:"+AUTHOR)
	BotAdapter.start()
