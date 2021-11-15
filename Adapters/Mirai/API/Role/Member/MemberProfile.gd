extends MemberAPI


class_name MemberProfile


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


static func init_meta(dic:Dictionary)->MemberProfile:
	var ins:MemberProfile = MemberProfile.new()
	ins.data_dic = dic
	return ins
	
	
func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary):
	data_dic = dic


func get_nickname()->String:
	return data_dic.nickname
	
	
func get_email()->String:
	return data_dic.email
	
	
func get_age()->int:
	return data_dic.age
	
	
func get_level()->int:
	return data_dic.level
	
	
func get_sign()->String:
	return data_dic.sign
	
	
func get_sex()->int:
	match data_dic.sex:
		"MALE":
			return Sex.MALE
		"FEMALE":
			return Sex.FEMALE
		_:
			return Sex.UNKNOWN
