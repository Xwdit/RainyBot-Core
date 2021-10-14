extends SingleMessage


class_name VoiceMessage


func _init():
	data = {
		Interface.voice_message_data.VoiceId:null,
		Interface.voice_message_data.Url:null,
		Interface.voice_message_data.Path:null,
		Interface.voice_message_data.Base64:null,
		Interface.voice_message_data.Length:null
	}


func set_voice_id(voice_id:String) -> void:
	data[Interface.voice_message_data.VoiceId] = voice_id

func get_voice_id() -> String:
	return data[Interface.voice_message_data.VoiceId]

func set_url(url:String) -> void:
	data[Interface.voice_message_data.Url] = url

func get_url() -> String:
	return data[Interface.voice_message_data.Url]
	
func set_path(path:String) -> void:
	data[Interface.voice_message_data.Path] = path

func get_path() -> String:
	return data[Interface.voice_message_data.Path]

func set_base64(base64:String) -> void:
	data[Interface.voice_message_data.Base64] = base64

func get_base64() -> String:
	return data[Interface.voice_message_data.Base64]
	
func get_length() -> int:
	return data[Interface.voice_message_data.Length]
