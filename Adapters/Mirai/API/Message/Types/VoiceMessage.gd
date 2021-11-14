extends Message


class_name VoiceMessage


var data_dic:Dictionary = {
	"type": "Voice",
	"voiceId": null,
	"url": null,
	"path": null,
	"base64": null,
	"length": -1
}


static func init_id(voice_id:String)->VoiceMessage:
	var ins:VoiceMessage = VoiceMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.voiceId = voice_id
	return ins


static func init_url(voice_url:String)->VoiceMessage:
	var ins:VoiceMessage = VoiceMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.url = voice_url
	return ins


static func init_path(voice_path:String)->VoiceMessage:
	var ins:VoiceMessage = VoiceMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.path = voice_path
	return ins


static func init_base64(voice_base64:String)->VoiceMessage:
	var ins:VoiceMessage = VoiceMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.base64 = voice_base64
	return ins


static func init_meta(dic:Dictionary)->VoiceMessage:
	var ins:VoiceMessage = VoiceMessage.new()
	ins.data_dic = dic
	return ins

	
func get_voice_id()->String:
	return data_dic.voiceId
	
	
func set_voice_id(voice_id:String):
	data_dic.voiceId = voice_id
	
	
func get_voice_url()->String:
	return data_dic.url
	
	
func set_voice_url(voice_url:String):
	data_dic.url = voice_url
	
	
func get_voice_path()->String:
	return data_dic.path
	
	
func set_voice_path(voice_path:String):
	data_dic.path = voice_path
	
	
func get_voice_base64()->String:
	return data_dic.base64
	
	
func set_voice_base64(voice_base64:String):
	data_dic.base64 = voice_base64
	
	
func get_voice_length()->int:
	return data_dic.length
