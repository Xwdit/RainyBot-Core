extends GroupAPI


class_name Group


var data_dic:Dictionary = {
	"id":-1,
	"name":"",
	"permission":"MEMBER"
}


static func init(group_id:int)->Group:
	var ins:Group = Group.new()
	var dic:Dictionary = ins.data_dic
	dic.id = group_id
	return ins
	

static func init_meta(dic:Dictionary)->Group:
	var ins:Group = Group.new()
	if !dic.is_empty():
		ins.data_dic = dic
	return ins


func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary)->void:
	data_dic = dic


func get_name()->String:
	return data_dic.name


func get_id()->int:
	return data_dic.id


func get_bot_permission()->int:
	return BotAdapter.parse_permission_text(data_dic.permission)


func get_avatar_url()->String:
	return "https://p.qlogo.cn/gh/%s/%s/0"% get_id()


func get_member(member_id:int,timeout:float=-INF)->GroupMember:
	var _req_dic:Dictionary = {
		"target":get_id(),
		"memberId":member_id
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("memberInfo","get",_req_dic,timeout)
	var _ins:GroupMember = GroupMember.init_meta(_result)
	return _ins


func get_member_list(timeout:float=-INF)->GroupMemberList:
	var _req_dic:Dictionary = {
		"target":get_id()
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("memberList","",_req_dic,timeout)
	var _arr:Array = _result.get("data",[])
	var _ins:GroupMemberList = GroupMemberList.init_meta(_arr)
	return _ins


func get_member_profile(member_id:int,timeout:float=-INF)->MemberProfile:
	var _req_dic:Dictionary = {
		"target":get_id(),
		"memberId":member_id
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("memberProfile","",_req_dic,timeout)
	var _ins:MemberProfile = MemberProfile.init_meta(_result)
	return _ins


func toggle_mute_all(enabled:bool,timeout:float=-INF)->BotRequestResult:
	var _req_dic:Dictionary = {
		"target":get_id()
	}
	var _result:Dictionary
	if enabled:
		_result = await BotAdapter.send_bot_request("muteAll","",_req_dic,timeout)
	else:
		_result = await BotAdapter.send_bot_request("unmuteAll","",_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
	
	
func get_group_config(timeout:float=-INF)->GroupConfig:
	var _req_dic:Dictionary = {
		"target":get_id()
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("groupConfig","get",_req_dic,timeout)
	var _ins:GroupConfig = GroupConfig.init_meta(_result)
	return _ins


func set_group_config(config:GroupConfig,timeout:float=-INF)->BotRequestResult:
	var _req_dic:Dictionary = {
		"target":get_id(),
		"config":config.get_metadata()
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("groupConfig","update",_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func send_message(msg,quote_msgid:int=-1,timeout:float=-INF)->BotRequestResult:
	var _chain:Array = []
	if msg is String:
		_chain.append(BotCodeMessage.init(msg).get_metadata())
	elif msg is Message:
		_chain.append(msg.get_metadata())
	elif msg is MessageChain:
		_chain = msg.get_metadata()
	elif msg is Array:
		_chain = MessageChain.init(msg).get_metadata()
	var _req_dic:Dictionary = {
		"target":get_id(),
		"messageChain":_chain,
		"quote":quote_msgid if quote_msgid != -1 else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendGroupMessage","",_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
	
	
func send_nudge(member_id:int,timeout:float=-INF)->BotRequestResult:
	var _req_dic:Dictionary = {
		"target":member_id,
		"subject":get_id(),
		"kind":"Group"
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendNudge","",_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func publish_announce(announce:GroupAnnounce,timeout:float=-INF)->GroupAnnounceInfoList:
	if !is_instance_valid(announce):
		GuiManager.console_print_error("要发送的群公告实例无效，因此无法进行发送!")
		return
	if announce.get_content() == "":
		GuiManager.console_print_error("要发送的群公告实例内容不能为空，因此无法进行发送!")
		return
	var _req_dic:Dictionary = announce.get_metadata().duplicate()
	_req_dic["target"]=get_id()
	var _result:Dictionary = await BotAdapter.send_bot_request("anno_publish","",_req_dic,timeout)
	var _arr:Array = _result.get("data",[])
	var _ins:GroupAnnounceInfoList = GroupAnnounceInfoList.init_meta(_arr)
	return _ins


func delete_announce(announce_id:int,timeout:float=-INF)->BotRequestResult:
	var _req_dic:Dictionary = {
		"id":get_id(),
		"fid":announce_id
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("anno_delete","",_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
	
	
func get_announce_list(page_num:int=0,per_page_size:int=10,timeout:float=-INF)->GroupAnnounceInfoList:
	var _req_dic:Dictionary = {
		"id":get_id(),
		"offset":page_num,
		"size":per_page_size
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("anno_delete","",_req_dic,timeout)
	var _arr:Array = _result.get("data",[])
	var _ins:GroupAnnounceInfoList = GroupAnnounceInfoList.init_meta(_arr)
	return _ins


func quit(timeout:float=-INF)->BotRequestResult:
	var _req_dic:Dictionary = {
		"target":get_id()
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("quit","",_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func set_essence_message(msg_id:int,timeout:float=-INF)->BotRequestResult:
	var _req_dic:Dictionary = {
		"messageId":msg_id,
		"target":get_id()
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("setEssence","",_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func recall_message(msg_id:int,timeout:float=-INF)->BotRequestResult:
	var _req_dic:Dictionary = {
		"messageId":msg_id,
		"target":get_id()
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("recall","",_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func get_cache_message(msg_id:int,timeout:float=-INF)->CacheMessage:
	var _req_dic:Dictionary = {
		"messageId":msg_id,
		"target":get_id()
	}
	var _result_dic:Dictionary = await BotAdapter.send_bot_request("messageFromId","",_req_dic,timeout)
	var ins:CacheMessage = CacheMessage.init_meta(_result_dic.get("data",{}))
	return ins
