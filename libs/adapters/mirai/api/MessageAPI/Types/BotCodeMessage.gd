extends Message


class_name BotCodeMessage


var data_dic:Dictionary = {
	"type": "MiraiCode",
	"code": ""
}


static func init(text:String)->BotCodeMessage:
	var ins:BotCodeMessage = BotCodeMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.code = text.replacen("[bot:","[mirai:")
	return ins


static func init_meta(dic:Dictionary)->BotCodeMessage:
	if !dic.is_empty() and dic.has("type"):
		var ins:BotCodeMessage = BotCodeMessage.new()
		ins.data_dic = dic
		return ins
	else:
		return null

	
func get_code_text()->String:
	var _text:String = data_dic.code
	return _text.replacen("[mirai:","[bot:")
	
	
func set_code_text(text:String)->void:
	data_dic.code = text.replacen("[bot:","[mirai:")


func get_as_text()->String:
	return get_code_text()
