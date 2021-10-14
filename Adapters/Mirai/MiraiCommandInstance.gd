extends Reference

class_name MiraiCommandInstance

signal request_finished
var sync_id = null
var request = null
var result = null

func get_result() -> Dictionary:
	return result
