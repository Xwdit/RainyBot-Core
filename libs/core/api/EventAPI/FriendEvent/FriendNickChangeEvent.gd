extends FriendEvent


class_name FriendNickChangeEvent


var data_dic:Dictionary = {
	"type": "FriendNickChangedEvent",
	"friend": {
		"id": 0,
		"nickname": "",
		"remark": ""
	}, 
	"from": "",
	"to": ""
}


static func init_meta(dic:Dictionary)->FriendNickChangeEvent:
	var ins:FriendNickChangeEvent = FriendNickChangeEvent.new()
	ins.data_dic = dic
	return ins
	
	
func get_origin_nickname()->String:
	return data_dic.from


func get_current_nickname()->String:
	return data_dic.to


func get_member()->Member:
	return Member.init_meta(data_dic.friend)
