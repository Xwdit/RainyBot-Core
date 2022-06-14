extends CoreAPI #继承自CoreAPI


## RainyBot的Http请求结果类，可从其中快速获取某次Http请求的结果数据
class_name HttpRequestResult


var request_url:String = ""
var request_data:String = ""
var request_headers:PackedStringArray = []
var result_code:int = 0
var response_code:int = 0
var headers:PackedStringArray = []
var body:PackedByteArray = []


## 获取此请求的URL字符串
func get_request_url()->String:
	return request_url
	

## 获取此请求的请求数据字符串
func get_request_data()->String:
	return request_data
	

## 将此请求的请求数据解析为字典并返回
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
	

## 获取此请求的headers数组
func get_request_headers()->PackedStringArray:
	return request_headers
	

## 获取此请求的结果状态	
func get_result_status()->int:
	return result_code
	

## 获取此请求的结果响应码	
func get_response_code()->int:
	return response_code
	

## 获取此请求的结果的headers
func get_headers()->PackedStringArray:
	return headers


## 尝试将此请求的结果解析为字符串并返回
func get_as_text()->String:
	return body.get_string_from_utf8()
	

## 尝试将此请求的结果解析为字典并返回
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


## 直接返回此请求的结果的元二进制数据数组
func get_as_byte()->PackedByteArray:
	return body
