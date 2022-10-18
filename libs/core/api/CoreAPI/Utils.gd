extends CoreAPI #继承自CoreAPI


## RainyBot的实用工具类，其中提供了各种类型的便捷功能
class_name Utils


## 获取以HH:mm:ss为格式的当前时间文本
static func get_formated_time()->String:
	var os_time:Dictionary = Time.get_time_dict_from_system()
	var hour:String = get_beautifuler_num(os_time.hour)
	var minute:String = get_beautifuler_num(os_time.minute)
	var second:String = get_beautifuler_num(os_time.second)
	var time:String = hour + ":" + minute + ":" + second
	return time


## 返回传入数字的字符串，并在传入的数字小于10时在字符串前方加入一个"0"
static func get_beautifuler_num(num:int)->String:
	if num < 10:
		return "0"+str(num)
	else:
		return str(num)


## 通过await调用时，将发送一个Http Get请求到指定的URL，并在收到结果或超时后返回一个HttpRequestResult
## 需要的参数从左到右分别为 请求URL,请求headers(可选，默认为空数组),超时时间(可选，默认为20秒)
static func send_http_get_request(url:String,headers:PackedStringArray=PackedStringArray([]),timeout:int=20)->HttpRequestResult:
	var result:HttpRequestResult = await HttpRequestManager.send_http_get_request(url,headers,timeout)
	return result


## 通过await调用时，将发送一个Http Post请求到指定的URL，并在收到结果或超时后返回一个HttpRequestResult
## 需要的参数从左到右分别为 请求URL,请求内容(可选，默认为空字符串)，请求headers(可选，默认为空数组)，超时时间(可选，默认为20秒)
static func send_http_post_request(url:String,request_data="",headers:PackedStringArray=PackedStringArray([]),timeout:int=20)->HttpRequestResult:
	var result:HttpRequestResult = await HttpRequestManager.send_http_post_request(url,request_data,headers,timeout)
	return result


## 通过await调用时，将发送一个Http Put请求到指定的URL，并在收到结果或超时后返回一个HttpRequestResult
## 需要的参数从左到右分别为 请求URL,请求内容(可选，默认为字符串)，请求headers(可选，默认为空数组)，超时时间(可选，默认为20秒)
static func send_http_put_request(url:String,request_data="",headers:PackedStringArray=PackedStringArray([]),timeout:int=20)->HttpRequestResult:
	var result:HttpRequestResult = await HttpRequestManager.send_http_put_request(url,request_data,headers,timeout)
	return result


static func load_threaded(path:String,type_hint:String="",use_sub_threads:bool=false)->Resource:
	var res:Resource = await GlobalManager.load_threaded(path,type_hint,use_sub_threads)
	return res
	
	
static func create_timer(time_sec:float)->void:
	await GlobalManager.get_tree().create_timer(time_sec,true,true).timeout
