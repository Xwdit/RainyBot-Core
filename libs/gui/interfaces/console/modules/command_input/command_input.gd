extends LineEdit


var current_console:int = 0
var n_history:int = -1
var arr_history:Array = []
var current_text:String = ""


func _input(_event:InputEvent)->void:
	if Input.is_action_just_pressed("ui_up"):
		if arr_history.size() > 0:
			if n_history == -1:
				current_text = text
				n_history = maxi(0,arr_history.size()-1)
			else:
				n_history = maxi(0,n_history-1)
			text = arr_history[n_history]
			await get_tree().process_frame
			caret_column = text.length()
	if Input.is_action_just_pressed("ui_down"):
		if arr_history.size() > 0:
			if n_history != -1:
				if n_history == arr_history.size()-1:
					n_history = -1
					text = current_text
				else:
					n_history = mini(n_history+1,arr_history.size()-1)
					text = arr_history[n_history]
			await get_tree().process_frame
			caret_column = text.length()


func _on_CommandInput_text_submitted(new_text:String)->void:
	text = ""
	if new_text.replace(" ","") == "":
		return
	if arr_history.size() > 0:
		if arr_history[arr_history.size()-1]!=new_text:
			arr_history.append(new_text)
	else:
		arr_history.append(new_text)
	n_history = -1
	if current_console == 0:
		CommandManager.parse_console_command(new_text)
	else:
		if new_text.to_lower() == "/help" or new_text.to_lower() == "help":
			GuiManager.mirai_console_print_text("-----命令列表(全部)-----")
			GuiManager.mirai_console_print_text("stop - 完全停止Mirai进程")
			GuiManager.mirai_console_print_text("restart - 重新启动Mirai进程")
			GuiManager.mirai_console_print_text("-----命令列表(全部)-----")
			return
		elif new_text.to_lower() == "/restart" or new_text.to_lower() == "restart":
			GuiManager.mirai_console_print_success("指令 %s 执行成功！"%new_text)
			BotAdapter.mirai_loader.load_mirai()
			return
		elif new_text.to_lower() == "/stop" or new_text.to_lower() == "stop":
			GuiManager.mirai_console_print_success("指令 %s 执行成功！"%new_text)
			await BotAdapter.mirai_loader.kill_mirai()
			return
		if !new_text.begins_with("/"):
			new_text = "/"+new_text
		var t_arr:PackedStringArray = new_text.split(" ")
		var c_arr:Array = []
		for t in t_arr:
			c_arr.append(TextMessage.init(t).get_metadata())
		var _res_dic:Dictionary = await BotAdapter.send_bot_request("cmd_execute","",{"command":c_arr,"sessionKey":BotAdapter.mirai_client.current_session})
		var _res:BotRequestResult = BotRequestResult.init_meta(_res_dic)
		if _res:
			if _res.is_success():
				GuiManager.mirai_console_print_success("指令 %s 执行成功！"%new_text)
			else:
				GuiManager.mirai_console_print_error("指令 %s 执行失败，可能是参数有误或指令不存在！"%new_text)
		else:
			GuiManager.mirai_console_print_error("指令 %s 执行失败，未能成功获取Mirai后端的指令响应！"%new_text)
