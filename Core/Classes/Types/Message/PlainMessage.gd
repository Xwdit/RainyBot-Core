extends SingleMessage


class_name PlainMessage


func _init():
	data = {
		Interface.plain_message_data.Text:null
	}

func set_text(text:int) -> void:
	data[Interface.plain_message_data.Text] = text

func get_text() -> String:
	return data[Interface.plain_message_data.Text]
