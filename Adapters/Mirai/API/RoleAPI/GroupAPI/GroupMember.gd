extends GroupAPI


class_name GroupMember


enum Permission{
	MEMBER,
	ADMINISTRATOR,
	OWNER
}


var data_dic:Dictionary = {
	"id":-1,
	"memberName":"",
	"permission":"MEMBER",
	"specialTitle":"",
	"joinTimestamp":-1,
	"lastSpeakTimestamp":-1,
	"muteTimeRemaining":-1,
	"group":{
		"id":-1,
		"name":"",
		"permission":"MEMBER"
	}
}


static func init(g_id:int,m_id:int)->GroupMember:
	var ins:GroupMember = GroupMember.new()
	var dic:Dictionary = ins.data_dic
	dic.id = m_id
	dic.group.id = g_id
	return ins


static func init_meta(dic:Dictionary)->GroupMember:
	var ins:GroupMember = GroupMember.new()
	ins.data_dic = dic
	return ins


func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary):
	data_dic = dic


func get_id()->int:
	return data_dic.id


func get_name()->String:
	return data_dic.memberName
	
	
func get_special_title()->String:
	return data_dic.specialTitle
	
	
func get_permission()->int:
	return BotAdapter.parse_permission_text(data_dic.permission)
	
	
func is_permission(perm:int)->bool:
	return perm == get_permission()
	
	
func get_join_timestamp()->int:
	return data_dic.joinTimestamp
	
	
func get_last_speak_timestamp()->int:
	return data_dic.lastSpeakTimestamp
	
	
func get_mute_time_remaining()->int:
	return data_dic.muteTimeRemaining


func get_group()->Group:
	return Group.init_meta(data_dic.group)


func change_name(new_name:String)->BotRequestResult:
	var _req_dic = {
		"target":data_dic.group.id,
		"memberId":get_id(),
		"info":{"name":new_name}
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("memberInfo","update",_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
	

func change_special_title(new_title:String)->BotRequestResult:
	var _req_dic = {
		"target":data_dic.group.id,
		"memberId":get_id(),
		"info":{"specialTitle":new_title}
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("memberInfo","update",_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
	
	
func toggle_admin(enabled:bool)->BotRequestResult:
	var _req_dic = {
		"target":data_dic.group.id,
		"memberId":get_id(),
		"assign":enabled
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("memberAdmin","update",_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func kick(message:String="")->BotRequestResult:
	var _req_dic = {
		"target":data_dic.group.id,
		"memberId":get_id(),
		"msg":message
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("kick",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func mute(time:int=1800)->BotRequestResult:
	var _req_dic = {
		"target":data_dic.group.id,
		"memberId":get_id(),
		"time":time
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("mute",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
	
	
func unmute()->BotRequestResult:
	var _req_dic = {
		"target":data_dic.group.id,
		"memberId":get_id(),
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("unmute",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
	
	
func send_message(msg:Message,quote_msgid:int=-1)->BotRequestResult:
	var _req_dic = {
		"qq":get_id(),
		"group":data_dic.group.id,
		"messageChain":[msg.get_metadata()],
		"quote":quote_msgid if quote_msgid != -1 else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendTempMessage",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins	


func send_message_chain(msg_chain:MessageChain,quote_msgid:int=-1)->BotRequestResult:
	var _req_dic = {
		"qq":get_id(),
		"group":data_dic.group.id,
		"messageChain":msg_chain.get_metadata(),
		"quote":quote_msgid if quote_msgid != -1 else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendTempMessage",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func send_nudge()->BotRequestResult:
	var _req_dic = {
		"target":get_id(),
		"subject":get_id(),
		"kind":"Stranger"
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendNudge",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
