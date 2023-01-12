extends Message


class_name MarketFaceMessage


var data_dic:Dictionary = {
	"type": "MarketFace",
	"id": -1,
	"name": ""
}


static func init_meta(dic:Dictionary)->MarketFaceMessage:
	if !dic.is_empty() and dic.has("type"):
		var ins:MarketFaceMessage = MarketFaceMessage.new()
		ins.data_dic = dic
		return ins
	else:
		return null


func get_face_id()->int:
	return data_dic.id


func get_face_name()->String:
	return data_dic.name
	

func get_as_text()->String:
	return "[商城表情:"+get_face_name()+"]"
