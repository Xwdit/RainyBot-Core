extends Message


class_name AppMessage


var data_dic:Dictionary = {
	"type": "App",
	"content": ""
}


static func init(text:String)->AppMessage:
	var ins:AppMessage = AppMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.content = text
	return ins


static func init_meta(dic:Dictionary)->AppMessage:
	var ins:AppMessage = AppMessage.new()
	ins.data_dic = dic
	return ins

	
func get_app_text()->String:
	return data_dic.content
	
	
func set_app_text(text:String):
	data_dic.content = text
