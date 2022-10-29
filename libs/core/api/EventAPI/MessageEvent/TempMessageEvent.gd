extends MessageEvent


class_name TempMessageEvent


var data_dic:Dictionary = {
	"type": "TempMessage",
	"sender": {
		"id": 0,
		"memberName": "",
		"specialTitle": "",
		"permission": "MEMBER",
		"joinTimestamp": 0,
		"lastSpeakTimestamp": 0,
		"muteTimeRemaining": 0,
		"group": {
			"id": 0,
			"name": "",
			"permission": "MEMBER",
		},
	},
	"messageChain": []
}


static func init_meta(dic:Dictionary)->TempMessageEvent:
	var ins:TempMessageEvent = TempMessageEvent.new()
	ins.data_dic = dic
	return ins


func get_sender()->GroupMember:
	return GroupMember.init_meta(data_dic.sender)


func get_group()->Group:
	return Group.init_meta(data_dic.sender.group)
	

func get_group_id()->int:
	return get_group().get_id()

	
func reply(msg,quote:bool=false,_at:bool=false,timeout:float=-INF)->BotRequestResult:
	var _chain:Array = []
	if msg is String:
		_chain.append(BotCodeMessage.init(msg).get_metadata())
	elif msg is Message:
		_chain.append(msg.get_metadata())
	elif msg is MessageChain:
		_chain = msg.get_metadata()
	elif msg is Array:
		_chain = MessageChain.init(msg).get_metadata()
	var _req_dic:Dictionary = {
		"qq":data_dic.sender.id,
		"group":data_dic.sender.group.id,
		"messageChain":_chain,
		"quote":get_message_chain().get_message_id() if quote else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendTempMessage","",_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
