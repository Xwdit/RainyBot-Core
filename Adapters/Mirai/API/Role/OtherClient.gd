extends RoleAPI


class_name OtherClient


var data_dic:Dictionary = {
	"id": -1,
	"platform": ""
}


static func init_meta(dic:Dictionary)->OtherClient:
	var ins:OtherClient = OtherClient.new()
	ins.data_dic = dic
	return ins


func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary):
	data_dic = dic
	
	
func get_id()->int:
	return data_dic.id
	
	
func get_platform()->String:
	return data_dic.platform
