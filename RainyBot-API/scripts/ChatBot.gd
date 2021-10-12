extends Plugin #默认继承插件类，请勿随意改动


#将在此插件初始化时执行的操作
func _on_init():
	#设定插件相关信息(全部必填)
	set_plugin_info({
		"id":"chatbot", #插件唯一ID,不能同时加载两个具有相同ID的插件
		"name":"ChatBot", #插件的显示名称
		"author":"Xwdit", #插件的作者
		"version":"1.0", #插件的版本号
		"description":"A plugin to chat with bots" #插件的描述
	})
	
	#在指令数据库中注册一个指令，用户可调用该指令执行操作
	#参数从左到右分别为指令名称(需唯一)，指令是否必需参数，指令用法介绍(数组的每个元素显示为一行)，指令来源(如插件名)
	register_command("chat",true,["chat <文本> - 测试与机器人的聊天"],get_plugin_info()["id"])


#将在此插件被完全加载后执行的操作
func _on_load():
	receive_commands(true) #开始接收用户指令输入
	receive_message_events(true) #开始接收聊天消息事件


#将在此插件即将被卸载时执行的操作
func _on_unload():
	receive_commands(false) #停止接收用户指令输入
	receive_message_events(false) #停止接收聊天消息事件
	unregister_command("chat") #取消注册指令chat


#接收到群消息事件
func _event_GroupMessage(data:Dictionary):
	
	var group = data["sender"]["group"]["id"] #获取QQ群号
	var msg_chain:Array = data["messageChain"] #获取消息链
	
	#获取消息链中的纯文字消息并链接到text中
	var text = ""
	for msg in msg_chain:
		var _msg:Dictionary = msg
		if _msg["type"] == "Plain":
			text += _msg["text"]
	
	if text.begins_with("萌萌酱"): #判断聊天前缀
		text.erase(0,3) #从消息文本中移除前缀
		text = text.percent_encode() #转码为URL格式
		
		#发送Http Get请求至聊天平台并等待回调
		var req:HttpRequestInstance = send_http_get_request("http://api.qingyunke.com/api.php?key=free&appid=0&msg="+text)
		if !is_instance_valid(req): #若请求失败则返回
			return
		yield(req,"request_finished") #等待指令实例接收指令回调
		var result = req.get_result() #获取回调内容
		req.finish() #在接收回调完毕后清除指令实例来释放内存
		
		if result is Dictionary: #判断回调是否成功
			if result.has("content"):
				var reply:String = result["content"] #获取聊天平台回调中的文本
				reply = reply.replace("菲菲","萌萌酱").replace("{br}","\n") #替换关键词
				
				#构建Mirai命令参数字典
				var content = {
					"target":group,#目标群号
					"messageChain":[
						{ "type":"Plain", "text":reply },#待发送的内容(消息链)
					]
				}
				#发送指令至Mirai框架
				send_mirai_command("sendGroupMessage",null,content)


#接收用户的chat指令输入，并进行处理。
func _command_chat(args:Array):
	var chat = args[0] #获取第一个参数
	
	#发送Http Get请求至聊天平台并等待回调
	var req:HttpRequestInstance = send_http_get_request("http://api.qingyunke.com/api.php?key=free&appid=0&msg="+chat)
	yield(req,"request_finished") #等待指令实例接收指令回调
	if req.get_result() is Dictionary: #判断回调是否成功
		print(req.get_result()["content"]) #打印聊天平台的回调文本
	req.finish() #在接收回调完毕后清除指令实例来释放内存
