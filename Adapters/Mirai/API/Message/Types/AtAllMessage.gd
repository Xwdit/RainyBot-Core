extends Message


class_name AtAllMessage


var data_dic:Dictionary = {
	"type": "AtAll",
}


static func init_meta(dic:Dictionary)->AtAllMessage:
	var ins:AtAllMessage = AtAllMessage.new()
	ins.data_dic = dic
	return ins
