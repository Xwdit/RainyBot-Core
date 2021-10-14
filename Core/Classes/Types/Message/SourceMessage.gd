extends SingleMessage


class_name SourceMessage


func _init():
	data = {
		Interface.source_message_data.MessageId:null,
		Interface.source_message_data.Timestamp:null
	}

	
func get_id() -> int:
	return data[Interface.source_message_data.MessageId]
	
func get_timestamp() -> int:
	return data[Interface.source_message_data.Timestamp]
