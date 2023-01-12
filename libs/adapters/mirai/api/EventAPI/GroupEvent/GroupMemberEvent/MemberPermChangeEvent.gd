extends GroupMemberEvent


class_name MemberPermChangeEvent


var data_dic:Dictionary = {
	"type": "MemberPermissionChangeEvent",
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


static func init_meta(dic:Dictionary)->MemberPermChangeEvent:
	if dic.has("type"):
		var ins:MemberPermChangeEvent = MemberPermChangeEvent.new()
		ins.data_dic = dic
		return ins
	else:
		return null


func get_member()->GroupMember:
	return GroupMember.init_meta(data_dic.member)
	
	
func get_group()->Group:
	return Group.init_meta(data_dic.member.group)
	

func get_origin_perm()->int:
	return BotAdapter.parse_permission_text(data_dic.origin)
	
	
func get_current_perm()->int:
	return BotAdapter.parse_permission_text(data_dic.current)
