#RainyBot插件模板，相关帮助文档及API请访问https://bot.rainy.love/doc进行查阅

extends Plugin #默认继承插件类，请勿随意改动


#将在此插件初始化时执行的操作
func _on_init():
	#设定插件相关信息(全部必填)
	set_plugin_info("example","示例插件", "author","1.0","这是插件的介绍" )


#将在此插件被完全加载后执行的操作
func _on_load():
	#开始监听群消息事件，并将群消息事件绑定到函数
	register_message_event(MessageEvent.Type.GROUP,"_receive_group_event")


#将在此插件即将被卸载时执行的操作
func _on_unload():
	#停止监听群消息事件
	unregister_message_event(MessageEvent.Type.GROUP)


#接收到群消息事件后将触发此函数
func _receive_group_event(event:GroupMessageEvent):
	#在此处处理事件
	if event.get_group().get_id() == 123456789:
		event.reply(TextMessage.init("这是一个回复"))
