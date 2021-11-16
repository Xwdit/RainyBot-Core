extends Node


func send_http_get_request(url:String,_timeout:float = 20.0):
	GuiManager.console_print_warning("正在尝试发送Http Get请求到: "+url)
	var node:HttpRequestInstance = HttpRequestInstance.new()
	node.request_url = url
	node.use_threads = true
	add_child(node)
	var error = node.request(url)
	if error != OK:
		node.queue_free()
		GuiManager.console_print_error("发生了一个错误 " + str(error) + " 当发送Http Get请求到: " + url)
		return null
	_tick_request_timeout(node,_timeout)
	await node.request_finished
	var result = node.get_result()
	node.disconnect("request_completed",Callable(self,"_http_request_completed"))
	queue_free()
	return result


func _tick_request_timeout(request_ins:HttpRequestInstance,_timeout:float):
	await get_tree().create_timer(_timeout).timeout
	if is_instance_valid(request_ins) && request_ins.result == null:
		request_ins.emit_signal("request_finished")
		GuiManager.console_print_error("Http请求超时，无法获取到返回结果: "+str(request_ins.request_url))
