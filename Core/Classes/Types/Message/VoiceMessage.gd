extends SingleMessage


class_name VoiceMessage


func _init():
	data = {
		"voice_id":null,
		"url":null,
		"path":null,
		"base64":null,
		"length":null
	}


func set_voice_id(voice_id:String) -> void:
	data.voice_id = voice_id

func get_voice_id() -> String:
	return data.voice_id

func set_url(url:String) -> void:
	data.url = url

func get_url() -> String:
	return data.url
	
func set_path(path:String) -> void:
	data.path = path

func get_path() -> String:
	return data.path

func set_base64(base64:String) -> void:
	data.base64 = base64

func get_base64() -> String:
	return data.base64
	
func get_length() -> int:
	return data.length
