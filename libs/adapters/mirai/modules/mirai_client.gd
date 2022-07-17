extends Node


class_name MiraiClient


var _client:WebSocketClient = WebSocketClient.new()
var processing_command:Dictionary = {}
var found_mirai:bool = false
var first_connected:bool = false
var mirai_connected:bool = false


func _ready()->void:
	_client.connect("connection_closed", _closed)
	_client.connect("connection_error", _closed)
	_client.connect("connection_established", _connected)
	_client.connect("data_received", _on_data)


func connect_to_mirai(ws_url:String)->void:
	GuiManager.console_print_warning("正在尝试连接到Mirai框架中，请稍候... | 连接地址: "+ws_url)
	var err:int = _client.connect_to_url(ws_url)
	if err:
		GuiManager.console_print_error("无法连接到Mirai框架，请检查配置是否有误")
		GuiManager.console_print_warning("将于10秒后尝试重新连接...")
		await get_tree().create_timer(10).timeout
		connect_to_mirai(BotAdapter.get_ws_url())
	else:
		await get_tree().create_timer(5).timeout
		if _client.get_connection_status() == _client.CONNECTION_CONNECTING:
			_client.disconnect_from_host()
			_closed()


func disconnect_to_mirai()->void:
	if is_bot_connected():
		_client.get_peer(1).close()


func _closed(_was_clean:bool=false)->void:
	if mirai_connected:
		mirai_connected = false
		get_tree().call_group("Plugin","_on_disconnect")
	if found_mirai:
		GuiManager.console_print_warning("到Mirai框架的连接已被关闭，若非人为请检查配置是否有误")
		GuiManager.console_print_warning("若Mirai进程被意外关闭，请使用命令 mirai restart 来重新启动")
		GuiManager.console_print_warning("将于10秒后尝试重新连接...")
		await get_tree().create_timer(10).timeout
		connect_to_mirai(BotAdapter.get_ws_url())
	else:
		GuiManager.console_print_warning("未检测到可进行连接的Mirai框架，正在启动新的Mirai进程...")
		if await BotAdapter.mirai_loader.load_mirai() == OK:
			found_mirai = true
			GuiManager.console_print_success("Mirai进程启动成功，正在等待Mirai进行初始化...")
			await get_tree().create_timer(10).timeout
			connect_to_mirai(BotAdapter.get_ws_url())


func _connected(_proto:String="")->void:
	found_mirai = true
	GuiManager.console_print_success("成功与Mirai框架进行通信，正在等待响应...")
	_client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)


func _on_data()->void:
	var json:JSON = JSON.new()
	var err:int = json.parse(_client.get_peer(1).get_packet().get_string_from_utf8())
	if err == OK:
		var data:Dictionary = json.get_data()
		if data.has("syncId"):
			if processing_command.has(data["syncId"].to_int()):
				_parse_command_result(data)
		if data.has("data"):
			if data["data"].has("type"):
				BotAdapter.parse_event(data)
			if data["data"].has("session"):
				if !first_connected:
					GuiManager.console_print_success("成功连接至Mirai框架!开始加载插件.....")
					PluginManager.reload_plugins()
					first_connected = true
				else:
					GuiManager.console_print_success("成功恢复与Mirai框架的连接!")
				mirai_connected = true
				get_tree().call_group("Plugin","_on_connect")


func _process(_delta:float)->void:
	_client.poll()


func send_bot_request(command:String,sub_command:String,content:Dictionary,timeout:float)->Dictionary:
	if !is_bot_connected():
		GuiManager.console_print_error("未连接到Mirai框架，指令请求发送失败: "+str(command)+" "+str(sub_command)+" "+str(content))
		return {}
	var sync_id:int = randi()
	while processing_command.has(sync_id):
		sync_id = randi()
	var request:Dictionary = {"syncId":sync_id,"command":command,"subCommand":sub_command,"content":content}
	GuiManager.console_print_warning("正在发送指令请求到Mirai框架："+ str(request))
	var cmd:MiraiRequestInstance = MiraiRequestInstance.new()
	cmd.sync_id = sync_id
	cmd.request = request
	processing_command[sync_id] = cmd
	var json:JSON = JSON.new()
	_client.get_peer(1).put_packet(json.stringify(request).to_utf8_buffer())
	if timeout > 0.0:
		GuiManager.console_print_warning("本次请求的超时时间为: %s秒"% timeout)
		_tick_command_timeout(cmd,timeout)
	await cmd.request_finished
	processing_command.erase(sync_id)
	return cmd.get_result()


func is_bot_connected()->bool:
	return _client.get_peer(1).is_connected_to_host()


func _parse_command_result(result:Dictionary)->void:
	var sync_id:int = result["syncId"].to_int()
	if processing_command.has(sync_id):
		var cmd:MiraiRequestInstance = processing_command[sync_id]
		cmd.result = result["data"]
		GuiManager.console_print_success("获取到Mirai框架的回应: "+str(result))
		cmd.emit_signal("request_finished")


func _tick_command_timeout(cmd_ins:MiraiRequestInstance,_timeout:float)->void:
	await get_tree().create_timer(_timeout).timeout
	if is_instance_valid(cmd_ins) && cmd_ins.result == {}:
		GuiManager.console_print_error("指令请求超时，无法获取到返回结果: "+str(cmd_ins.request))
		cmd_ins.emit_signal("request_finished")
		
		
class MiraiRequestInstance:
	extends RefCounted
	
	signal request_finished
	var request:Dictionary = {}
	var result:Dictionary = {}
	var sync_id:int = -1

	func get_result()->Dictionary:
		return result
