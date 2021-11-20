extends Event


class_name RequestEvent


enum Type{
	NEW_FRIEND,
	MEMBER_JOIN,
	GROUP_INVITE
}


func get_event_id()->int:
	return get("data_dic").eventId
	
	
func get_sender_id()->int:
	return get("data_dic").fromId
	
	
func get_sender_name()->String:
	return get("data_dic").nick
	
	
func get_group_id()->int:
	return get("data_dic").groupId
	
	
func get_request_message()->String:
	return get("data_dic").message
