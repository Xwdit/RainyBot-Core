extends Node


signal config_loaded


const default_config:Dictionary = {
	"update_source":"GitHub"
}

const config_description:Dictionary = {
	"update_source":"在这里填写自动更新/修复所使用的下载源，可填写GitHub(海外/中国港澳台地区推荐)或Gitee(中国大陆推荐，但可能因不明原因屏蔽文件)，默认为GitHub"
}

var loaded_config:Dictionary = default_config

var config_path:String = GlobalManager.config_path+"console.json"


func init_config()->void:
	GuiManager.console_print_warning("正在加载RainyBot控制台配置文件.....")
	var file:File = File.new()
	if file.file_exists(config_path):
		var _config:Dictionary
		var json:JSON = JSON.new()
		var _file_err:int = file.open(config_path,File.READ)
		var _json_err:int = json.parse(file.get_as_text())
		file.close()
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
				_file_err = file.open(config_path,File.WRITE)
				if !_file_err:
					file.store_string(json.stringify(_config,"\t"))
					file.close()
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
					file.close()
					GuiManager.console_print_error("配置文件更新失败，请检查文件权限是否配置正确! 路径:"+config_path)
					GuiManager.console_print_warning("若要重试请重启RainyBot!")
					return
			for key in _config:
				if (_config[key] is String && _config[key] == "") or (_config[key] == null):
					GuiManager.console_print_warning("警告: 检测到内容为空的配置项，可能会导致出现问题: "+key)
					GuiManager.console_print_warning("该配置项的描述为: %s" % config_description[key])
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
		var _err:int = file.open(config_path,File.WRITE)
		if _err:
			GuiManager.console_print_error("配置文件创建失败，请检查文件权限是否配置正确! 路径:"+config_path)
			GuiManager.console_print_warning("若要重试请重启RainyBot")
			file.close()
		else:
			var json:JSON = JSON.new()
			file.store_string(json.stringify(loaded_config,"\t"))
			file.close()
			GuiManager.console_print_success("配置文件创建成功！如有需要，请通过控制台菜单，或访问以下路径进行配置: "+config_path)
			if !config_description.is_empty():
				GuiManager.console_print_text("配置选项说明:")
				for key in config_description:
					GuiManager.console_print_text(key+":"+config_description[key])
			GuiManager.console_print_warning("配置完成后请重启RainyBot")
			emit_signal("config_loaded")


func get_update_source()->String:
	return loaded_config["update_source"]
