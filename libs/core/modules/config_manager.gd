extends Node


signal config_loaded


const default_config:Dictionary = {
	"update_enabled":true,
	"update_source":"GitHub",
	"ffmpeg_path":"",
	"silk_encoder_path":"",
	"output_cleanup_threshold":1000,
	"output_max_length":2000,
	"http_request_proxy":"",
	"output_warning_enabled":true
}

const config_description:Dictionary = {
	"update_enabled":"在这里设置是否启用自动更新检查，若为false则不会在启动时自动检查更新 (默认为true)",
	"update_source":"在这里填写自动更新/修复所使用的下载源，可填写GitHub(海外/中国港澳台地区推荐)或Gitee(中国大陆推荐，但可能因不明原因屏蔽文件)，默认为GitHub",
	"ffmpeg_path":"在这里填写ffmpeg可执行文件的绝对路径(请使用正斜杠\"/\"而不是反斜杠\"\\\")，或其位于RainyBot根目录下的相对路径(以res://作为前缀)，用于自动转换音频文件到可作为语音发送的.amr格式",
	"silk_encoder_path":"在这里填写silk-encoder可执行文件的绝对路径(请使用正斜杠\"/\"而不是反斜杠\"\\\")，或其位于RainyBot根目录下的相对路径(以res://作为前缀)，可用于与ffmpeg配合将音频文件自动转为音质更好的.slk语音格式",
	"output_cleanup_threshold":"在这里设置控制台自动清空历史输出的触发行数，较低的值可显著降低控制台的内存占用，若为小于或等于0的值则不进行自动清空 (默认为每1000行清空一次)",
	"output_max_length":"单次输出/打印的最大长度，超过此长度的部分将会被自动省略 (默认为1000个字符)",
	"http_request_proxy":"在这里设置RainyBot全局HTTP请求的代理服务器地址，格式需要为：\"主机名:端口号\"",
	"output_warning_enabled":"在这里设置是否开启控制台警告"
}

var loaded_config:Dictionary = default_config

var config_path:String = GlobalManager.config_path+"console.json"


func init_config()->void:
	GuiManager.console_print_warning("正在加载RainyBot控制台配置文件.....")
	if FileAccess.file_exists(config_path):
		var _config:Dictionary
		var json:JSON = JSON.new()
		var file:FileAccess = FileAccess.open(config_path,FileAccess.READ)
		var _json_err:int = json.parse(file.get_as_text()) if file else ERR_CANT_OPEN
		if !_json_err:
			_config = json.get_data()
		if !_config.is_empty():
			var missing_keys:Array = []
			var extra_keys:Array = []
			for k in default_config:
				if !_config.has(k):
					_config[k] = default_config[k]
					missing_keys.append(k)
			for k in _config:
				if !default_config.has(k):
					_config.erase(k)
					extra_keys.append(k)
			if !missing_keys.is_empty() or !extra_keys.is_empty():
				GuiManager.console_print_warning("检测到需要更新的配置项，正在尝试对配置文件进行更新.....")
				file = FileAccess.open(config_path,FileAccess.WRITE)
				if file:
					file.store_string(json.stringify(_config,"\t"))
					if !missing_keys.is_empty():
						GuiManager.console_print_success("成功在配置文件中新增了以下的配置项: "+str(missing_keys))
						if !config_description.is_empty():
							GuiManager.console_print_text("新增配置选项说明:")
							for key in missing_keys:
								GuiManager.console_print_text(key+":"+config_description[key])
					if !extra_keys.is_empty():
						GuiManager.console_print_success("成功从配置文件中移除了以下的配置项: "+str(extra_keys))
					GuiManager.console_print_warning("如有需要，您可以通过控制台菜单，或访问以下路径进行配置: "+config_path)
				else:
					GuiManager.console_print_error("配置文件更新失败，请检查文件权限是否配置正确! 路径:"+config_path)
					GuiManager.console_print_warning("若要重试请重启RainyBot!")
					return
			var is_valid_config:bool = true
			for key in _config:
				if (_config[key] is String && _config[key] == "") or (_config[key] == null):
					is_valid_config = false
					GuiManager.console_print_warning("警告: 检测到内容为空的配置项，可能会导致出现问题: "+key)
					GuiManager.console_print_warning("该配置项的描述为: %s" % config_description[key])
			if !is_valid_config:
				GuiManager.console_print_warning("可以通过控制台菜单，或前往以下路径来验证与修改配置: "+config_path)
				GuiManager.console_print_warning("配置完成后请重启RainyBot")
			loaded_config = _config
			GuiManager.console_print_success("RainyBot控制台配置文件加载成功！")
			emit_signal("config_loaded")
		else:
			GuiManager.console_print_error("配置文件读取失败，请删除配置文件后重新生成! 路径:"+config_path)
			GuiManager.console_print_warning("删除完毕后请重启RainyBot")
	else:
		GuiManager.console_print_warning("没有已存在的配置文件，正在生成新的配置文件...")
		var file:FileAccess = FileAccess.open(config_path,FileAccess.WRITE)
		if !file:
			GuiManager.console_print_error("配置文件创建失败，请检查文件权限是否配置正确! 路径:"+config_path)
			GuiManager.console_print_warning("若要重试请重启RainyBot")
		else:
			var json:JSON = JSON.new()
			file.store_string(json.stringify(loaded_config,"\t"))
			GuiManager.console_print_success("配置文件创建成功！如有需要，请通过控制台菜单，或访问以下路径进行配置: "+config_path)
			if !config_description.is_empty():
				GuiManager.console_print_text("配置选项说明:")
				for key in config_description:
					GuiManager.console_print_text(key+":"+config_description[key])
			GuiManager.console_print_warning("配置完成后请重启RainyBot")
			emit_signal("config_loaded")


func get_update_source()->String:
	return loaded_config["update_source"]
	
	
func is_update_enabled()->bool:
	return loaded_config["update_enabled"]


func is_output_warning_enabled()->bool:
	return loaded_config["output_warning_enabled"]


func get_ffmpeg_path()->String:
	if FileAccess.file_exists(loaded_config["ffmpeg_path"]):
		var path:String = loaded_config["ffmpeg_path"]
		return path.simplify_path().replacen("res://",GlobalManager.root_path)
	return ""
	
	
func get_silk_encoder_path()->String:
	if FileAccess.file_exists(loaded_config["silk_encoder_path"]):
		var path:String = loaded_config["silk_encoder_path"]
		return path.simplify_path().replacen("res://",GlobalManager.root_path)
	return ""
	
	
func get_output_cleanup_threshold()->int:
	return int(loaded_config["output_cleanup_threshold"])
	
	
func get_output_max_length()->int:
	return int(loaded_config["output_max_length"])
	
	
func get_http_request_proxy()->String:
	return loaded_config["http_request_proxy"]
