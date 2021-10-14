extends SingleMessage


class_name PlainMessage


func _init():
	data = {
		"text":null
	}

func set_text(text:int) -> void:
	data.text = text

func get_text() -> String:
	return data.text
