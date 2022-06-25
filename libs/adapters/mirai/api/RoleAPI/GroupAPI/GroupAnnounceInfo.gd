extends GroupAPI


class_name GroupAnnounceInfo


var data_dic:Dictionary = {
	"group":{},
	"content":"",
	"senderId":-1,
	"fid":"",
	"allConfirmed":false,
	"confirmedMembersCount":-1,
	"publicationTime":-1
}


static func init_meta(dic:Dictionary)->GroupAnnounceInfo:
	var ins:GroupAnnounceInfo = GroupAnnounceInfo.new()
	if !dic.is_empty():
		ins.data_dic = dic
	return ins


func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary):
	data_dic = dic


func get_id()->String:
	return data_dic["fid"]


func get_group()->Group:
	return Group.init_meta(data_dic["group"])


func get_content()->String:
	return data_dic["content"]


func get_sender_id()->int:
	return data_dic["senderId"]


func is_all_confirmed()->bool:
	return data_dic["allConfirmed"]
	
	
func get_confirmed_count()->int:
	return data_dic["confirmedMembersCount"]
	
	
func get_public_timestamp()->int:
	return data_dic["publicationTime"]
