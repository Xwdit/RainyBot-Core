extends MessageAPI


class_name MessageChain


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
	return get_message(iter_current)


static func init(msg:Message)->MessageChain:
	var ins:MessageChain = MessageChain.new()
	ins.data_array.append(msg.get_metadata())
	return ins


static func init_id(msg_id:int)->MessageChain:
	var ins:MessageChain = MessageChain.new()
	ins.data_array.append({
		"type": "Source",
		"id": msg_id,
		"time": 0
	})
	return ins


static func init_meta(arr:Array)->MessageChain:
	var ins:MessageChain = MessageChain.new()
	ins.data_array = arr
	return ins


func get_metadata()->Array:
	return data_array


func set_metadata(arr:Array):
	data_array = arr


func append(msg:Message)->MessageChain:
	data_array.append(msg.get_metadata())
	return self


func get_size()->int:
	return data_array.size()


func get_message(index:int)->Message:
	if (index >= 0) && (index <= data_array.size()-1):
		return BotAdapter.parse_message_dic(data_array[index])
	else:
		return null


func get_message_array(types:Array=[],exclude:bool=false,max_size:int=-1)->Array:
	var arr:Array = []
	for _dic in data_array:
		if types.size() > 0:
			var _has = false
			for _t in types:
				if _dic.type == BotAdapter.message_type_dic[int(_t)]:
					_has = true
					break
			if exclude:
				if _has:
					continue
			elif !_has:
				continue
		arr.append(BotAdapter.parse_message_dic(_dic))
		if max_size != -1 && arr.size() >= max_size:
			break
	return arr


func get_message_text(types:Array=[],exclude:bool=false)->String:
	var text:String = ""
	for _dic in data_array:
		if types.size() > 0:
			var _has = false
			for _t in types:
				if _dic.type == BotAdapter.message_type_dic[int(_t)]:
					_has = true
					break
			if exclude:
				if _has:
					continue
			elif !_has:
				continue
		text += BotAdapter.parse_message_dic(_dic).get_as_text()
	return text


func get_message_id()->int:
	var _msg_id:int = 0
	if data_array.size() > 0:
		if data_array[0].type == "Source":
			_msg_id = data_array[0].id
	return _msg_id


func get_message_timestamp()->int:
	var _msg_time:int = 0
	if data_array.size() > 0:
		if data_array[0].type == "Source":
			_msg_time = data_array[0].time
	return _msg_time


func has_message_type(type:int)->bool:
	for _dic in data_array:
		if _dic.type == BotAdapter.message_type_dic[type]:
			return true
	return false


func set_essence()->BotRequestResult:
	var _req_dic = {
		"target":get_message_id()
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("setEssence",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func recall()->BotRequestResult:
	var _req_dic = {
		"target":get_message_id()
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("recall",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func is_at_bot()->bool:
	for _dic in data_array:
		if _dic.type == BotAdapter.message_type_dic[int(Message.Type.AT)]:
			if _dic.target == BotAdapter.get_bot_id():
				return true
	return false
