extends HTTPRequest

class_name HttpRequestInstance

signal request_finished

var request_url = null
var result = null

func _ready():
	connect("request_completed",Callable(self,"_http_request_completed"))

func _http_request_completed(_result, _response_code, _headers, body):
	var json = JSON.new()
	var _error = json.parse(body.get_string_from_utf8())
	if _error == OK:
		GuiManager.console_print_success("获取到Http请求的回应: "+str(result))
		result = json.get_data()
	else:
		GuiManager.console_print_error("无法获取到有效的Http请求回应")
	emit_signal("request_finished")
	
func get_result():
	return result
