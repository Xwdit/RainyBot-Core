extends RefCounted


class_name HttpRequestResult


var request_url:String = ""
var request_data:String = ""
var request_headers:PackedStringArray = []
var result_code:int = 0
var response_code:int = 0
var headers:PackedStringArray = []
var body:PackedByteArray = []


func get_request_url()->String:
	return request_url
	
	
func get_request_data()->String:
	return request_data
	
	
func get_request_data_dic()->Dictionary:
	var _json = JSON.new()
	var _error = _json.parse(request_data)
	var _data:Dictionary = {}
	if _error == OK:
		_data = _json.get_data()
		Console.print_success("成功将Http请求数据获取为字典: "+str(_data))
	else:
		Console.print_error("无法将Http请求数据获取为字典!")
	return _data
	
	
func get_request_headers()->PackedStringArray:
	return request_headers
	
	
func get_result_status()->int:
	return result_code
	
	
func get_response_code()->int:
	return response_code
	
	
func get_headers()->PackedStringArray:
	return headers


func get_as_text()->String:
	return body.get_string_from_utf8()
	
	
func get_as_dic()->Dictionary:
	var _json = JSON.new()
	var _error = _json.parse(body.get_string_from_utf8())
	var _result:Dictionary = {}
	if _error == OK:
		_result = _json.get_data()
		Console.print_success("成功将Http请求结果获取为字典: "+str(_result))
	else:
		Console.print_error("无法将Http请求结果获取为字典!")
	return _result


func get_as_byte()->PackedByteArray:
	return body
