extends CoreAPI #继承自CoreAPI


## RainyBot的实用工具类，其中提供了各种类型的便捷功能
class_name Utils


## 获取以HH:mm:ss为格式的当前时间文本
static func get_formated_time()->String:
	var os_time:Dictionary = Time.get_time_dict_from_system()
	var hour:String = get_formated_num(os_time.hour)
	var minute:String = get_formated_num(os_time.minute)
	var second:String = get_formated_num(os_time.second)
	var time:String = hour + ":" + minute + ":" + second
	return time


## 返回传入数字的字符串，并在传入的数字小于10时在字符串前方加入一个"0"
static func get_formated_num(num:int)->String:
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


static func convert_to_voice(path:String,delete_origin:bool=false)->VoiceMessage:
	if !FileAccess.file_exists(path):
		GuiManager.console_print_error("指定的音频文件路径有误，无法将其转换为语音消息，请检查后再试！")
		return null
	if ConfigManager.get_ffmpeg_path().is_empty():
		GuiManager.console_print_error("ffmpeg可执行文件路径未设置或有误，因此无法进行语音消息转换，请检查配置文件后再试！")
		return null
	if path.get_extension() == "amr" or path.get_extension() == "silk":
		GuiManager.console_print_warning("指定的音频文件无需进行转换，将直接构造为语音消息实例")
		return VoiceMessage.init_path(path)
	var amr_convert_func:Callable = func(input_path:String):
		var _out_path:String = GlobalManager.cache_path+"voice-"+Time.get_datetime_string_from_system().replace(":","-")+"-"+str(randi())+".amr"
		var _code:int = OS.execute(ConfigManager.get_ffmpeg_path(),["-y","-i",input_path,"-ar","8000","-ac","1",_out_path])
		if _code != -1:
			return _out_path
		return ""
	var silk_convert_func:Callable = func(input_path:String):
		var _out_path:String = GlobalManager.cache_path+"voice-"+Time.get_datetime_string_from_system().replace(":","-")+"-"+str(randi())
		var _pcm_code:int = OS.execute(ConfigManager.get_ffmpeg_path(),["-y","-i",input_path,"-ar","24000","-acodec","pcm_s16le","-f","s16le","-ac","1",_out_path+".pcm"])
		if _pcm_code == -1:
			return ""
		var _slk_code:int = OS.execute(ConfigManager.get_silk_encoder_path(),[_out_path+".pcm",_out_path+".slk","-rate","24000","-tencent"])
		DirAccess.remove_absolute(_out_path+".pcm")
		if _slk_code == -1:
			return ""
		return _out_path+".slk"
	var _thread:Thread = Thread.new()
	GuiManager.console_print_warning("正在尝试将音频文件%s转换为可被发送的语音消息..."%path)
	var convert_func:Callable = silk_convert_func
	if ConfigManager.get_silk_encoder_path().is_empty():
		GuiManager.console_print_warning("未设置silk-encoder可执行文件路径或路径无效，因此将转换为音质较差的.amr格式...")
		convert_func = amr_convert_func
	var _start_time:int = Time.get_ticks_msec()
	var _err:int = _thread.start(convert_func.bind(path))
	if _err:
		GuiManager.console_print_error("语音消息转换线程启动失败，请检查文件路径后再试！")
		return null
	while _thread.is_alive():
		await GlobalManager.get_tree().physics_frame
	var output_path:String = _thread.wait_to_finish()
	var _end_time:int = Time.get_ticks_msec()
	var _passed_time:int = _end_time-_start_time
	if output_path.is_empty():
		GuiManager.console_print_error("转换音频文件时出现错误，无法将其转换为语音消息，请检查后再试！")
		return null
	GuiManager.console_print_success("成功将音频文件转换为语音消息，并缓存至以下路径："+output_path)
	GuiManager.console_print_success("本次转换用时：%s秒"%(_passed_time/1000.0))
	if delete_origin:
		DirAccess.remove_absolute(path)
		GuiManager.console_print_success("已删除转换为语音消息前的原音频文件：%s"%path)
	return VoiceMessage.init_path(output_path)
