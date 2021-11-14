extends Message


class_name FaceMessage


var data_dic:Dictionary = {
	"type": "Face",
	"faceId": null,
	"name": null
}


static func init_id(face_id:int)->FaceMessage:
	var ins:FaceMessage = FaceMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.faceId = face_id
	return ins


static func init_name(face_name:int)->FaceMessage:
	var ins:FaceMessage = FaceMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.name = face_name
	return ins


static func init_meta(dic:Dictionary)->FaceMessage:
	var ins:FaceMessage = FaceMessage.new()
	ins.data_dic = dic
	return ins


func get_face_id()->int:
	return data_dic.faceId


func set_face_id(face_id:int):
	data_dic.faceId = face_id

	
func get_face_name()->String:
	return data_dic.display
	
	
func set_face_name(face_name:String):
	data_dic.name = face_name
