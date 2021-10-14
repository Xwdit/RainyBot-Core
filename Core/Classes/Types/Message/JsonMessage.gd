extends SingleMessage


class_name JsonMessage


func _init():
	data = {
		"json_text":null
	}

func set_json_text(text:int) -> void:
	data.json_text = text

func get_json_text() -> String:
	return data.json_text
