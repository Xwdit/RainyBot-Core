extends Plugin #默认继承插件类，请勿随意改动


#将在此插件初始化时执行的操作
func _on_init():
	#设定插件相关信息(全部必填)
	set_plugin_info({
		"id":"chatbot", #插件唯一ID,不能同时加载两个具有相同ID的插件
		"name":"闲聊机器人", #插件的显示名称
		"author":"Xwdit", #插件的作者
		"version":"1.0", #插件的版本号
		"description":"让机器人具备聊天的能力" #插件的描述
	})


#将在此插件被完全加载后执行的操作
func _on_load():
	
	#在指令数据库中注册一个指令，用户可调用该指令执行操作
	#参数从左到右分别为指令名称(需唯一)，指令是否必需参数，指令用法介绍(数组的每个元素显示为一行)，指令来源(如插件名)
	register_command("chat",true,["chat <文本> - 测试与机器人的聊天"],get_plugin_info()["id"])
	register_message_event(MessageEvent.Type.GROUP,"_event_GroupMessage")


#将在此插件即将被卸载时执行的操作
func _on_unload():
	unregister_command("chat") #取消注册指令chat
	unregister_message_event(MessageEvent.Type.GROUP)


#接收到群消息事件
func _event_GroupMessage(event:GroupMessageEvent):
	var text = event.get_message_chain().get_message_text([Message.Type.TEXT])
	
	if text.begins_with("萌萌酱"): #判断聊天前缀
		text = text.substr(3)
		text = text.uri_encode()#转码为URL格式
		
		#发送Http Get请求至聊天平台并等待回调
		var result = await Utils.send_http_get_request("http://api.qingyunke.com/api.php?key=free&appid=0&msg="+text) #获取回调内容
		
		if result is Dictionary: #判断回调是否成功
			if result.has("content"):
				var reply:String = result["content"] #获取聊天平台回调中的文本
				reply = reply.replace("菲菲","萌萌酱").replace("{br}","\n") #替换关键词
				var msg = TextMessage.init(reply)
				event.reply(msg,true)


#接收用户的chat指令输入，并进行处理。
func _command_chat(args:Array):
	var chat = args[0] #获取第一个参数
	
	#发送Http Get请求至聊天平台并等待回调
	var result = await Utils.send_http_get_request("http://api.qingyunke.com/api.php?key=free&appid=0&msg="+chat)
	if result is Dictionary: #判断回调是否成功
		print(result) #打印聊天平台的回调文本
