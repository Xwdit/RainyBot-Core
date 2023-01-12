extends MessageAPI


class_name Message


func get_metadata()->Dictionary:
	return get("data_dic")


func set_metadata(dic:Dictionary)->void:
	if !dic.is_empty() and dic.has("type"):
		set("data_dic",dic)


func get_as_text()->String:
	return ""
