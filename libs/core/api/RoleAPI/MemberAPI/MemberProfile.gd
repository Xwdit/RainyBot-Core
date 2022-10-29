extends MemberAPI


class_name MemberProfile


enum Sex {
	UNKNOWN,
	MALE,
	FEMALE
}


var data_dic:Dictionary = {
	"nickname":"",
	"email":"",
	"age":-1,
	"level":-1,
	"sign":"",
	"sex":"UNKNOWN"
}


static func init_user(user_id:int,timeout:float=-INF)->MemberProfile:
	var ins:MemberProfile = MemberProfile.new()
	var _req_dic:Dictionary = {
		"target":user_id,
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("userProfile","",_req_dic,timeout)
	if !_result.is_empty():
		ins.data_dic = _result
	return ins


static func init_meta(dic:Dictionary)->MemberProfile:
	var ins:MemberProfile = MemberProfile.new()
	if !dic.is_empty():
		ins.data_dic = dic
	return ins
	
	
func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary)->void:
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
	return Sex.UNKNOWN
	
	
func is_sex(sex:int)->bool:
	return sex == get_sex()
