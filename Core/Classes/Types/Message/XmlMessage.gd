extends SingleMessage


class_name XmlMessage


func _init():
	data = {
		Interface.xml_message_data.XmlText:null
	}

func set_xml_text(text:int) -> void:
	data[Interface.xml_message_data.XmlText] = text

func get_xml_text() -> String:
	return data[Interface.xml_message_data.XmlText]
