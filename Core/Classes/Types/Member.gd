extends Reference

class_name Member

var data:Dictionary = {
	"id":null,
	"name":null,
	"remark":null,
	"special_title":null,
	"permission":null,
	"join_timestamp":null,
	"last_speak_timestamp":null,
	"mute_time_remaining":null,
	"group":null,
	"platform":null
}

func get_id() -> int:
	return data.id
	
func get_name() -> String:
	return data.name
	
func get_remark() -> String:
	return data.remark
	
func get_special_title() -> String:
	return data.special_title
	
func get_permission() -> int:
	return data.permission
	
func get_join_timestamp() -> int:
	return data.join_timestamp
	
func get_join_time_datetime() -> Dictionary:
	if data.join_timestamp != null:
		return OS.get_datetime_from_unix_time(data.join_timestamp)
	else:
		return {}
		
func get_last_speak_timestamp() -> int:
	return data.last_speak_timestamp

func get_last_speak_datetime() -> Dictionary:
	if data.last_speak_timestamp != null:
		return OS.get_datetime_from_unix_time(data.last_speak_timestamp)
	else:
		return {}

func get_mute_time_remaining() -> int:
	return data.mute_time_remaining
	
func get_group() -> Group:
	return data.group

func get_platform() -> String:
	return data.platform
