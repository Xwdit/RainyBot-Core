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
	var ins:OtherClientMessageEvent = OtherClientMessageEvent.new()
	ins.data_dic = dic
	return ins


func get_sender()->OtherClient:
	return OtherClient.init_meta(data_dic.sender)
	
	
func get_message_chain()->MessageChain:
	return MessageChain.init_meta(data_dic.messageChain)
	
	
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
	
