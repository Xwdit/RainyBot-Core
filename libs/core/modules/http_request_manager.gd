extends Node


func send_http_get_request(url:String,headers:PackedStringArray=PackedStringArray([]),timeout:int=20)->HttpRequestResult:
	GuiManager.console_print_warning("正在尝试发送Http Get请求到: "+url)
	var node:HttpRequestInstance = HttpRequestInstance.new()
	node.request_url = url
	node.request_headers = headers
	if timeout > 0:
		node.timeout = timeout
	add_child(node)
	var error:int = node.request(url,headers)
	if error:
		node.queue_free()
		GuiManager.console_print_error("当发送Http Get请求到 %s 时发生了一个错误: %s"%[url,error_string(error)])
		var _r:HttpRequestResult = HttpRequestResult.new()
		_r.request_url = url
		_r.request_headers = headers
		return _r
	await node.request_finished
	var result:HttpRequestResult = node.get_result()
	node.queue_free()
	return result
	
	
func send_http_post_request(url:String,data="",headers:PackedStringArray=PackedStringArray([]),timeout:int=20)->HttpRequestResult:
	GuiManager.console_print_warning("正在尝试发送Http Post请求到: "+url)
	if (data is Dictionary) or (data is Array):
		var _json:JSON = JSON.new()
		data = _json.stringify(data)
		if !headers.has("Content-Type: application/json"):
			headers.append("Content-Type: application/json")
	elif !(data is String):
		data = ""
		GuiManager.console_print_warning("警告: 传入的请求数据不是一个字典/数组/字符串，因此已将其替换为空字符串(\"\")！")
	var node:HttpRequestInstance = HttpRequestInstance.new()
	node.request_url = url
	node.request_data = data
	node.request_headers = headers
	if timeout > 0:
		node.timeout = timeout
	add_child(node)
	var error:int = node.request(url,headers,true,HTTPClient.METHOD_POST,data)
	if error:
		node.queue_free()
		GuiManager.console_print_error("在发送Http Post请求到 %s 时发生了一个错误: %s"%[url,error_string(error)])
		var _r:HttpRequestResult = HttpRequestResult.new()
		_r.request_url = url
		_r.request_data = data
		_r.request_headers = headers
		return _r
	await node.request_finished
	var result:HttpRequestResult = node.get_result()
	node.queue_free()
	return result


func send_http_put_request(url:String,data="",headers:PackedStringArray=PackedStringArray([]),timeout:int=20)->HttpRequestResult:
	GuiManager.console_print_warning("正在尝试发送Http Put请求到: "+url)
	if (data is Dictionary) or (data is Array):
		var _json:JSON = JSON.new()
		data = _json.stringify(data)
	elif !(data is String):
		data = ""
		GuiManager.console_print_warning("警告: 传入的请求数据不是一个字典/数组/字符串，因此已将其替换为空字符串(\"\")！")
	if !headers.has("Content-Type: application/json"):
		headers.append("Content-Type: application/json")
	var node:HttpRequestInstance = HttpRequestInstance.new()
	node.request_url = url
	node.request_data = data
	node.request_headers = headers
	if timeout > 0:
		node.timeout = timeout
	add_child(node)
	var error:int = node.request(url,headers,true,HTTPClient.METHOD_PUT,data)
	if error:
		node.queue_free()
		GuiManager.console_print_error("在发送Http Put请求到 %s 时发生了一个错误: %s"%[url,error_string(error)])
		var _r:HttpRequestResult = HttpRequestResult.new()
		_r.request_url = url
		_r.request_data = data
		_r.request_headers = headers
		return _r
	await node.request_finished
	var result:HttpRequestResult = node.get_result()
	node.queue_free()
	return result


class HttpRequestInstance:
	extends HTTPRequest

	signal request_finished

	var request_url:String = ""
	var request_data:String = ""
	var request_headers:PackedStringArray = []
	var result:HttpRequestResult = HttpRequestResult.new()

	func _ready()->void:
		use_threads = true
		accept_gzip = false
		connect("request_completed",_http_request_completed)

	func _http_request_completed(_result:int, _response_code:int, _headers:PackedStringArray, _body:PackedByteArray)->void:
		result.request_url = request_url
		result.request_data = request_data
		result.request_headers = request_headers
		result.result_code = _result
		result.response_code = _response_code
		result.headers = _headers
		result.body = _body
		if _result != HTTPRequest.RESULT_SUCCESS:
			GuiManager.console_print_error("从 %s 获取Http请求结果时出现错误，错误代码为: %s"%[request_url,ClassDB.class_get_enum_constants("HTTPRequest","Result")[int(_result)]])
		else:
			GuiManager.console_print_success("成功从 %s 获取到Http请求的返回结果！"%[request_url])
		emit_signal("request_finished")
		
	func get_result()->HttpRequestResult:
		return result
