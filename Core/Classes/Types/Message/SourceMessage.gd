extends SingleMessage


class_name SourceMessage


func _init():
	data = {
		"id":null,
		"timestamp":null
	}

	
func get_id() -> int:
	return data.id
	
func get_timestamp() -> int:
	return data.timestamp
