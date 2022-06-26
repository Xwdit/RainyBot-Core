extends EventAPI


class_name Event


func get_metadata()->Dictionary:
	return get("data_dic")


func set_metadata(dic:Dictionary)->void:
	set("data_dic",dic)
