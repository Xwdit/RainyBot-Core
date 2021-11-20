extends MessageEvent


class_name StrangerMessageEvent


var data_dic:Dictionary = {
	"type": "StrangerMessage",
	"sender": {
		"id": -1,
		"nickname": "",
		"remark": ""
	},
	"messageChain": []
}


static func init_meta(dic:Dictionary)->StrangerMessageEvent:
	var ins:StrangerMessageEvent = StrangerMessageEvent.new()
	ins.data_dic = dic
	return ins


func get_sender()->Member:
	return Member.init_meta(data_dic.sender,Member.Role.STRANGER)
	
	
func reply(msg:Message,quote:bool=false)->BotRequestResult:
	var _req_dic = {
		"target":data_dic.sender.id,
		"messageChain":[msg.get_metadata()],
		"quote":get_message_chain().get_message_id() if quote else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendFriendMessage",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
	
	
func reply_chain(msg_chain:MessageChain,quote:bool=false)->BotRequestResult:
	var _req_dic = {
		"target":data_dic.sender.id,
		"messageChain":msg_chain.get_metadata(),
		"quote":get_message_chain().get_message_id() if quote else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendFriendMessage",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
	
