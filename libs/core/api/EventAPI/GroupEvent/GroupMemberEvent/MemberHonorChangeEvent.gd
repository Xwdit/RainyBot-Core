extends GroupMemberEvent


class_name MemberHonorChangeEvent


enum ActionType{
	ACHIEVE,
	LOST
}


var data_dic:Dictionary = {
	"type": "MemberHonorChangeEvent",
	"action": "",
	"honor": "",
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
	}
}


static func init_meta(dic:Dictionary)->MemberHonorChangeEvent:
	var ins:MemberHonorChangeEvent = MemberHonorChangeEvent.new()
	ins.data_dic = dic
	return ins


func get_member()->GroupMember:
	return GroupMember.init_meta(data_dic.member)
	
	
func get_group()->Group:
	return Group.init_meta(data_dic.member.group)
	

func get_honor_name()->String:
	return data_dic.honor
	
	
func get_action_type()->int:
	if data_dic.action == "achieve":
		return ActionType.ACHIEVE
	else:
		return ActionType.LOST


func is_action_type(action:int)->bool:
	return action == get_action_type()
