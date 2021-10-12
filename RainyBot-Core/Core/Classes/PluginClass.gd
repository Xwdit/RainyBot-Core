extends Node
	
class_name Plugin

var plugin_path:String = ""

var plugin_file:String = ""

var plugin_info:Dictionary = {
	"id":"",
	"name":"",
	"author":"",
	"version":"",
	"description":""
}

var plugin_config:Dictionary = {}
var plugin_data:Dictionary = {}


func _init():
	_on_init()
	

func _ready():
	_on_load()
	
	
func _exit_tree():
	_on_unload()


func _on_init():
	pass


func _on_load():
	pass


func _on_unload():
	pass


func set_plugin_info(info_dic:Dictionary):
	plugin_info = info_dic

	
func get_plugin_info():
	return plugin_info


func get_plugin_file():
	return plugin_file


func get_plugin_path():
	return plugin_path


func get_other_plugin_instance(plugin_id):
	return PluginManager.get_plugin_instance(plugin_id)


func send_mirai_command(command,sub_command=null,content={}):
	return MiraiManager.send_command(command,sub_command,content)

	
func send_http_get_request(url:String,timeout:float = 20):
	return HttpRequestManager.send_http_get_request(url,timeout)

	
func receive_message_events(enabled:bool):
	if enabled:
		add_to_group("message_event")
		print("已启用对Mirai消息事件的监听")
	else:
		remove_from_group("message_event")
		print("已禁用对Mirai消息事件的监听")

	
func receive_bot_events(enabled:bool):
	if enabled:
		add_to_group("bot_event")
		print("已启用对Mirai框架事件的监听")
	else:
		remove_from_group("bot_event")
		print("已禁用对Mirai框架事件的监听")

	
func receive_commands(enabled:bool):
	if enabled:
		add_to_group("command")
		print("已启用对用户命令的监听")
	else:
		remove_from_group("command")
		print("已禁用对用户命令的监听")


func register_command(command:String,need_arguments:bool,usages:Array,source:String):
	CommandManager.register_command(command,need_arguments,usages,source)


func unregister_command(command:String):
	CommandManager.unregister_command(command)
		

func is_connected_to_mirai():
	return MiraiManager.is_connected_to_mirai()
	
	
func init_plugin_config(default_config:Dictionary,config_description:Dictionary={}):
	print("正在加载插件配置文件.....")
	plugin_config = default_config
	var config_path = PluginManager.plugin_path + plugin_info["id"] + ".json"
	var file = File.new()
	if file.file_exists(config_path):
		var _err = file.open(config_path,File.READ)
		var _config = parse_json(file.get_as_text())
		file.close()
		if _config is Dictionary:
			if _config.has_all(default_config.keys()):
				for key in _config:
					if (_config[key] is String && _config[key] == "") or (_config[key] is bool && _config[key] == null):
						print("警告:检测到内容为空的配置项，可能会导致出现问题: ",key)
						print("可以前往以下路径来验证与修改配置: ",config_path)
				plugin_config = _config
				print("插件配置加载成功")
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
			file.store_string(to_json(plugin_config))
			file.close()
			print("配置文件创建成功，请访问以下路径进行配置: ",config_path)
			if !config_description.empty():
				print("配置选项说明:")
				for key in config_description:
					print(key,":",config_description[key])
			print("配置完成后请重载此插件")


func save_plugin_config():
	print("正在保存配置文件...")
	var config_path = PluginManager.plugin_path + plugin_info["id"] + ".json"
	var file = File.new()
	var _err = file.open(config_path,File.WRITE)
	if _err != OK:
		printerr("配置文件保存失败，请检查文件权限是否配置正确! 路径:",config_path)
		file.close()
	else:
		file.store_string(to_json(plugin_config))
		file.close()
		print("配置文件保存成功，路径: ",config_path)


func get_plugin_config(key):
	if plugin_config.has(key):
		return plugin_config[key]
		
		
func set_plugin_config(key,value,save_file:bool=true):
	plugin_config[key]=value
	if save_file:
		save_plugin_config()


func init_plugin_data():
	print("正在加载插件数据库.....")
	var data_path = PluginManager.plugin_path + plugin_info["id"] + ".rdb"
	var file = File.new()
	if file.file_exists(data_path):
		var _err = file.open(data_path,File.READ)
		var _data = file.get_var(true)
		file.close()
		if _data is Dictionary:
			plugin_data = _data
			print("插件数据库加载成功")
		else:
			printerr("插件数据库读取失败，请删除后重新生成! 路径:",data_path)
	else:
		print("没有已存在的数据库文件，正在生成新的数据库文件...")
		var _err = file.open(data_path,File.WRITE)
		if _err != OK:
			printerr("数据库文件创建失败，请检查文件权限是否配置正确! 路径:",data_path)
			file.close()
		else:
			file.store_var(plugin_data,true)
			file.close()
			print("数据库文件创建成功，路径: ",data_path)
			print("若发生任何数据库文件更改，请重载此插件")
			
			
func save_plugin_data():
	print("正在保存插件数据库.....")
	var data_path = PluginManager.plugin_path + plugin_info["id"] + ".rdb"
	var file = File.new()
	var _err = file.open(data_path,File.WRITE)
	if _err != OK:
		printerr("数据库文件保存失败，请检查文件权限是否配置正确! 路径:",data_path)
		file.close()
	else:
		file.store_var(plugin_data,true)
		file.close()
		print("数据库文件保存成功，路径: ",data_path)
		
		
func get_plugin_data(key):
	if plugin_data.has(key):
		return plugin_data[key]
		
		
func set_plugin_data(key,value,save_file:bool=true):
	plugin_data[key]=value
	if save_file:
		save_plugin_data()
