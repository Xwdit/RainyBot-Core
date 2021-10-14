extends Reference

class_name SingleMessage

var data:Dictionary = {}

func get_raw_data(key:String):
	if data.has(key):
		return data[key]

func set_raw_data(key:String,value) -> void:
	if data.has(key):
		data[key] = value
		
func get_raw_data_dic() -> Dictionary:
	return data

func set_raw_data_dic(dic:Dictionary) -> void:
	data = dic
