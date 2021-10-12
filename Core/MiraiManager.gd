extends Node

# Our WebSocketClient instance
var _client = WebSocketClient.new()
var processing_command:Dictionary = {}

func _ready():
	add_to_group("command")
	var usages = [
		"mirai status - 获取与Mirai框架的连接状态",
		"mirai command <命令> - 向Mirai框架发送命令并显示回调(不支持额外参数)",
	]
	CommandManager.register_command("mirai",true,usages,"RainyBot-Core")

func _command_mirai(args:Array):
	match args[0]:
		"status":
			print("当前连接状态:",is_connected_to_mirai())
			print("连接地址:",ConfigManager.get_ws_address(ConfigManager.loaded_config))
		"command":
			if args.size() > 1:
				var cmd:MiraiCommandInstance = send_command(args[1])
				if is_instance_valid(cmd):
					yield(cmd,"request_finished")
					print("收到回调: ",cmd.get_result())
					cmd.finish()

func connect_to_mirai(ws_url):
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")

	# Initiate connection to the given URL.
	print("正在尝试连接到Mirai框架中，连接地址: ",ws_url)
	var err = _client.connect_to_url(ws_url)
	if err != OK:
		printerr("无法连接到Mirai框架，请检查配置是否有误")
		set_process(false)

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("到Mirai框架的连接已被关闭，若非人为请检查配置是否有误")
	set_process(false)

func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("成功与Mirai框架进行通信，正在等待响应...")
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	_client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)

func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var data = parse_json(_client.get_peer(1).get_packet().get_string_from_utf8())
	if processing_command.has(int(data["syncId"])):
		_parse_command_result(data)
	elif data["data"].has("type"):
		_parse_event(data)
	elif data["data"].has("session"):
		print("成功连接至Mirai框架!开始加载插件.....")
		PluginManager.reload_plugins()

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()

func _parse_event(event_dic:Dictionary):
	var event_name:String = event_dic["data"]["type"]
	if DataManager.message_event_has_name(event_name):
		get_tree().call_group("message_event","_event_"+event_name,event_dic["data"])
	elif DataManager.bot_event_has_name(event_name):
		get_tree().call_group("bot_event","_event_"+event_name,event_dic["data"])

func _parse_command_result(result:Dictionary):
	var sync_id = int(result["syncId"])
	if processing_command.has(sync_id):
		var cmd:MiraiCommandInstance = processing_command[sync_id]
		cmd.result = result["data"]
		cmd.emit_signal("request_finished")

func _tick_command_timeout(cmd_ins:MiraiCommandInstance,timeout:float):
	yield(get_tree().create_timer(timeout),"timeout")
	if is_instance_valid(cmd_ins) && cmd_ins.result == null:
		cmd_ins.emit_signal("request_finished")
		printerr("指令请求超时，无法获取到返回结果: ",cmd_ins.request)

func send_request_dic(request_dic:Dictionary):
	print("正在发送请求到Mirai框架：", request_dic)
	_client.get_peer(1).put_packet(to_json(request_dic).to_utf8())

func send_command(command,sub_command=null,content={},timeout:float=20):
	if !is_connected_to_mirai():
		printerr("未连接到Mirai框架，指令发送失败: ",command,sub_command,content)
		return null
	var sync_id = randi()
	while processing_command.has(sync_id):
		sync_id = randi()
	var request = {"syncId":sync_id,"command":command,"subCommand":sub_command,"content":content}
	print("正在发送指令请求到Mirai框架：", request)
	var cmd = MiraiCommandInstance.new()
	cmd.sync_id = sync_id
	cmd.request = request
	processing_command[sync_id] = cmd
	send_request_dic(request)
	_tick_command_timeout(cmd,timeout)
	return cmd

func is_connected_to_mirai():
	return _client.get_peer(1).is_connected_to_host()
