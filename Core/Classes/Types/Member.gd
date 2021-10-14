extends Reference

class_name Member

var data:Dictionary = {
	Interface.member_data.Id:null,
	Interface.member_data.Name:null,
	Interface.member_data.MemberName:null,
	Interface.member_data.Remark:null,
	Interface.member_data.SpecialTitle:null,
	Interface.member_data.Permission:null,
	Interface.member_data.JoinTimestamp:null,
	Interface.member_data.LastSpeakTimestamp:null,
	Interface.member_data.MuteTimeRemaining:null,
	Interface.member_data.Group:null,
	Interface.member_data.Platform:null
}

func get_id() -> int:
	return data[Interface.member_data.Id]
	
func get_name() -> String:
	return data[Interface.member_data.Name]

func get_member_name() -> String:
	return data[Interface.member_data.MemberName]

func get_remark() -> String:
	return data[Interface.member_data.Remark]
	
func get_special_title() -> String:
	return data[Interface.member_data.SpecialTitle]
	
func get_permission() -> int:
	return data[Interface.member_data.Permission]
	
func get_join_timestamp() -> int:
	return data[Interface.member_data.JoinTimestamp]
	
func get_join_time_datetime() -> Dictionary:
	if data[Interface.member_data.JoinTimestamp] != null:
		return OS.get_datetime_from_unix_time(data[Interface.member_data.JoinTimestamp])
	else:
		return {}
		
func get_last_speak_timestamp() -> int:
	return data[Interface.member_data.LastSpeakTimestamp]

func get_last_speak_datetime() -> Dictionary:
	if data[Interface.member_data.LastSpeakTimestamp] != null:
		return OS.get_datetime_from_unix_time(data[Interface.member_data.LastSpeakTimestamp])
	else:
		return {}

func get_mute_time_remaining() -> int:
	return data[Interface.member_data.MuteTimeRemaining]
	
func get_group() -> Group:
	return data[Interface.member_data.Group]

func get_platform() -> String:
	return data[Interface.member_data.Platform]
