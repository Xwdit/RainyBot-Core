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
	ins.data_dic = dic
	return ins


func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary):
	data_dic = dic


func get_name()->String:
	return data_dic.name


func get_id()->int:
	return data_dic.id


func get_bot_permission()->int:
	return BotAdapter.parse_permission_text(data_dic.permission)


func get_member(member_id:int)->GroupMember:
	var _req_dic = {
		"target":get_id(),
		"memberId":member_id
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("memberInfo","get",_req_dic)
	var _ins:GroupMember = GroupMember.init_meta(_result)
	return _ins


func get_member_list()->GroupMemberList:
	var _req_dic = {
		"target":get_id()
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("memberList",null,_req_dic)
	var _arr:Array = _result["data"]
	var _ins:GroupMemberList = GroupMemberList.init_meta(_arr)
	return _ins


func get_member_profile(member_id:int)->MemberProfile:
	var _req_dic = {
		"target":get_id(),
		"memberId":member_id
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("memberProfile",null,_req_dic)
	var _ins:MemberProfile = MemberProfile.init_meta(_result)
	return _ins


func toggle_mute_all(enabled:bool)->BotRequestResult:
	var _req_dic = {
		"target":get_id()
	}
	var _result:Dictionary
	if enabled:
		_result = await BotAdapter.send_bot_request("muteAll",null,_req_dic)
	else:
		_result = await BotAdapter.send_bot_request("unmuteAll",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
	
	
func get_group_config()->GroupConfig:
	var _req_dic = {
		"target":get_id()
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("groupConfig","get",_req_dic)
	var _ins:GroupConfig = GroupConfig.init_meta(_result)
	return _ins


func set_group_config(config:GroupConfig)->BotRequestResult:
	var _req_dic = {
		"target":get_id(),
		"config":config.get_metadata()
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("groupConfig","update",_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func send_message(msg:Message,quote_msgid:int=-1)->BotRequestResult:
	var _req_dic = {
		"target":get_id(),
		"messageChain":[msg.get_metadata()],
		"quote":quote_msgid if quote_msgid != -1 else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendGroupMessage",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func send_message_chain(msg_chain:MessageChain,quote_msgid:int=-1)->BotRequestResult:
	var _req_dic = {
		"target":get_id(),
		"messageChain":msg_chain.get_metadata(),
		"quote":quote_msgid if quote_msgid != -1 else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendGroupMessage",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
	
	
func send_nudge(member_id:int)->BotRequestResult:
	var _req_dic = {
		"target":member_id,
		"subject":get_id(),
		"kind":"Group"
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendNudge",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func quit()->BotRequestResult:
	var _req_dic = {
		"target":get_id()
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("quit",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
