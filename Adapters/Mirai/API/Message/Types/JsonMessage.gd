extends Message


class_name JsonMessage


var data_dic:Dictionary = {
	"type": "Json",
	"json": ""
}


static func init(text:String)->JsonMessage:
	var ins:JsonMessage = JsonMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.json = text
	return ins


static func init_meta(dic:Dictionary)->JsonMessage:
	var ins:JsonMessage = JsonMessage.new()
	ins.data_dic = dic
	return ins

	
func get_json_text()->String:
	return data_dic.json
	
	
func set_json_text(text:String):
	data_dic.json = text
