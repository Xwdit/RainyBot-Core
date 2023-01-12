extends FriendEvent


class_name FriendInputStatusChangeEvent


var data_dic:Dictionary = {
	"type": "FriendInputStatusChangedEvent",
	"friend": {
		"id": 0,
		"nickname": "",
		"remark": ""
	}, 
	"inputting": false
}


static func init_meta(dic:Dictionary)->FriendInputStatusChangeEvent:
	if !dic.is_empty() and dic.has("type"):
		var ins:FriendInputStatusChangeEvent = FriendInputStatusChangeEvent.new()
		ins.data_dic = dic
		return ins
	else:
		return null
	
	
func get_input_state()->bool:
	return data_dic.inputting
	
	
func get_member()->Member:
	return Member.init_meta(data_dic.friend)
