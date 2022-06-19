extends Control


func _ready():
	DisplayServer.window_set_title("RainyBot")
	Console.print_success("成功加载 RainyBot-Gui | 版本: %s | 作者: Xwdit" % RainyBotCore.VERSION)
	if !await check_update():
		Console.print_warning("将于10秒后继续启动RainyBot...")
		await get_tree().create_timer(10).timeout
	RainyBotCore.start()


func _process(_delta):
	$Status.text = "协议后端:Mirai | %s | Bot ID:%s" % ["已连接" if BotAdapter.is_bot_connected() else "未连接", str(BotAdapter.get_bot_id()) if BotAdapter.get_bot_id()!=0 else "未配置"]
	var times_dic:Dictionary = Time.get_time_dict_from_unix_time(GlobalManager.global_run_time)
	var time:String = "{hour}小时{minute}分钟".format(times_dic)
	DisplayServer.window_set_title("RainyBot - %s | 已运行时长: %s | 群聊消息: %s条 | 私聊消息: %s条 | 已发送消息: %s条" % [str(BotAdapter.get_bot_id()) if BotAdapter.get_bot_id()!=0 else "未配置账号",time,BotAdapter.group_message_count,BotAdapter.private_message_count,BotAdapter.sent_message_count])
	

func check_update()->bool:
	Console.print_warning("正在检查您的RainyBot是否为最新版本，请稍候...")
	var err = $HTTPRequest.request("https://api.github.com/repos/Xwdit/RainyBot-Core/releases/latest")
	if err != OK:
		Console.print_error("检查更新时出现错误，请检查网络连接是否正常")
		return false
	else:
		var result = await $HTTPRequest.request_completed
		var body:PackedByteArray = result[3]
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var dic:Dictionary = json.get_data()
		if !dic.is_empty() and dic.has("tag_name"):
			var version:String = dic["tag_name"]
			if RainyBotCore.VERSION.to_lower() != version.to_lower():
				Console.print_warning("发现RainyBot新版本! 最新版本为: %s, 您的当前版本为: %s"%[version.to_lower(),RainyBotCore.VERSION.to_lower()])
				Console.print_warning("您可以访问以下网址来获取最新版本: https://github.com/Xwdit/RainyBot-Core/releases")
				return false
			else:
				Console.print_success("版本检查完毕，您的RainyBot已为最新版本！")
				return true
		else:
			Console.print_error("检查更新时出现错误，请检查网络连接是否正常")
			return false
			
