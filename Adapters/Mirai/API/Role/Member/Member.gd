extends MemberAPI


class_name Member


enum Role{
	FRIEND,
	STRANGER
}


var data_dic:Dictionary = {
	"id":-1,
	"nickname":"",
	"remark":""
}

var member_role:= Role.FRIEND


static func init(member_id:int,role:int=Role.FRIEND)->Member:
	var ins:Member = Member.new()
	var dic:Dictionary = ins.data_dic
	dic.id = member_id
	ins.member_role = role
	return ins
	

static func init_meta(dic:Dictionary,role:int=Role.FRIEND)->Member:
	var ins:Member = Member.new()
	ins.data_dic = dic
	ins.member_role = role
	return ins


func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary):
	data_dic = dic


func get_role()->int:
	return member_role
	
	
func set_role(role:int):
	member_role = role


func get_id()->int:
	return data_dic.id


func get_name()->String:
	return data_dic.nickname
	
	
func get_remark()->String:
	return data_dic.remark
	
	
func get_profile()->MemberProfile:
	var _req_dic = {
		"target":get_id(),
	}
	var _result:Dictionary = await MiraiAdapter.send_bot_request("friendProfile",null,_req_dic)
	var _ins:MemberProfile = MemberProfile.init_meta(_result)
	return _ins


func send_message(msg:Message,quote_msgid:int=-1)->BotRequestResult:
	var _req_dic = {
		"target":get_id(),
		"messageChain":[msg.get_metadata()],
		"quote":quote_msgid if quote_msgid != -1 else null
	}
	var _result:Dictionary = await MiraiAdapter.send_bot_request("sendFriendMessage",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func send_message_chain(msg_chain:MessageChain,quote_msgid:int=-1)->BotRequestResult:
	var _req_dic = {
		"target":get_id(),
		"messageChain":msg_chain.get_metadata(),
		"quote":quote_msgid if quote_msgid != -1 else null
	}
	var _result:Dictionary = await MiraiAdapter.send_bot_request("sendFriendMessage",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func send_nudge()->BotRequestResult:
	var _req_dic = {
		"target":get_id(),
		"subject":get_id(),
		"kind":"Friend" if member_role == Role.FRIEND else "Stranger"
	}
	var _result:Dictionary = await MiraiAdapter.send_bot_request("sendNudge",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func delete()->BotRequestResult:
	var _req_dic = {
		"target":get_id()
	}
	var _result:Dictionary = await MiraiAdapter.send_bot_request("deleteFriend",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins