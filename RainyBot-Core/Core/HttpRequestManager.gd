extends Node


func send_http_get_request(url:String,timeout:float = 20):
	print("正在尝试发送Http Get请求到: ",url)
	var node:HttpRequestInstance = HttpRequestInstance.new()
	node.request_url = url
	node.use_threads = true
	add_child(node)
	var error = node.request(url)
	if error != OK:
		node.queue_free()
		printerr("发生了一个错误 " + str(error) + " 当发送Http Get请求到: " + url)
		return null
	_tick_request_timeout(node,timeout)
	return node


func _tick_request_timeout(request_ins:HttpRequestInstance,timeout:float):
	yield(get_tree().create_timer(timeout),"timeout")
	if is_instance_valid(request_ins) && request_ins.result == null:
		request_ins.emit_signal("request_finished")
		printerr("Http请求超时，无法获取到返回结果: ",request_ins.request_url)
