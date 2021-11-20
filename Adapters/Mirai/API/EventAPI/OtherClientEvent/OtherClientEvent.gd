extends Event


class_name OtherClientEvent


enum type{
	ONLINE,
	OFFLINE
}


func get_client_id()->int:
	return get("data_dic").client.id
	
	
func get_client_platform()->String:
	return get("data_dic").client.platform
