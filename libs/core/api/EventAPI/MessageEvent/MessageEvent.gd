extends Event


class_name MessageEvent


func get_message_chain()->MessageChain:
	return MessageChain.init_meta(get("data_dic").messageChain)


func get_message_array(types=[],exclude:bool=false,max_size:int=-1)->Array:
	return get_message_chain().get_message_array(types,exclude,max_size)


func get_message_text(types=[],exclude:bool=false)->String:
	return get_message_chain().get_message_text(types,exclude)


func get_message_id()->int:
	return get_message_chain().get_message_id()
	
	
func get_message_timestamp()->int:
	return get_message_chain().get_message_timestamp()


func get_sender_id()->int:
	return call("get_sender").get_id()


func reply(_msg,_quote:bool=false,_at:bool=false)->BotRequestResult:
	return null
