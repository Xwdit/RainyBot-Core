extends Message


class_name SourceMessage


var data_dic:Dictionary = {
	"type": "Source",
	"id": -1,
	"time": -1
}


static func init_meta(dic:Dictionary)->SourceMessage:
	if !dic.is_empty() and dic.has("type"):
		var ins:SourceMessage = SourceMessage.new()
		ins.data_dic = dic
		return ins
	else:
		return null


func get_message_id()->int:
	return data_dic.id
	
	
func get_timestamp()->int:
	return data_dic.time


func get_as_text()->String:
	return "[消息ID:"+str(get_message_id())+",时间:"+str(get_timestamp())+"]"
