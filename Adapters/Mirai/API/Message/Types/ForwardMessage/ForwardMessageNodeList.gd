extends RefCounted


class_name ForwardMessageNodeList


var data_array:Array = []


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
	if (index >= 0) && (index < data_array.size()-1):
		var member_dic:Dictionary = data_array[index]
		var ins = ForwardMessageNode.init_meta(member_dic)
		return ins
	else:
		return null
		
		
func get_size()->int:
	return data_array.size()
	
	
func append(msg_node:ForwardMessageNode):
	data_array.append(msg_node.get_metadata())
