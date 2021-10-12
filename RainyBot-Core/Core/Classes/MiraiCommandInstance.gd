extends Object

class_name MiraiCommandInstance

signal request_finished
var sync_id = null
var request = null
var result = null
	
func finish():
	MiraiManager.processing_command.erase(sync_id)
	call_deferred("free")

func get_result():
	return result
