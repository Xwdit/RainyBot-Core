extends FriendEvent


class_name FriendRecallEvent


var data_dic:Dictionary = {
	"type": "FriendRecallEvent",
	"authorId": 0,
	"messageId": 0,
	"time": 0,
	"operator": 0
}


static func init_meta(dic:Dictionary)->FriendRecallEvent:
	if dic.has("type"):
		var ins:FriendRecallEvent = FriendRecallEvent.new()
		ins.data_dic = dic
		return ins
	else:
		return null
	
	
func get_sender_id()->int:
	return data_dic.authorId
	
	
func get_message_id()->int:
	return data_dic.messageId
	
	
func get_message_time()->int:
	return data_dic.time
	
	
func get_operator_id()->int:
	return data_dic.operator
