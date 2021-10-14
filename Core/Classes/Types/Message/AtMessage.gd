extends SingleMessage


class_name AtMessage


func _init():
	data = {
		"target_id":null,
		"display":null
	}


func set_target_id(id:int) -> void:
	data.target_id = id
	
	
func get_target_id() -> int:
	return data.target_id
	
	
func get_display() -> String:
	return data.display
