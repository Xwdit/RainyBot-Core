extends GroupMemberEvent


class_name MemberJoinEvent


var data_dic:Dictionary = {
	"type": "MemberJoinEvent",
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
	"invitor":null
}


static func init_meta(dic:Dictionary)->MemberJoinEvent:
	if dic.has("type"):
		var ins:MemberJoinEvent = MemberJoinEvent.new()
		ins.data_dic = dic
		return ins
	else:
		return null


func get_member()->GroupMember:
	return GroupMember.init_meta(data_dic.member)
	
	
func get_invitor()->GroupMember:
	return GroupMember.init_meta(data_dic.invitor)
	
	
func get_group()->Group:
	return Group.init_meta(data_dic.member.group)
