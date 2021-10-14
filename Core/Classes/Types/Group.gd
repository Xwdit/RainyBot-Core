extends Reference

class_name Group

var data:Dictionary = {
	Interface.group_data.Id:null,
	Interface.group_data.Name:null,
	Interface.group_data.Permission:null
}

func get_id() -> int:
	return data[Interface.group_data.Id]
	
func get_name() -> String:
	return data[Interface.group_data.Name]
	
func get_permission() -> int:
	return data[Interface.group_data.Permission]

#func is_owner():
#	if data.permission != null:
#		if data.permission
