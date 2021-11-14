extends RefCounted


class_name Message


func get_metadata()->Dictionary:
	return get("data_dic")


func set_metadata(dic:Dictionary):
	set("data_dic",dic)
