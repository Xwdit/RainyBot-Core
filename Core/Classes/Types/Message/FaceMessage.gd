extends SingleMessage


class_name FaceMessage


func _init():
	data = {
		"face_id":null,
		"name":null
	}


func set_face_id(id:int) -> void:
	data.face_id = id
	
	
func get_face_id() -> int:
	return data.face_id
	
func set_name(name:String) -> void:
	data.name = name

func get_name() -> String:
	return data.name
