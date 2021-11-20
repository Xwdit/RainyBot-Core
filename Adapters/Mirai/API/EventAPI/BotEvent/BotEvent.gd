extends Event


class_name BotEvent


enum Type {
	OFFLINE,
	ONLINE,
	RELOGIN
}


func get_qq()->int:
	return get("data_dic").qq
