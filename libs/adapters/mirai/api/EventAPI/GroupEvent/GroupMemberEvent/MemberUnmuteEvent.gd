extends GroupMemberEvent


class_name MemberUnmuteEvent


var data_dic:Dictionary = {
	"type": "MemberMuteEvent",
	"origin": "",
	"current": "",
	"member": {
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
	},
	"operator":null
}


static func init_meta(dic:Dictionary)->MemberUnmuteEvent:
	if !dic.is_empty() and dic.has("type"):
		var ins:MemberUnmuteEvent = MemberUnmuteEvent.new()
		ins.data_dic = dic
		return ins
	else:
		return null


func get_member()->GroupMember:
	return GroupMember.init_meta(data_dic.member)


func get_operator()->GroupMember:
	return GroupMember.init_meta(data_dic.operator)

	
func get_group()->Group:
	return Group.init_meta(data_dic.member.group)
