extends RefCounted


class_name ForwardMessageNode


var data_dic:Dictionary = {
	"senderId": -1,
	"time": 0,
	"senderName": "",
	"messageChain": [],
	"messageId": -1
}


static func init(message_id:int,sender_id:int=-1,time:int=0,sender_name:String="",message_chain:MessageChain=null)->ForwardMessageNode:
	var ins:ForwardMessageNode = ForwardMessageNode.new()
	var dic:Dictionary = ins.data_dic
	dic.senderId = sender_id
	dic.time = time
	dic.senderName = sender_name
	dic.messageChain = message_chain.get_metadata()
	dic.messageId = message_id
	return ins


static func init_meta(dic:Dictionary)->ForwardMessageNode:
	var ins:ForwardMessageNode = ForwardMessageNode.new()
	ins.data_dic = dic
	return ins


func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary):
	data_dic = dic


func get_sender_id()->int:
	return data_dic.senderId
	
	
func set_sender_id(id:int):
	data_dic.senderId = id
	

func get_time()->int:
	return data_dic.time
	
	
func set_time(time:int):
	data_dic.time = time
	
	
func get_sender_name()->String:
	return data_dic.senderName
	
	
func set_sender_name(name:int):
	data_dic.senderName = name
	
	
func get_message_chain()->MessageChain:
	return MessageChain.init_meta(data_dic.messageChain)
	
	
func set_message_chain(msg_chain:MessageChain):
	data_dic.messageChain = msg_chain.get_metadata()


func get_message_id()->int:
	return data_dic.messageId
	
	
func set_message_id(id:int):
	data_dic.messageId = id
