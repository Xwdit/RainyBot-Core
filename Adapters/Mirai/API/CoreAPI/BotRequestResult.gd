extends CoreAPI


class_name BotRequestResult


enum StatusCode{
	SUCCESS,
	WRONG_VERIFY_KEY,
	BOT_NOT_EXIST,
	SESSION_INVALID,
	SESSION_NOT_ACTIVE,
	TARGET_NOT_EXIST,
	FILE_NOT_EXIST,
	NO_PERMISSION = 10,
	BOT_MUTED = 20,
	MESSAGE_TOO_LONG = 30,
	WRONG_USAGE = 400
}


var data_dic:Dictionary = {
	"code":StatusCode.SUCCESS,
	"msg":"",
	"messageId":-1
}


static func init_meta(dic:Dictionary)->BotRequestResult:
	var ins:BotRequestResult = BotRequestResult.new()
	ins.data_dic = dic
	return ins


func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary):
	data_dic = dic


func get_status_code()->int:
	return data_dic.code
	
	
func get_status_msg()->String:
	return data_dic.msg
	
	
func get_message_id()->int:
	return data_dic.messageId
