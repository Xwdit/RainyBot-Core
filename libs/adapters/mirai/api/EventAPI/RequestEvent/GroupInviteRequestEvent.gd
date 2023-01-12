extends RequestEvent


class_name GroupInviteRequestEvent


enum RespondType{
	ACCEPT,
	REFUSE
}


var data_dic:Dictionary = {
	"type": "BotInvitedJoinGroupRequestEvent",
	"eventId": 0,
	"fromId": 0,
	"groupId": 0,
	"groupName": "",
	"nick": "",
	"message": ""
}


static func init_meta(dic:Dictionary)->GroupInviteRequestEvent:
	if !dic.is_empty() and dic.has("type"):
		var ins:GroupInviteRequestEvent = GroupInviteRequestEvent.new()
		ins.data_dic = dic
		return ins
	else:
		return null


func get_group_name()->String:
	return data_dic.groupName
	
	
func respond(respond_type:int,msg:String="",timeout:float=-INF)->BotRequestResult:
	var _req_dic:Dictionary = {
		"eventId":get_event_id(),
		"fromId":get_sender_id(),
		"groupId":get_group_id(),
		"operate":respond_type,
		"message":msg
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("resp_botInvitedJoinGroupRequestEvent","",_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
