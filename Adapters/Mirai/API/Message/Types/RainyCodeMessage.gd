extends Message


class_name RainyCodeMessage


var data_dic:Dictionary = {
	"type": "MiraiCode",
	"code": ""
}


static func init(text:String)->RainyCodeMessage:
	var ins:RainyCodeMessage = RainyCodeMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.code = text.replacen("[rainy:","[mirai:")
	return ins


static func init_meta(dic:Dictionary)->RainyCodeMessage:
	var ins:RainyCodeMessage = RainyCodeMessage.new()
	ins.data_dic = dic
	return ins

	
func get_code_text()->String:
	var _text:String = data_dic.code
	return _text.replacen("[mirai:","[rainy:")
	
	
func set_code_text(text:String):
	data_dic.code = text.replacen("[rainy:","[mirai:")
