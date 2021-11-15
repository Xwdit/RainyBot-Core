extends RefCounted


class_name Member


var data_dic:Dictionary = {
	"id":-1,
	"nickname":"",
	"remark":""
}


static func init(member_id:int)->Member:
	var ins:Member = Member.new()
	var dic:Dictionary = ins.data_dic
	dic.id = member_id
	return ins
	

static func init_meta(dic:Dictionary)->Member:
	var ins:Member = Member.new()
	ins.data_dic = dic
	return ins


func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary):
	data_dic = dic


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
		"kind":"Friend"
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
