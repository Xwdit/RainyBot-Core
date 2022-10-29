extends GroupEvent


class_name GroupAllowAnonyChatEvent


var data_dic:Dictionary = {
	"type": "GroupAllowAnonymousChatEvent",
	"origin": false,
	"current": false,
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


static func init_meta(dic:Dictionary)->GroupAllowAnonyChatEvent:
	var ins:GroupAllowAnonyChatEvent = GroupAllowAnonyChatEvent.new()
	ins.data_dic = dic
	return ins


func get_origin_state()->bool:
	return data_dic.origin
	
	
func get_current_state()->bool:
	return data_dic.current
	
	
func get_operator()->GroupMember:
	return GroupMember.init_meta(data_dic.operator)
	
	
func get_group()->Group:
	return Group.init_meta(data_dic.group)
