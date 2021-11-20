extends Event


class_name MessageEvent


enum Type{
	FRIEND,
	GROUP,
	TEMP,
	STRANGER,
	OTHER_CLIENT
}


func get_message_chain()->MessageChain:
	return MessageChain.init_meta(get("data_dic").messageChain)
