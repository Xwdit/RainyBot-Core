extends MessageEvent


class_name GroupMessageEvent


var data_dic:Dictionary = {
	"type": "GroupMessage",
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


static func init_meta(dic:Dictionary)->GroupMessageEvent:
	var ins:GroupMessageEvent = GroupMessageEvent.new()
	ins.data_dic = dic
	return ins


func get_sender()->GroupMember:
	return GroupMember.init_meta(data_dic.sender)


func get_group()->Group:
	return Group.init_meta(data_dic.sender.group)
	
	
func reply(msg:Message,quote:bool=false,at:bool=false)->BotRequestResult:
	var _req_dic = {
		"target":data_dic.sender.group.id,
		"messageChain":[AtMessage.init(data_dic.sender.id).get_metadata(),TextMessage.init(" ").get_metadata(),msg.get_metadata()] if at else [msg.get_metadata()],
		"quote":get_message_chain().get_message_id() if quote else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendGroupMessage",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
	
	
func reply_chain(msg_chain:MessageChain,quote:bool=false)->BotRequestResult:
	var _req_dic = {
		"target":data_dic.sender.group.id,
		"messageChain":msg_chain.get_metadata(),
		"quote":get_message_chain().get_message_id() if quote else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendGroupMessage",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func recall()->BotRequestResult:
	return await get_message_chain().recall()
	

func is_at_bot()->bool:
	return get_message_chain().is_at_bot()
