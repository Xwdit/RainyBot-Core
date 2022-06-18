extends Message


class_name MusicShareMessage


var data_dic:Dictionary = {
	"type": "MusicShare",
	"kind": "",
	"title": "",
	"summary": "",
	"jumpUrl": "",
	"pictureUrl": "",
	"musicUrl": "",
	"brief": ""
}


static func init(kind:String,title:String,summary:String,jump_url:String,picture_url:String,music_url:String,brief:String)->MusicShareMessage:
	var ins:MusicShareMessage = MusicShareMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.kind = kind
	dic.title = title
	dic.summary = summary
	dic.jumpUrl = jump_url
	dic.pictureUrl = picture_url
	dic.musicUrl = music_url
	dic.brief = brief
	return ins


static func init_meta(dic:Dictionary)->MusicShareMessage:
	var ins:MusicShareMessage = MusicShareMessage.new()
	ins.data_dic = dic
	return ins

	
func get_share_kind()->String:
	return data_dic.kind
	
	
func set_share_kind(text:String):
	data_dic.kind = text
	
	
func get_share_title()->String:
	return data_dic.title
	
	
func set_share_title(text:String):
	data_dic.title = text
	
	
func get_share_summary()->String:
	return data_dic.summary
	
	
func set_share_summary(text:String):
	data_dic.summary = text
	
	
func get_share_jump_url()->String:
	return data_dic.jumpUrl
	
	
func set_share_jump_url(text:String):
	data_dic.jumpUrl = text
	
	
func get_share_picture_url()->String:
	return data_dic.pictureUrl
	
	
func set_share_picture_url(text:String):
	data_dic.pictureUrl = text
	
	
func get_share_music_url()->String:
	return data_dic.musicUrl
	
	
func set_share_music_url(text:String):
	data_dic.musicUrl = text
	
	
func get_share_brief()->String:
	return data_dic.brief
	
	
func set_share_brief(text:String):
	data_dic.brief = text


func get_as_text()->String:
	return "[音乐分享:"+get_share_title()+"]"
