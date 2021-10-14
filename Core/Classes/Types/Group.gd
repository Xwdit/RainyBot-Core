extends Reference

class_name Group

var data:Dictionary = {
	"id":null,
	"name":null,
	"permission":null
}

func get_id() -> int:
	return data.id
	
func get_name() -> String:
	return data.name
	
func get_permission() -> int:
	return data.permission

#func is_owner():
#	if data.permission != null:
#		if data.permission
