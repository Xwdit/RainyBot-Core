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
	
	
func reply(msg,quote:bool=false,_at:bool=false,timeout:float=-INF)->BotRequestResult:
	var _chain = []
	if msg is String:
		_chain.append(BotCodeMessage.init(msg).get_metadata())
	elif msg is Message:
		_chain.append(msg.get_metadata())
	elif msg is MessageChain:
		_chain = msg.get_metadata()
	elif msg is Array:
		_chain = MessageChain.init(msg).get_metadata()
	var _req_dic = {
		"target":data_dic.sender.id,
		"messageChain":_chain,
		"quote":get_message_chain().get_message_id() if quote else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendFriendMessage",null,_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
