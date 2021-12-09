extends Node


func send_http_get_request(url:String,timeout:int = 20)->HttpRequestResult:
	GuiManager.console_print_warning("正在尝试发送Http Get请求到: "+url)
	var node:HttpRequestInstance = HttpRequestInstance.new()
	node.request_url = url
	node.use_threads = true
	if timeout > 0:
		node.timeout = timeout
	add_child(node)
	var error = node.request(url)
	if error != OK:
		node.queue_free()
		GuiManager.console_print_error("当发送Http Get请求到 %s 时发生了一个错误: %s"%[url,error_string(error)])
		var _r = HttpRequestResult.new()
		_r.request_url = url
		return _r
	await node.request_finished
	var result = node.get_result()
	node.queue_free()
	return result
	
	
func send_http_post_request(url:String,request_data,headers:PackedStringArray=PackedStringArray([]),timeout:int = 20)->HttpRequestResult:
	GuiManager.console_print_warning("正在尝试发送Http Post请求到: "+url)
	var node:HttpRequestInstance = HttpRequestInstance.new()
	node.request_url = url
	node.request_data = request_data
	node.request_headers = headers
	node.use_threads = true
	if timeout > 0:
		node.timeout = timeout
	add_child(node)
	var error = node.request(url,headers,true,HTTPClient.METHOD_POST,request_data)
	if error != OK:
		node.queue_free()
		GuiManager.console_print_error("当发送Http Post请求到 %s 时发生了一个错误: %s"%[url,error_string(error)])
		var _r = HttpRequestResult.new()
		_r.request_url = url
		_r.request_data = request_data
		_r.request_headers = headers
		return _r
	await node.request_finished
	var result = node.get_result()
	node.queue_free()
	return result


class HttpRequestInstance:
	extends HTTPRequest

	signal request_finished

	var request_url = ""
	var request_data = null
	var request_headers = []
	var result:HttpRequestResult = HttpRequestResult.new()

	func _ready():
		connect("request_completed",Callable(self,"_http_request_completed"))

	func _http_request_completed(_result, _response_code, _headers, _body):
		result.request_url = request_url
		result.request_data = request_data
		result.request_headers = request_headers
		result.result_code = _result
		result.response_code = _response_code
		result.headers = _headers
		result.body = _body
		if _result != HTTPRequest.RESULT_SUCCESS:
			GuiManager.console_print_error("从 %s 获取Http请求结果时出现错误，无法获取到返回结果: %s"%[request_url,ClassDB.class_get_enum_constants("HTTPRequest","Result")[int(_result)]])
		else:
			GuiManager.console_print_success("成功从 %s 获取到Http请求的返回结果！"%[request_url])
		emit_signal("request_finished")
		
	func get_result()->HttpRequestResult:
		return result
