extends MessageAPI


class_name ForwardMessageNodeList


var data_array:Array = []
var iter_current = 0


func _iter_should_continue():
	return (iter_current < data_array.size())


func _iter_init(_arg):
	iter_current = 0
	return _iter_should_continue()


func _iter_next(_arg):
	iter_current += 1
	return _iter_should_continue()


func _iter_get(_arg):
	return get_from_index(iter_current)


static func init(msg_node:ForwardMessageNode)->ForwardMessageNodeList:
	var ins:ForwardMessageNodeList = ForwardMessageNodeList.new()
	ins.data_array.append(msg_node.get_metadata())
	return ins


static func init_meta(arr:Array)->ForwardMessageNodeList:
	var ins:ForwardMessageNodeList = ForwardMessageNodeList.new()
	ins.data_array = arr
	return ins


func get_metadata()->Array:
	return data_array


func set_metadata(arr:Array):
	data_array = arr


func get_from_index(index:int)->ForwardMessageNode:
	if (index >= 0) && (index <= data_array.size()-1):
		var member_dic:Dictionary = data_array[index]
		var ins = ForwardMessageNode.init_meta(member_dic)
		return ins
	else:
		return null
		

func get_from_message_id(message_id:int)->ForwardMessageNode:
	for _node in data_array:
		if _node.messageId == message_id:
			return ForwardMessageNode.init_meta(_node)
	return null
	
	
func get_from_sender_id(sender_id:int)->ForwardMessageNode:
	for _node in data_array:
		if _node.senderId == sender_id:
			return ForwardMessageNode.init_meta(_node)
	return null


func get_size()->int:
	return data_array.size()
	
	
func append(msg_node:ForwardMessageNode)->ForwardMessageNodeList:
	data_array.append(msg_node.get_metadata())
	return self
