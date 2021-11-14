extends Message


class_name TextMessage


var data_dic:Dictionary = {
	"type": "Plain",
	"text": ""
}


static func init(text:String)->TextMessage:
	var ins:TextMessage = TextMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.text = text
	return ins


static func init_meta(dic:Dictionary)->TextMessage:
	var ins:TextMessage = TextMessage.new()
	ins.data_dic = dic
	return ins

	
func get_message_text()->String:
	return data_dic.text
	
	
func set_message_text(text:String):
	data_dic.text = text
