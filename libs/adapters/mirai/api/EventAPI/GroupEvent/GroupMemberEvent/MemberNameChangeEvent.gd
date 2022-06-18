extends GroupMemberEvent


class_name MemberNameChangeEvent


var data_dic:Dictionary = {
	"type": "MemberCardChangeEvent",
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
	}
}


static func init_meta(dic:Dictionary)->MemberNameChangeEvent:
	var ins:MemberNameChangeEvent = MemberNameChangeEvent.new()
	ins.data_dic = dic
	return ins


func get_member()->GroupMember:
	return GroupMember.init_meta(data_dic.member)
	
	
func get_group()->Group:
	return Group.init_meta(data_dic.member.group)
	

func get_origin_name()->String:
	return data_dic.origin
	
	
func get_current_name()->String:
	return data_dic.current
