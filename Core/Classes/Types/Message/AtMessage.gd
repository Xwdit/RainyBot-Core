extends SingleMessage


class_name AtMessage


func _init():
	data = {
		Interface.at_message_data.TargetId:null,
		Interface.at_message_data.DisplayText:null
	}


func set_target_id(id:int) -> void:
	data[Interface.at_message_data.TargetId] = id
	
	
func get_target_id() -> int:
	return data[Interface.at_message_data.TargetId]
	
	
func get_display() -> String:
	return data[Interface.at_message_data.DisplayText]
