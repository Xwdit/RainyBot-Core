extends SingleMessage


class_name AppMessage


func _init():
	data = {
		Interface.app_message_data.AppText:null
	}

func set_app_text(text:int) -> void:
	data[Interface.app_message_data.AppText] = text

func get_app_text() -> String:
	return data[Interface.app_message_data.AppText]
