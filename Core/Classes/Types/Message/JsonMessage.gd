extends SingleMessage


class_name JsonMessage


func _init():
	data = {
		Interface.json_message_data.JsonText:null
	}

func set_json_text(text:int) -> void:
	data[Interface.json_message_data.JsonText] = text

func get_json_text() -> String:
	return data[Interface.json_message_data.JsonText]
