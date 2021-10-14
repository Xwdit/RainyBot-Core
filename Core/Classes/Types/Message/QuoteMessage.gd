extends SingleMessage


class_name QuoteMessage


func _init():
	data = {
		"message_id": null,
		"group_id": null,
		"sender_id": null,
		"target_id": null,
		"origin_chain": null
	}


func get_message_id() -> int:
	return data.message_id
	
func get_group_id() -> int:
	return data.group_id
	
func get_sender_id() -> int:
	return data.sender_id
	
func get_target_id() -> int:
	return data.target_id
	
func get_origin_chain() -> MessageChain:
	return data.origin_chain
