extends GroupBotEvent


class_name BotUnmuteEvent


var data_dic:Dictionary = {
	"type": "BotUnmuteEvent",
	"operator": {
		"id": 0,
		"memberName": "",
		"permission": "",
		"specialTitle":"",
		"joinTimestamp":0,
		"lastSpeakTimestamp":0,
		"muteTimeRemaining":0,
		"group": {
			"id": 0,
			"name": "",
			"permission": ""
		}
	}
}


static func init_meta(dic:Dictionary)->BotUnmuteEvent:
	if !dic.is_empty() and dic.has("type"):
		var ins:BotUnmuteEvent = BotUnmuteEvent.new()
		ins.data_dic = dic
		return ins
	else:
		return null
	

func get_operator()->GroupMember:
	return GroupMember.init_meta(data_dic.operator)
	
	
func get_group()->Group:
	return Group.init_meta(data_dic.operator.group)
