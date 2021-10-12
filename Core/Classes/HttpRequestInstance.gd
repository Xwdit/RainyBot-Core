extends HTTPRequest

class_name HttpRequestInstance

signal request_finished

var request_url = null
var result = null

func _ready():
	connect("request_completed",self,"_http_request_completed")

func _http_request_completed(_result, _response_code, _headers, body):
	result = parse_json(body.get_string_from_utf8())
	if result is Dictionary:
		print("获取到Http请求的回应: ",result)
	else:
		printerr("无法获取到有效的Http请求回应")
	emit_signal("request_finished")
	
func finish():
	queue_free()
	
func get_result():
	return result
