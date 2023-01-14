extends Node


class_name MiraiClient


var _client:WebSocketClient = WebSocketClient.new()
var current_session:String = ""
var processing_command:Dictionary = {}
var first_connected:bool = false
var mirai_connected:bool = false


func _ready()->void:
	_client.connection_closed.connect(_closed)
	_client.connected_to_server.connect(_connected)
	_client.message_received.connect(_on_data)


func connect_to_mirai(ws_url:String)->void:
	GuiManager.console_print_warning("正在尝试连接到Mirai框架中，请稍候... | 连接地址: "+ws_url)
	if BotAdapter.mirai_loader.is_mirai_running():
		var err:int = _client.connect_to_url(ws_url)
		if err:
			GuiManager.console_print_error("无法连接到Mirai框架，请检查配置是否有误")
			GuiManager.console_print_warning("将于10秒后尝试重新连接...")
			await get_tree().create_timer(10).timeout
			connect_to_mirai(ws_url)
		else:
			await get_tree().create_timer(5).timeout
			if _client.get_socket().get_ready_state() == WebSocketPeer.STATE_CONNECTING:
				_client.close()
	else:
		GuiManager.console_print_warning("Mirai进程未在运行中，将在其启动后自动进行连接...")
		GuiManager.mirai_console_print_warning("Mirai进程未在运行中，将在其启动后自动与RainyBot进行连接...")
		await BotAdapter.mirai_loader.mirai_ready
		connect_to_mirai(ws_url)


func disconnect_to_mirai()->void:
	if is_bot_connected():
		_client.close()


func _closed(_was_clean:bool=false)->void:
	if mirai_connected:
		mirai_connected = false
		get_tree().call_group("Plugin","_on_disconnect")
	
	GuiManager.console_print_warning("到Mirai框架的连接已被关闭，若非人为请检查配置是否有误")
	GuiManager.mirai_console_print_warning("到RainyBot的连接已被关闭，若非人为请检查配置是否有误")
	GuiManager.console_print_warning("若Mirai进程被意外关闭或运行异常，请使用命令 mirai restart 来重新启动")
	GuiManager.mirai_console_print_warning("若Mirai进程被意外关闭或运行异常，请使用命令 restart 来重新启动")
	
	if BotAdapter.mirai_loader.is_mirai_running():
		GuiManager.console_print_warning("将于10秒后尝试重新连接...")
		GuiManager.mirai_console_print_warning("将于10秒后尝试重新与RainyBot建立连接...")
		await get_tree().create_timer(10).timeout
	else:
		GuiManager.console_print_warning("Mirai进程未在运行中，将在其启动后自动进行重连...")
		GuiManager.mirai_console_print_warning("Mirai进程未在运行中，将在其启动后自动与RainyBot进行重连...")
		await BotAdapter.mirai_loader.mirai_ready
	connect_to_mirai(BotAdapter.get_ws_url())


func _connected(_proto:String="")->void:
	GuiManager.console_print_success("成功与Mirai框架进行通信，正在等待响应...")
	GuiManager.mirai_console_print_success("成功与RainyBot进行通信，正在等待响应...")


func _on_data(message:String)->void:
	var json:JSON = JSON.new()
	var err:int = json.parse(message)
	if !err:
		var data:Dictionary = json.get_data()
		if data.has("syncId"):
			if processing_command.has(data["syncId"].to_int()):
				_parse_command_result(data)
		if data.has("data"):
			if data["data"].has("type"):
				BotAdapter.parse_event(data)
			if data["data"].has("session"):
				current_session = data["data"].session
				if !first_connected:
					GuiManager.console_print_success("成功连接至Mirai框架!开始加载插件.....")
					GuiManager.mirai_console_print_success("成功连接至RainyBot!")
					PluginManager.reload_plugins()
					first_connected = true
				else:
					GuiManager.console_print_success("成功恢复与Mirai框架的连接!")
					GuiManager.mirai_console_print_success("成功恢复与RainyBot的连接!")
				mirai_connected = true
				get_tree().call_group("Plugin","_on_connect")


func _physics_process(_delta:float)->void:
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
	_client.send(json.stringify(request))
	if timeout > 0.0:
		GuiManager.console_print_warning("本次请求的超时时间为: %s秒"% timeout)
		_tick_command_timeout(cmd,timeout)
	await cmd.request_finished
	processing_command.erase(sync_id)
	return cmd.get_result()


func is_bot_connected()->bool:
	return _client.get_socket().get_ready_state() == WebSocketPeer.STATE_OPEN


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
