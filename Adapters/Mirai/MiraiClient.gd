extends Node


class_name MiraiClient


var _client = WebSocketClient.new()
var processing_command:Dictionary = {}
var found_mirai = false
var first_connected = false


func _ready():
	_client.connect("connection_closed", Callable(self, "_closed"))
	_client.connect("connection_error", Callable(self, "_closed"))
	_client.connect("connection_established", Callable(self, "_connected"))
	_client.connect("data_received", Callable(self, "_on_data"))


func connect_to_mirai(ws_url):
	# Initiate connection to the given URL.
	GuiManager.console_print_warning("正在尝试连接到Mirai框架中，请稍候... | 连接地址: "+ws_url)
	var err = _client.connect_to_url(ws_url)
	if err != OK:
		GuiManager.console_print_error("无法连接到Mirai框架，请检查配置是否有误")
		GuiManager.console_print_warning("将于10秒后尝试重新连接...")
		await get_tree().create_timer(10).timeout
		connect_to_mirai(BotAdapter.get_ws_url())
	else:
		await get_tree().create_timer(5).timeout
		if _client.get_connection_status() == _client.CONNECTION_CONNECTING:
			_client.disconnect_from_host()
			_closed()


func disconnect_to_mirai():
	if is_bot_connected():
		_client.get_peer(1).close()


func _closed(was_clean = false):
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


func _connected(proto = ""):
	found_mirai = true
	GuiManager.console_print_success("成功与Mirai框架进行通信，正在等待响应...")
	_client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)


func _on_data():
	var json = JSON.new()
	json.parse(_client.get_peer(1).get_packet().get_string_from_utf8())
	var data = json.get_data()
	if data.has("syncId"):
		if processing_command.has(data["syncId"].to_int()):
			_parse_command_result(data)
	if data["data"].has("type"):
		BotAdapter.parse_event(data)
	if data["data"].has("session"):
		if !first_connected:
			GuiManager.console_print_success("成功连接至Mirai框架!开始加载插件.....")
			PluginManager.reload_plugins()
			first_connected = true
		else:
			GuiManager.console_print_success("成功恢复与Mirai框架的连接!")


func _process(delta):
	_client.poll()


func send_bot_request(command,sub_command=null,content={},timeout:float=20.0)->Dictionary:
	if !is_bot_connected():
		GuiManager.console_print_error("未连接到Mirai框架，指令请求发送失败: "+command+sub_command+content)
		return {}
	var sync_id = randi()
	while processing_command.has(sync_id):
		sync_id = randi()
	var request = {"syncId":sync_id,"command":command,"subCommand":sub_command,"content":content}
	GuiManager.console_print_warning("正在发送指令请求到Mirai框架："+ str(request))
	var cmd = MiraiRequestInstance.new()
	cmd.sync_id = sync_id
	cmd.request = request
	processing_command[sync_id] = cmd
	var json = JSON.new()
	_client.get_peer(1).put_packet(json.stringify(request).to_utf8_buffer())
	_tick_command_timeout(cmd,timeout)
	await cmd.request_finished
	var result = cmd.get_result()
	return result


func is_bot_connected()->bool:
	return _client.get_peer(1).is_connected_to_host()


func _parse_command_result(result:Dictionary):
	var sync_id = result["syncId"].to_int()
	if processing_command.has(sync_id):
		var cmd:MiraiRequestInstance = processing_command[sync_id]
		cmd.result = result["data"]
		cmd.emit_signal("request_finished")


func _tick_command_timeout(cmd_ins:MiraiRequestInstance,_timeout:float):
	await get_tree().create_timer(_timeout).timeout
	if is_instance_valid(cmd_ins) && cmd_ins.result == null:
		GuiManager.console_print_error("指令请求超时，无法获取到返回结果: "+str(cmd_ins.request))
		cmd_ins.emit_signal("request_finished")
		
		
class MiraiRequestInstance:
	extends RefCounted
	
	signal request_finished
	var request = {}
	var result = {}
	var sync_id = -1

	func get_result()->Dictionary:
		return result
