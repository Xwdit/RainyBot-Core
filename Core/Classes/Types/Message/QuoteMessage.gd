extends SingleMessage


class_name QuoteMessage


func _init():
	data = {
		Interface.quote_message_data.MessageId: null,
		Interface.quote_message_data.GroupId: null,
		Interface.quote_message_data.SenderId: null,
		Interface.quote_message_data.TargetId: null,
		Interface.quote_message_data.OriginMessageChain: null
	}


func get_message_id() -> int:
	return data[Interface.quote_message_data.MessageId]
	
func get_group_id() -> int:
	return data[Interface.quote_message_data.GroupId]
	
func get_sender_id() -> int:
	return data[Interface.quote_message_data.SenderId]
	
func get_target_id() -> int:
	return data[Interface.quote_message_data.TargetId]
	
func get_origin_chain() -> MessageChain:
	return data[Interface.quote_message_data.OriginMessageChain]
