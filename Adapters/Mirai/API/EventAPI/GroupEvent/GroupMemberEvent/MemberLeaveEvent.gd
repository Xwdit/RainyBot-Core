extends GroupMemberEvent


class_name MemberLeaveEvent


enum ReasonType{
	QUIT,
	KICK
}


var data_dic:Dictionary = {
	"type": "MemberLeaveEvent",
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

var event_reason:int = ReasonType.QUIT


static func init_meta(dic:Dictionary,reason:int)->MemberLeaveEvent:
	var ins:MemberLeaveEvent = MemberLeaveEvent.new()
	ins.data_dic = dic
	ins.event_reason = reason
	return ins


func get_member()->GroupMember:
	return GroupMember.init_meta(data_dic.member)
	
	
func get_operator()->GroupMember:
	return GroupMember.init_meta(data_dic.operator)
	
	
func get_group()->Group:
	return Group.init_meta(data_dic.member.group)
	
	
func get_reason_type()->int:
	return event_reason
