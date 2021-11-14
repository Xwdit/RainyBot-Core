extends RefCounted


class_name MemberInfo


enum Sex {
	UNKNOWN,
	MALE,
	FEMALE
}


var data_dic:Dictionary = {
	"nickname":"nickname",
	"email":"email",
	"age":18,
	"level":1,
	"sign":"mirai",
	"sex":"UNKNOWN"
}


static func init_meta(dic:Dictionary)->MemberInfo:
	var ins:MemberInfo = MemberInfo.new()
	ins.data_dic = dic
	return ins
	
	
func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary):
	data_dic = dic
