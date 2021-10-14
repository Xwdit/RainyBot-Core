extends SingleMessage


class_name AppMessage


func _init():
	data = {
		"app_text":null
	}

func set_app_text(text:int) -> void:
	data.app_text = text

func get_app_text() -> String:
	return data.app_text
