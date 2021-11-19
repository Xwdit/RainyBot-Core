#RainyBot插件模板，相关帮助文档及API请访问 https://github.com/Xwdit/RainyBot-API 进行查阅

extends Plugin #默认继承插件类，请勿随意改动


#将在此插件的文件被读取时执行的操作
func _on_init():
	#设定插件相关信息(全部必填)
	set_plugin_info("example","示例插件", "author","1.0","这是插件的介绍" )


#将在此插件被完全加载后执行的操作
func _on_load():
	#开始监听群消息事件，并将群消息事件绑定到_receive_group_event函数
	register_message_event(MessageEvent.Type.GROUP,"_receive_group_event")
	
	#注册一个名为example的控制台指令，并将其绑定到_receive_console_command函数
	#剩余两个参数分别为: 命令是否要求传入参数 , 命令的用法介绍
	register_console_command("example","_receive_console_command",false,["example - 这是一个测试命令"])


#将在此插件运行的每一秒执行的操作
func _on_process():
	#获取插件自成功加载以来经过的时间
	if get_plugin_runtime() % 3600 == 0:
		Member.init(12345).send_message(TextMessage.init("时间又过去一个小时了哟~"))


#将在此插件即将被卸载时执行的操作
func _on_unload():
	#停止监听群消息事件
	unregister_message_event(MessageEvent.Type.GROUP)
	#取消注册名为example的控制台指令
	unregister_console_command("example")


#接收到群消息事件后将触发此函数
#被事件触发的函数需要接收一个参数，参数为事件的实例
func _receive_group_event(event:GroupMessageEvent):
	#在此处处理事件
	if event.get_group().get_id() == 123456789:
		event.reply(TextMessage.init("这是一个回复"))


#指令在控制台被执行后将触发此函数
#被控制台指令触发的函数需要接收两个参数，分别为命令名称及参数列表(数组)
func _receive_console_command(cmd:String,arg:Array):
	Console.print_success("命令执行测试成功!")
