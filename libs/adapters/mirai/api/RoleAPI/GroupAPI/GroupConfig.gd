extends GroupAPI


class_name GroupConfig


var data_dic:Dictionary = {
	"name":"",
	"announcement":"",
	"confessTalk":false,
	"allowMemberInvite":false,
	"autoApprove":false,
	"anonymousChat":false
}


static func init_meta(dic:Dictionary)->GroupConfig:
	var ins:GroupConfig = GroupConfig.new()
	if !dic.is_empty():
		ins.data_dic = dic
	return ins


func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary):
	data_dic = dic


func get_name()->String:
	return data_dic.name
	

func get_announcement()->String:
	return data_dic.announcement
	
	
func get_confess_talk()->bool:
	return data_dic.confessTalk
	
	
func get_allow_member_invite()->bool:
	return data_dic.allowMemberInvite
	
	
func get_auto_approve()->bool:
	return data_dic.autoApprove
	
	
func get_anonymous_chat()->bool:
	return data_dic.anonymousChat
	
	
func set_name(name:String):
	data_dic.name = name
	
	
func set_announcement(text:String):
	data_dic.announcement = text
	
	
func set_confess_talk(enabled:bool):
	data_dic.confessTalk = enabled


func set_allow_member_invite(enabled:bool):
	data_dic.allowMemberInvite = enabled
	
	
func set_auto_approve(enabled:bool):
	data_dic.autoApprove = enabled
	
	
func set_anonymous_chat(enabled:bool):
	data_dic.anonymousChat = enabled
