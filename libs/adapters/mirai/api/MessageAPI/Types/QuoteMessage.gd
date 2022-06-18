extends Message


class_name QuoteMessage


var data_dic:Dictionary = {
	"type": "Quote",
	"id": -1,
	"groupId": -1,
	"senderId": -1,
	"targetId": -1,
	"origin": [] 
}


static func init_meta(dic:Dictionary)->QuoteMessage:
	var ins:QuoteMessage = QuoteMessage.new()
	ins.data_dic = dic
	return ins


func get_message_id()->int:
	return data_dic.id
	
	
func get_group_id()->int:
	return data_dic.groupId


func get_sender_id()->int:
	return data_dic.senderId
	
	
func get_target_id()->int:
	return data_dic.targetId
	
	
func get_message_chain()->MessageChain:
	return MessageChain.init_meta(data_dic.origin)
	
	
func get_as_text()->String:
	return "[引用回复:"+str(get_message_id())+"]"
