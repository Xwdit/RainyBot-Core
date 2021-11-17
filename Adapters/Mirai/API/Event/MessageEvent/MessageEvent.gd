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
	return null
	
	
func reply(msg:Message,quote:bool=false)->BotRequestResult:
	return null
	
	
func reply_chain(msg_chain:MessageChain,quote:bool=false)->BotRequestResult:
	return null
