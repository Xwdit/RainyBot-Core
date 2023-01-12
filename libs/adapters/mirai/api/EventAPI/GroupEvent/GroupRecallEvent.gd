extends GroupEvent


class_name GroupRecallEvent


var data_dic:Dictionary = {
	"type": "GroupRecallEvent",
	"authorId": 0,
	"messageId": 0,
	"time": 0,
	"group": {
		"id": 0,
		"name": "",
		"permission": ""
	},
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


static func init_meta(dic:Dictionary)->GroupRecallEvent:
	if !dic.is_empty() and dic.has("type"):
		var ins:GroupRecallEvent = GroupRecallEvent.new()
		ins.data_dic = dic
		return ins
	else:
		return null


func get_sender_id()->int:
	return data_dic.authorId
	
	
func get_message_id()->int:
	return data_dic.messageId
	
	
func get_message_timestamp()->int:
	return data_dic.time
	
	
func get_operator()->GroupMember:
	return GroupMember.init_meta(data_dic.operator)
	
	
func get_group()->Group:
	return Group.init_meta(data_dic.group)
