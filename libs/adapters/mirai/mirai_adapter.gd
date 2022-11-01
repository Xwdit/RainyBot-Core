extends Node


var mirai_client:MiraiClient = MiraiClient.new()
var mirai_loader:MiraiLoader = MiraiLoader.new()
var mirai_config_manager:MiraiConfigManager = MiraiConfigManager.new()

var group_message_count:int = 0
var private_message_count:int = 0
var sent_message_count:int = 0


func start()->void:
	GuiManager.console_print_warning("正在加载模块: Mirai-Adapter | 版本: %s | 作者: Xwdit" % RainyBotCore.VERSION)
	add_to_group("console_command_mirai")
	var usages:Array = [
		"mirai status - 获取与Mirai框架的连接状态",
		"mirai restart - 在Mirai主进程被关闭后重新启动Mirai框架",
		"mirai command <命令> - 向Mirai框架发送命令并显示回调(不支持额外参数)",
	]
	CommandManager.register_console_command("mirai",true,usages,"Mirai-Adapter",false)
	mirai_config_manager.connect("config_loaded",_mirai_config_loaded)
	mirai_config_manager.name = "MiraiConfigManager"
	mirai_client.name = "MiraiClient"
	mirai_loader.name = "MiraiLoader"
	add_child(mirai_config_manager,true)
	add_child(mirai_client,true)
	add_child(mirai_loader,true)
	mirai_config_manager.init_config()


func _mirai_config_loaded()->void:
	mirai_client.connect_to_mirai(get_ws_url())


func _call_console_command(_cmd:String,args:Array)->void:
	match args[0]:
		"status":
			GuiManager.console_print_text("当前协议后端连接状态: "+("已连接" if is_bot_connected() else "未连接"))
			GuiManager.console_print_text("连接地址: "+get_ws_url())
		"restart":
			mirai_loader.load_mirai()
		"command":
			if args.size() > 1:
				var result:Dictionary = await send_bot_request(args[1])
				GuiManager.console_print_text("收到回调: "+str(result))


func get_ws_url()->String:
	return mirai_config_manager.get_ws_address(mirai_config_manager.loaded_config)


func is_bot_connected()->bool:
	return mirai_client.is_bot_connected()


func get_bot_id()->int:
	return mirai_config_manager.get_bot_id()
	
	
func send_bot_request(_command:String,_sub_command:String="",_content:Dictionary={},_timeout:float=-INF)->Dictionary:
	if _timeout <= -INF and mirai_config_manager.get_request_timeout() > 0.0:
		_timeout=mirai_config_manager.get_request_timeout()
	if _command.begins_with("send") and _command.ends_with("Message"):
		sent_message_count += 1
	return await mirai_client.send_bot_request(_command,_sub_command,_content,_timeout)
			
			
func parse_permission_text(perm:String)->int:
	match perm:
		"ADMINISTRATOR":
			return GroupMember.Permission.ADMINISTRATOR
		"OWNER":
			return GroupMember.Permission.OWNER
	return GroupMember.Permission.MEMBER
			
			
func parse_message_dic(dic:Dictionary)->Message:
	if !dic.has("type"):
		return null
	match dic.type:
		"Source":
			return SourceMessage.init_meta(dic)
		"Quote":
			return QuoteMessage.init_meta(dic)
		"At":
			return AtMessage.init_meta(dic)
		"AtAll":
			return AtAllMessage.init_meta(dic)
		"Face":
			return FaceMessage.init_meta(dic)
		"MarketFace":
			return MarketFaceMessage.init_meta(dic)
		"Plain":
			return TextMessage.init_meta(dic)
		"Image":
			return ImageMessage.init_meta(dic)
		"FlashImage":
			return FlashImageMessage.init_meta(dic)
		"Voice":
			return VoiceMessage.init_meta(dic)
		"Xml":
			return XmlMessage.init_meta(dic)
		"Json":
			return JsonMessage.init_meta(dic)
		"App":
			return AppMessage.init_meta(dic)
		"Poke":
			return PokeMessage.init_meta(dic)
		"Dice":
			return DiceMessage.init_meta(dic)
		"MusicShare":
			return MusicShareMessage.init_meta(dic)
		"Forward":
			return ForwardMessage.init_meta(dic)
		"File":
			return FileMessage.init_meta(dic)
		"MiraiCode":
			return BotCodeMessage.init_meta(dic)
	return null


func parse_event(result_dic:Dictionary)->void:
	var ins:Event
	var event_dic:Dictionary = result_dic["data"]
	var event_name:String = event_dic["type"]
	match event_name:
		"FriendMessage":
			ins = FriendMessageEvent.init_meta(event_dic)
			private_message_count += 1
		"GroupMessage":
			ins = GroupMessageEvent.init_meta(event_dic)
			group_message_count += 1
		"TempMessage":
			ins = TempMessageEvent.init_meta(event_dic)
			private_message_count += 1
		"StrangerMessage":
			ins = StrangerMessageEvent.init_meta(event_dic)
			private_message_count += 1
		"OtherClientMessage":
			ins = OtherClientMessageEvent.init_meta(event_dic)
			private_message_count += 1
		"NudgeEvent":
			ins = NudgeEvent.init_meta(event_dic)
		"BotOnlineEvent":
			ins = BotOnlineEvent.init_meta(event_dic)
		"BotOfflineEventActive":
			ins = BotOfflineEvent.init_meta(event_dic,BotOfflineEvent.ReasonType.ACTIVE)
		"BotOfflineEventForce":
			ins = BotOfflineEvent.init_meta(event_dic,BotOfflineEvent.ReasonType.FORCE)
		"BotOfflineEventDropped":
			ins = BotOfflineEvent.init_meta(event_dic,BotOfflineEvent.ReasonType.DROPPED)
		"BotReloginEvent":
			ins = BotReloginEvent.init_meta(event_dic)
		"FriendInputStatusChangedEvent":
			ins = FriendInputStatusChangeEvent.init_meta(event_dic)
		"FriendNickChangedEvent":
			ins = FriendNickChangeEvent.init_meta(event_dic)
		"FriendRecallEvent":
			ins = FriendRecallEvent.init_meta(event_dic)
		"BotGroupPermissionChangeEvent":
			ins = BotPermChangeEvent.init_meta(event_dic)
		"BotMuteEvent":
			ins = BotMuteEvent.init_meta(event_dic)
		"BotUnmuteEvent":
			ins = BotUnmuteEvent.init_meta(event_dic)
		"BotJoinGroupEvent":
			ins = BotJoinGroupEvent.init_meta(event_dic)
		"BotLeaveEventActive":
			ins = BotLeaveGroupEvent.init_meta(event_dic,BotLeaveGroupEvent.ReasonType.ACTIVE)
		"BotLeaveEventKick":
			ins = BotLeaveGroupEvent.init_meta(event_dic,BotLeaveGroupEvent.ReasonType.KICK)
		"BotLeaveEventDisband":
			ins = BotLeaveGroupEvent.init_meta(event_dic,BotLeaveGroupEvent.ReasonType.DISBAND)
		"GroupRecallEvent":
			ins = GroupRecallEvent.init_meta(event_dic)
		"GroupNameChangeEvent":
			ins = GroupNameChangeEvent.init_meta(event_dic)
		"GroupEntranceAnnouncementChangeEvent":
			ins = GroupAnnounceChangeEvent.init_meta(event_dic)
		"GroupMuteAllEvent":
			ins = GroupMuteAllEvent.init_meta(event_dic)
		"GroupAllowAnonymousChatEvent":
			ins = GroupAllowAnonyChatEvent.init_meta(event_dic)
		"GroupAllowConfessTalkEvent":
			ins = GroupAllowConfessTalkEvent.init_meta(event_dic)
		"GroupAllowMemberInviteEvent":
			ins = GroupAllowInviteEvent.init_meta(event_dic)
		"MemberJoinEvent":
			ins = MemberJoinEvent.init_meta(event_dic)
		"MemberLeaveEventKick":
			ins = MemberLeaveEvent.init_meta(event_dic,MemberLeaveEvent.ReasonType.KICK)
		"MemberLeaveEventQuit":
			ins = MemberLeaveEvent.init_meta(event_dic,MemberLeaveEvent.ReasonType.QUIT)
		"MemberMuteEvent":
			ins = MemberMuteEvent.init_meta(event_dic)
		"MemberUnmuteEvent":
			ins = MemberUnmuteEvent.init_meta(event_dic)
		"MemberHonorChangeEvent":
			ins = MemberHonorChangeEvent.init_meta(event_dic)
		"MemberCardChangeEvent":
			ins = MemberNameChangeEvent.init_meta(event_dic)
		"MemberPermissionChangeEvent":
			ins = MemberPermChangeEvent.init_meta(event_dic)
		"MemberSpecialTitleChangeEvent":
			ins = MemberTitleChangeEvent.init_meta(event_dic)
		"NewFriendRequestEvent":
			ins = NewFriendRequestEvent.init_meta(event_dic)
		"MemberJoinRequestEvent":
			ins = MemberJoinRequestEvent.init_meta(event_dic)
		"BotInvitedJoinGroupRequestEvent":
			ins = GroupInviteRequestEvent.init_meta(event_dic)
		"OtherClientOnlineEvent":
			ins = OtherClientOnlineEvent.init_meta(event_dic)
		"OtherClientOfflineEvent":
			ins = OtherClientOfflineEvent.init_meta(event_dic)
		_:
			return
			
	PluginManager.call_event(ins)


func get_meta_message_chain(msg)->Array:
	var _chain:Array = []
	if msg is String:
		_chain.append(BotCodeMessage.init(msg).get_metadata())
	elif msg is Message:
		_chain.append(msg.get_metadata())
	elif msg is MessageChain:
		_chain = msg.get_metadata()
	elif msg is Array:
		_chain = MessageChain.init(msg).get_metadata()
	return _chain


## 获取当前机器人账号的好友列表，需要与await关键词配合使用
func get_friend_list(timeout:float=-INF)->MemberList:
	var _result:Dictionary = await send_bot_request("friendList","",{},timeout)
	var _arr:Array = _result.get("data",[])
	var _ins:MemberList = MemberList.init_meta(_arr)
	return _ins
	

## 获取当前机器人账号的群组列表，需要与await关键词配合使用
func get_group_list(timeout:float=-INF)->GroupList:
	var _result:Dictionary = await send_bot_request("groupList","",{},timeout)
	var _arr:Array = _result.get("data",[])
	var _ins:GroupList = GroupList.init_meta(_arr)
	return _ins


## 获取当前机器人账号的资料卡，需要与await关键词配合使用
func get_profile(timeout:float=-INF)->MemberProfile:
	var _result:Dictionary = await send_bot_request("botProfile","",{},timeout)
	var _ins:MemberProfile = MemberProfile.init_meta(_result)
	return _ins
	
	
func reply_temp_message(event:TempMessageEvent,msg,quote:bool=false,timeout:float=-INF)->BotRequestResult:
	var _chain:Array = get_meta_message_chain(msg)
	var _req_dic:Dictionary = {
		"qq":event.data_dic.sender.id,
		"group":event.data_dic.sender.group.id,
		"messageChain":_chain,
		"quote":event.get_message_chain().get_message_id() if quote else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendTempMessage","",_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func reply_member_message(event:MessageEvent,msg,quote:bool=false,timeout:float=-INF)->BotRequestResult:
	var _chain:Array = get_meta_message_chain(msg)
	var _req_dic:Dictionary = {
		"target":event.data_dic.sender.id,
		"messageChain":_chain,
		"quote":event.get_message_chain().get_message_id() if quote else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendFriendMessage","",_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func reply_friend_message(event:FriendMessageEvent,msg,quote:bool=false,timeout:float=-INF)->BotRequestResult:
	return await reply_member_message(event,msg,quote,timeout)
	
	
func reply_stranger_message(event:StrangerMessageEvent,msg,quote:bool=false,timeout:float=-INF)->BotRequestResult:
	return await reply_member_message(event,msg,quote,timeout)


func reply_other_client_message(event:OtherClientMessageEvent,msg,quote:bool=false,timeout:float=-INF)->BotRequestResult:
	return await reply_member_message(event,msg,quote,timeout)


func reply_group_message(event:GroupMessageEvent,msg,quote:bool=false,at:bool=false,timeout:float=-INF)->BotRequestResult:
	var _chain:Array = get_meta_message_chain(msg)
	if at:
		var _arr:Array = [AtMessage.init(event.data_dic.sender.id).get_metadata(),TextMessage.init(" ").get_metadata()]
		_arr.append_array(_chain)
		_chain = _arr
	var _req_dic:Dictionary = {
		"target":event.data_dic.sender.group.id,
		"messageChain":_chain,
		"quote":event.get_message_chain().get_message_id() if quote else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendGroupMessage","",_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
