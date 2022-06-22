extends RequestEvent


class_name NewFriendRequestEvent


enum RespondType{
	ACCEPT,
	REFUSE,
	REFUSE_BLACKLIST
}


var data_dic:Dictionary = {
	"type": "NewFriendRequestEvent",
	"eventId": 0,
	"fromId": 0,
	"groupId": 0,
	"nick": "",
	"message": ""
}


static func init_meta(dic:Dictionary)->NewFriendRequestEvent:
	var ins:NewFriendRequestEvent = NewFriendRequestEvent.new()
	ins.data_dic = dic
	return ins
	
	
func respond(respond_type:int,msg:String="",timeout:float=-INF)->BotRequestResult:
	var _req_dic = {
		"eventId":get_event_id(),
		"fromId":get_sender_id(),
		"groupId":get_group_id(),
		"operate":respond_type,
		"message":msg
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("resp_newFriendRequestEvent",null,_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
