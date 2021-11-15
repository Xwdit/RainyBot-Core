extends RefCounted


class_name MessageChain


var data_array:Array = []


static func init(msg:Message)->MessageChain:
	var ins:MessageChain = MessageChain.new()
	ins.data_array.append(msg.get_metadata())
	return ins


static func init_meta(arr:Array)->MessageChain:
	var ins:MessageChain = MessageChain.new()
	ins.data_array = arr
	return ins


func get_metadata()->Array:
	return data_array


func set_metadata(arr:Array):
	data_array = arr


func append(msg:Message):
	data_array.append(msg.get_metadata())
