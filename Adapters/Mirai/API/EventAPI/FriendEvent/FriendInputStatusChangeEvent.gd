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
	var ins:FriendInputStatusChangeEvent = FriendInputStatusChangeEvent.new()
	ins.data_dic = dic
	return ins
	
	
func get_input_state()->bool:
	return data_dic.inputting
