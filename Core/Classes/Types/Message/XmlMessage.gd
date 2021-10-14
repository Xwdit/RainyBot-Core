extends SingleMessage


class_name XmlMessage


func _init():
	data = {
		"xml_text":null
	}

func set_xml_text(text:int) -> void:
	data.xml_text = text

func get_xml_text() -> String:
	return data.xml_text
