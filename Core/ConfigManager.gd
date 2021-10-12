extends Node

var config_path = OS.get_executable_path().get_base_dir() + "/" + "config.json"

var default_config = {
	"mirai-address":"127.0.0.1",
	"mirai-port":"8080",
	"mirai_verify_key_enabled":true,
	"mirai_verify_key":"#DEFAULT12345",
	"mirai_qq":"12345",
}

var config_description = {
	"mirai-address":"在这里填写连接到Mirai框架的地址，默认为127.0.0.1",
	"mirai-port":"在这里填写连接到Mirai框架的端口，默认为8080",
	"mirai_verify_key_enabled":"是否启用连接时的验证密钥，默认为true",
	"mirai_verify_key":"若启用连接验证，请在这里输入验证密钥",
	"mirai_qq":"要连接到的机器人QQ号码",
}

var loaded_config = default_config


func init_config():
	print("正在加载配置文件.....")
	var file = File.new()
	if file.file_exists(config_path):
		var _err = file.open(config_path,File.READ)
		var _config = parse_json(file.get_as_text())
		file.close()
		if _config is Dictionary:
			if _config.has_all(default_config.keys()):
				if _config["mirai_verify_key"] == "#DEFAULT12345":
					printerr("检测到您还未修改默认配置，请进行修改!")
					print("可以前往以下路径来验证与修改配置: ",config_path)
					return
				for key in _config:
					if (_config[key] is String && _config[key] == "") or (_config[key] is bool && _config[key] == null):
						print("警告:检测到内容为空的配置项，可能会导致出现问题: ",key)
						print("可以前往以下路径来验证与修改配置: ",config_path)
				loaded_config = _config
				print("配置加载成功")
				var ws = get_ws_address(loaded_config)
				MiraiManager.connect_to_mirai(ws)
			else:
				printerr("配置文件条目出现缺失，请删除配置文件后重新生成! 路径:",config_path)
		else:
			printerr("配置文件读取失败，请删除配置文件后重新生成! 路径:",config_path)
	else:
		print("没有已存在的配置文件，正在生成新的配置文件...")
		var _err = file.open(config_path,File.WRITE)
		if _err != OK:
			printerr("配置文件创建失败，请检查文件权限是否配置正确! 路径:",config_path)
			file.close()
		else:
			file.store_string(to_json(loaded_config))
			file.close()
			print("配置文件创建成功，请访问以下路径进行配置: ",config_path)
			print("配置选项说明:")
			for key in config_description:
				print(key,":",config_description[key])
			print("配置完成后请重启RainyBot")
			
	
func get_ws_address(config_dic:Dictionary):
	var ws_text = "ws://{mirai-address}:{mirai-port}/all?verifyKey={mirai_verify_key}&qq={mirai_qq}"
	if !config_dic["mirai_verify_key_enabled"]:
		ws_text = "ws://{mirai-address}:{mirai-port}/all?qq={mirai_qq}"
	return ws_text.format(config_dic)
