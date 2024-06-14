extends MessageEvent


class_name OtherClientMessageEvent


var data_dic:Dictionary = {
	"type": "OtherClientMessage",
	"sender": {
		"id": -1,
		"platform": "MOBILE"
	},
	"messageChain": []
}


static func init_meta(dic:Dictionary)->OtherClientMessageEvent:
	if dic.has("type"):
		var ins:OtherClientMessageEvent = OtherClientMessageEvent.new()
		ins.data_dic = dic
		return ins
	else:
		return null


func get_sender()->OtherClient:
	return OtherClient.init_meta(data_dic.sender)
	
	
func reply(msg,quote:bool=false,_at:bool=false,timeout:float=-INF)->BotRequestResult:
	var _chain:Array = []
	if msg is String or msg is int:
		_chain.append(BotCodeMessage.init(str(msg)).get_metadata())
	elif msg is Message:
		_chain.append(msg.get_metadata())
	elif msg is MessageChain:
		_chain = msg.get_metadata()
	elif msg is Array:
		_chain = MessageChain.init(msg).get_metadata()
	var _req_dic:Dictionary = {
		"target":data_dic.sender.id,
		"messageChain":_chain,
		"quote":get_message_chain().get_message_id() if quote else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendFriendMessage","",_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
	
