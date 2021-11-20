extends MessageAPI


class_name Message


enum Type{
	SOURCE,
	QUOTE,
	AT,
	AT_ALL,
	FACE,
	TEXT,
	IMAGE,
	FLASH_IMAGE,
	VOICE,
	XML,
	JSON_MSG,
	APP,
	POKE,
	DICE,
	MUSIC_SHARE,
	FORWARD_MESSAGE,
	FILE,
	BOT_CODE
}


func get_metadata()->Dictionary:
	return get("data_dic")


func set_metadata(dic:Dictionary):
	set("data_dic",dic)


func get_as_text()->String:
	return ""
