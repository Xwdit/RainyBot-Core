extends EventAPI


class_name Event


enum Category{
	BOT,
	FRIEND,
	GROUP,
	MESSAGE,
	ACTION
}


func get_metadata()->Dictionary:
	return get("data_dic")


func set_metadata(dic:Dictionary):
	set("data_dic",dic)
