extends RefCounted


class_name Message


enum Type{
	SOURCE,
	QUOTE,
	AT,
	AT_ALL,
	FACE,
	PLAIN,
	IMAGE,
	FLASH_IMAGE,
	VOICE,
	XML,
	JSON,
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
