extends Node


class_name MiraiClient


# Our WebSocketClient instance
var _client = WebSocketClient.new()
var processing_command:Dictionary = {}


func connect_to_mirai(ws_url):
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", Callable(self, "_closed"))
	_client.connect("connection_error", Callable(self, "_closed"))
	_client.connect("connection_established", Callable(self, "_connected"))
	_client.connect("data_received", Callable(self, "_on_data"))

	# Initiate connection to the given URL.
	GuiManager.console_print_warning("正在尝试连接到Mirai框架中，连接地址: "+ws_url)
	var err = _client.connect_to_url(ws_url)
	if err != OK:
		GuiManager.console_print_error("无法连接到Mirai框架，请检查配置是否有误")
		set_process(false)


func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	GuiManager.console_print_warning("到Mirai框架的连接已被关闭，若非人为请检查配置是否有误")
	set_process(false)


func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	GuiManager.console_print_success("成功与Mirai框架进行通信，正在等待响应...")
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	_client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)


func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var json = JSON.new()
	json.parse(_client.get_peer(1).get_packet().get_string_from_utf8())
	var data = json.get_data()
	if processing_command.has(int(data["syncId"])):
		_parse_command_result(data)
	elif data["data"].has("type"):
		BotAdapter.parse_event(data)
	elif data["data"].has("session"):
		GuiManager.console_print_success("成功连接至Mirai框架!开始加载插件.....")
		PluginManager.reload_plugins()


func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()


func send_bot_request(command,sub_command=null,content={},timeout:float=20.0):
	if !is_bot_connected():
		GuiManager.console_print_error("未连接到Mirai框架，指令请求发送失败: "+command+sub_command+content)
		return null
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
	cmd.free()
	return result


func is_bot_connected()->bool:
	return _client.get_peer(1).is_connected_to_host()


func _parse_command_result(result:Dictionary):
	var sync_id = int(result["syncId"])
	if processing_command.has(sync_id):
		var cmd:MiraiRequestInstance = processing_command[sync_id]
		cmd.result = result["data"]
		cmd.emit_signal("request_finished")


func _tick_command_timeout(cmd_ins:MiraiRequestInstance,_timeout:float):
	await get_tree().create_timer(_timeout).timeout
	if is_instance_valid(cmd_ins) && cmd_ins.result == null:
		cmd_ins.emit_signal("request_finished")
		GuiManager.console_print_error("指令请求超时，无法获取到返回结果: "+str(cmd_ins.request))
		
		
class MiraiRequestInstance:
	extends RefCounted
	
	signal request_finished
	var request = null
	var result = null
	var sync_id = null

	func get_result():
		return result
