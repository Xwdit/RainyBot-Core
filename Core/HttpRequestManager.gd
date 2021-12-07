extends Node


func send_http_get_request(url:String,timeout:float = 20.0)->Dictionary:
	GuiManager.console_print_warning("正在尝试发送Http Get请求到: "+url)
	var node:HttpRequestInstance = HttpRequestInstance.new()
	node.request_url = url
	node.use_threads = true
	add_child(node)
	var error = node.request(url)
	if error != OK:
		node.queue_free()
		GuiManager.console_print_error("发生了一个错误 " + str(error) + " 当发送Http Get请求到: " + url)
		return {}
	if timeout > 0.0:
		_tick_request_timeout(node,timeout)
	await node.request_finished
	var result = node.get_result()
	node.queue_free()
	return result


func _tick_request_timeout(request_ins:HttpRequestInstance,_timeout:float):
	await get_tree().create_timer(_timeout).timeout
	if is_instance_valid(request_ins) && request_ins.result == {}:
		GuiManager.console_print_error("Http请求超时，无法获取到返回结果: "+str(request_ins.request_url))
		request_ins.emit_signal("request_finished")


class HttpRequestInstance:
	extends HTTPRequest

	signal request_finished

	var request_url = ""
	var result = {}

	func _ready():
		connect("request_completed",Callable(self,"_http_request_completed"))

	func _http_request_completed(_result, _response_code, _headers, body):
		var json = JSON.new()
		var _error = json.parse(body.get_string_from_utf8())
		if _error == OK:
			result = json.get_data()
			GuiManager.console_print_success("获取到Http请求的回应: "+str(result))
		else:
			GuiManager.console_print_error("无法获取到有效的Http请求回应")
		emit_signal("request_finished")
		
	func get_result()->Dictionary:
		return result
