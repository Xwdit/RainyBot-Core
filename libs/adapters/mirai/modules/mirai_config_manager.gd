extends Node


class_name MiraiConfigManager


signal config_loaded


const default_config = {
	"mirai_address":"127.0.0.1",
	"mirai_port":"8080",
	"mirai_verify_key_enabled":false,
	"mirai_verify_key":"",
	"mirai_qq":"",
	"mirai_qq_password":"$DEFAULT12345",
	"mirai_protocol":"ANDROID_PAD",
	"mirai_request_timeout":20.0
}

const config_description = {
	"mirai_address":"在这里填写连接到Mirai框架的地址，默认为127.0.0.1",
	"mirai_port":"在这里填写连接到Mirai框架的端口，默认为8080",
	"mirai_verify_key_enabled":"是否启用连接时的验证密钥，以防止未经授权的连接，默认为false",
	"mirai_verify_key":"若启用连接验证，请在这里输入验证密钥",
	"mirai_qq":"要连接到的机器人的QQ号码",
	"mirai_qq_password":"要连接到的机器人的QQ密码",
	"mirai_protocol":"要使用的设备协议，默认为ANDROID_PAD，可修改为ANDROID_PHONE/ANDROID_WATCH",
	"mirai_request_timeout":"等待单条Mirai指令请求回应的最大超时时间，默认为20秒，设置为小于或等于0的值将禁用超时"
}

var loaded_config = default_config

var config_path = GlobalManager.config_path+"mirai_adapter.json"


func init_config():
	Console.print_warning("正在加载Mirai-Adapter配置文件.....")
	var file = File.new()
	if file.file_exists(config_path):
		var _err = file.open(config_path,File.READ)
		var json = JSON.new()
		json.parse(file.get_as_text())
		var _config = json.get_data()
		file.close()
		if _config is Dictionary:
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
				Console.print_warning("检测到需要更新的配置项，正在尝试对配置文件进行更新.....")
				_err = file.open(config_path,File.WRITE)
				if _err == OK:
					file.store_string(json.stringify(_config,"\t"))
					file.close()
					if !missing_keys.is_empty():
						Console.print_success("成功在配置文件中新增了以下的配置项: "+str(missing_keys))
						if !config_description.is_empty():
							Console.print_text("新增配置选项说明:")
							for key in missing_keys:
								Console.print_text(key+":"+config_description[key])
					if !extra_keys.is_empty():
						Console.print_success("成功从配置文件中移除了以下的配置项: "+str(extra_keys))
					Console.print_warning("如有需要，您可以通过协议后端菜单，或访问以下路径进行配置: "+config_path)
				else:
					file.close()
					Console.print_error("配置文件更新失败，请检查文件权限是否配置正确! 路径:"+config_path)
					Console.print_warning("若要重试请重启RainyBot!")
					return
			if _config["mirai_qq_password"] == "$DEFAULT12345":
				Console.print_error("检测到您还未修改默认配置，请进行修改!")
				Console.print_error("可以通过协议后端菜单，或前往以下路径来验证与修改配置: "+config_path)
				if !config_description.is_empty():
					Console.print_text("配置选项说明:")
					for key in config_description:
						Console.print_text(key+":"+config_description[key])
				Console.print_warning("配置完成后请重启RainyBot")
				return
			for key in _config:
				if (_config[key] is String && _config[key] == "") or (_config[key] == null):
					Console.print_warning("警告: 检测到内容为空的配置项，可能会导致出现问题: "+key)
					Console.print_warning("该配置项的描述为: %s" % config_description[key])
					Console.print_warning("可以通过协议后端菜单，或前往以下路径来验证与修改配置: "+config_path)
					Console.print_warning("配置完成后请重启RainyBot")
			loaded_config = _config
			Console.print_success("Mirai-Adapter配置文件加载成功！")
			emit_signal("config_loaded")
		else:
			Console.print_error("配置文件读取失败，请删除配置文件后重新生成! 路径:"+config_path)
			Console.print_warning("删除完毕后请重启RainyBot")
	else:
		Console.print_warning("没有已存在的配置文件，正在生成新的配置文件...")
		var _err = file.open(config_path,File.WRITE)
		if _err != OK:
			Console.print_error("配置文件创建失败，请检查文件权限是否配置正确! 路径:"+config_path)
			Console.print_warning("若要重试请重启RainyBot")
			file.close()
		else:
			var json = JSON.new()
			file.store_string(json.stringify(loaded_config,"\t"))
			file.close()
			Console.print_success("配置文件创建成功，请通过协议后端菜单，或访问以下路径进行配置: "+config_path)
			if !config_description.is_empty():
				Console.print_text("配置选项说明:")
				for key in config_description:
					Console.print_text(key+":"+config_description[key])
			Console.print_warning("配置完成后请重启RainyBot")
			

func get_ws_address(config_dic:Dictionary):
	var ws_text = "ws://{mirai_address}:{mirai_port}/all?verifyKey={mirai_verify_key}&qq={mirai_qq}"
	if !config_dic["mirai_verify_key_enabled"]:
		ws_text = "ws://{mirai_address}:{mirai_port}/all?qq={mirai_qq}"
	return ws_text.format(config_dic)
	
	
func get_bot_id()->int:
	return loaded_config.mirai_qq.to_int()
	
	
func get_request_timeout()->float:
	return float(loaded_config.mirai_request_timeout)
