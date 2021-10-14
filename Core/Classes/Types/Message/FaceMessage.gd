extends SingleMessage


class_name FaceMessage


func _init():
	data = {
		Interface.face_message_data.FaceId:null,
		Interface.face_message_data.Name:null
	}


func set_face_id(id:int) -> void:
	data[Interface.face_message_data.FaceId] = id
	
	
func get_face_id() -> int:
	return data[Interface.face_message_data.FaceId]
	
func set_name(name:String) -> void:
	data[Interface.face_message_data.Name] = name

func get_name() -> String:
	return data[Interface.face_message_data.Name]
