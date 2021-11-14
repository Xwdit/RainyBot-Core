extends Message


class_name SourceMessage


var data_dic:Dictionary = {
	"type": "Source",
	"id": -1,
	"time": -1
}


static func init_meta(dic:Dictionary)->SourceMessage:
	var ins:SourceMessage = SourceMessage.new()
	ins.data_dic = dic
	return ins


func get_message_id()->int:
	return data_dic.id
	
	
func get_timestamp()->int:
	return data_dic.time
