extends Message


class_name AtAllMessage


var data_dic:Dictionary = {
	"type": "AtAll",
}


static func init()->AtAllMessage:
	var ins:AtAllMessage = AtAllMessage.new()
	return ins


static func init_meta(dic:Dictionary)->AtAllMessage:
	if dic.has("type"):
		var ins:AtAllMessage = AtAllMessage.new()
		ins.data_dic = dic
		return ins
	else:
		return null


func get_as_text()->String:
	return "[@全体成员]"
