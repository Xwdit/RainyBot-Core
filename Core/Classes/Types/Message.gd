extends Reference

class_name Message

var data:Dictionary = {
	Interface.message_data.Type:null,
	Interface.message_data.MessageId:null,
	Interface.message_data.SenderId:null,
	Interface.message_data.TargetId:null,
	Interface.message_data.GroupId:null,
	Interface.message_data.Timestamp:null,
	Interface.message_data.OriginMessageChain:null,
	Interface.message_data.DisplayText:null,
	Interface.message_data.FaceId:null,
	Interface.message_data.FaceName:null,
	Interface.message_data.ImageId:null,
	Interface.message_data.VoiceId:null,
	Interface.message_data.Url:null,
	Interface.message_data.Path:null,
	Interface.message_data.Base64:null,
	Interface.message_data.Length:null,
	Interface.message_data.Text:null,
	Interface.message_data.PokeType:null,
	Interface.message_data.Value:null,
	Interface.message_data.Kind:null,
	Interface.message_data.Title:null,
	Interface.message_data.Summary:null,
	Interface.message_data.JumpUrl:null,
	Interface.message_data.PictureUrl:null,
	Interface.message_data.MusicUrl:null,
	Interface.message_data.Brief:null,
	Interface.message_data.NodeList:null,
	Interface.message_data.FileId:null,
	Interface.message_data.FileName:null,
	Interface.message_data.FileSize:null
}

func get_raw_data(key:String):
	if data.has(key):
		return data[key]

func set_raw_data(key:String,value) -> void:
	if data.has(key):
		data[key] = value
		
func get_raw_data_dic() -> Dictionary:
	return data

func set_raw_data_dic(dic:Dictionary) -> void:
	data = dic
