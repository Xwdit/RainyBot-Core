extends RefCounted


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
	"msg":""
}


static func init_meta(dic:Dictionary)->BotRequestResult:
	var ins:BotRequestResult = BotRequestResult.new()
	ins.data_dic = dic
	return ins
