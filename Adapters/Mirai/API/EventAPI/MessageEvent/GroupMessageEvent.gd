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


func get_group_id()->int:
	return get_group().get_id()
	
	
func reply(msg,quote:bool=false,at:bool=false)->BotRequestResult:
	var _chain = []
	if msg is String:
		_chain.append(BotCodeMessage.init(msg).get_metadata())
	elif msg is Message:
		_chain.append(msg.get_metadata())
	elif msg is MessageChain:
		_chain = msg.get_metadata()
	if at:
		var _arr = [AtMessage.init(data_dic.sender.id).get_metadata(),TextMessage.init(" ").get_metadata()]
		_arr.append_array(_chain)
		_chain = _arr
	var _req_dic = {
		"target":data_dic.sender.group.id,
		"messageChain":_chain,
		"quote":get_message_chain().get_message_id() if quote else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendGroupMessage",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func recall()->BotRequestResult:
	return await get_message_chain().recall()
	

func is_at_bot()->bool:
	return get_message_chain().is_at_bot()


func set_essence()->BotRequestResult:
	return await get_message_chain().set_essence()
