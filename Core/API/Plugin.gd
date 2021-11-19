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
var plugin_event_dic:Dictionary = {}
var plugin_console_command_dic:Dictionary = {}
var plugin_timer:Timer = Timer.new()
var plugin_time_passed:int = 0


func _init():
	_on_init()
	

func _ready():
	plugin_timer.wait_time = 1
	plugin_timer.connect("timeout",Callable(self,"_plugin_timer_timeout"))
	add_child(plugin_timer)
	plugin_timer.start()
	_on_load()
	
	
func _exit_tree():
	_on_unload()


func _on_init():
	pass


func _on_load():
	pass


func _on_process():
	pass


func _on_unload():
	pass


func _call_event(event:String,ins:Event):
	if plugin_event_dic.has(event):
		var func_name = plugin_event_dic[event]
		call(func_name,ins)


func _call_console_command(cmd:String,args:Array):
	if plugin_console_command_dic.has(cmd):
		var func_name = plugin_console_command_dic[cmd]
		call(func_name,cmd,args)


func _plugin_timer_timeout():
	plugin_time_passed += 1
	_on_process()


func set_plugin_info(p_id:String,p_name:String,p_author:String,p_version:String,p_description:String):
	plugin_info.id = p_id
	plugin_info.name = p_name
	plugin_info.author = p_author
	plugin_info.version = p_version
	plugin_info.description = p_description

	
func get_plugin_info()->Dictionary:
	return plugin_info


func get_plugin_filename()->String:
	return plugin_file


func get_plugin_path()->String:
	return plugin_path


func set_plugin_runtime(time_sec:int):
	plugin_time_passed = time_sec


func get_plugin_runtime()->int:
	return plugin_time_passed
	

func get_other_plugin_instance(plugin_id)->Plugin:
	return PluginManager.get_plugin_instance(plugin_id)


func register_message_event(msg_event:int,func_name:String):
	plugin_event_dic[BotAdapter.message_event_name[msg_event]] = func_name
	add_to_group(BotAdapter.message_event_name[msg_event])


func unregister_message_event(msg_event:int):
	plugin_event_dic.erase(BotAdapter.message_event_name[msg_event])
	remove_from_group(BotAdapter.message_event_name[msg_event])


func register_console_command(command:String,func_name:String,need_arguments:bool=false,usages:Array=[]):
	if CommandManager.register_console_command(command,need_arguments,usages,plugin_info.name)==OK:
		plugin_console_command_dic[command] = func_name
		add_to_group("console_command_"+command)


func unregister_console_command(command:String):
	if CommandManager.unregister_console_command(command) == OK:
		plugin_console_command_dic.erase(command)
		remove_from_group("console_command_"+command)
	
	
func init_plugin_config(default_config:Dictionary,config_description:Dictionary={}):
	GuiManager.console_print_warning("正在加载插件配置文件.....")
	plugin_config = default_config
	var config_path = PluginManager.plugin_config_path + plugin_info["id"] + ".json"
	var file = File.new()
	if file.file_exists(config_path):
		var _err = file.open(config_path,File.READ)
		var json = JSON.new()
		json.parse(file.get_as_text())
		var _config = json.get_data()
		file.close()
		if _config is Dictionary:
			if _config.has_all(default_config.keys()):
				for key in _config:
					if (_config[key] is String && _config[key] == "") or (_config[key] is bool && _config[key] == null):
						GuiManager.console_print_warning("警告:检测到内容为空的配置项，可能会导致出现问题: "+str(key))
						GuiManager.console_print_warning("可以前往以下路径来验证与修改配置: "+config_path)
				plugin_config = _config
				GuiManager.console_print_success("插件配置加载成功")
				return
			else:
				GuiManager.console_print_error("配置文件条目出现缺失，请删除配置文件后重新生成! 路径:"+config_path)
		else:
			GuiManager.console_print_error("配置文件读取失败，请删除配置文件后重新生成! 路径:"+config_path)
	else:
		GuiManager.console_print_warning("没有已存在的配置文件，正在生成新的配置文件...")
		var _err = file.open(config_path,File.WRITE)
		if _err != OK:
			GuiManager.console_print_error("配置文件创建失败，请检查文件权限是否配置正确! 路径:"+config_path)
			file.close()
		else:
			var json = JSON.new()
			file.store_string(json.stringify(plugin_config))
			file.close()
			GuiManager.console_print_success("配置文件创建成功，请访问以下路径进行配置: "+config_path)
			if !config_description.is_empty():
				GuiManager.console_print_text("配置选项说明:")
				for key in config_description:
					GuiManager.console_print_text(key+":"+config_description[key])
			GuiManager.console_print_warning("配置完成后请重新加载此插件")
	unload_plugin()


func save_plugin_config():
	GuiManager.console_print_warning("正在保存配置文件...")
	var config_path = PluginManager.plugin_config_path + plugin_info["id"] + ".json"
	var file = File.new()
	var _err = file.open(config_path,File.WRITE)
	if _err != OK:
		GuiManager.console_print_error("配置文件保存失败，请检查文件权限是否配置正确! 路径:"+config_path)
		file.close()
	else:
		var json = JSON.new()
		file.store_string(json.stringify(plugin_config))
		file.close()
		GuiManager.console_print_success("配置文件保存成功，路径: "+config_path)


func get_plugin_config(key):
	if plugin_config.has(key):
		return plugin_config[key]
		
		
func set_plugin_config(key,value,save_file:bool=true):
	plugin_config[key]=value
	if save_file:
		save_plugin_config()


func get_plugin_config_metadata()->Dictionary:
	return plugin_config


func set_plugin_config_metadata(dic:Dictionary):
	plugin_config = dic
	
	
func get_plugin_data_metadata()->Dictionary:
	return plugin_data


func set_plugin_data_metadata(dic:Dictionary):
	plugin_data = dic


func init_plugin_data():
	GuiManager.console_print_warning("正在加载插件数据库.....")
	var data_path = PluginManager.plugin_data_path + plugin_info["id"] + ".rdb"
	var file = File.new()
	if file.file_exists(data_path):
		var _err = file.open(data_path,File.READ)
		var _data = file.get_var(true)
		file.close()
		if _data is Dictionary:
			plugin_data = _data
			GuiManager.console_print_success("插件数据库加载成功")
			return
		else:
			GuiManager.console_print_error("插件数据库读取失败，请删除后重新生成! 路径:"+data_path)
	else:
		GuiManager.console_print_warning("没有已存在的数据库文件，正在生成新的数据库文件...")
		var _err = file.open(data_path,File.WRITE)
		if _err != OK:
			GuiManager.console_print_error("数据库文件创建失败，请检查文件权限是否配置正确! 路径:"+data_path)
			file.close()
		else:
			file.store_var(plugin_data,true)
			file.close()
			GuiManager.console_print_success("数据库文件创建成功，路径: "+data_path)
			GuiManager.console_print_warning("若发生任何数据库文件更改，请重载此插件")
			return
	unload_plugin()
			
			
func save_plugin_data():
	GuiManager.console_print_warning("正在保存插件数据库.....")
	var data_path = PluginManager.plugin_data_path + plugin_info["id"] + ".rdb"
	var file = File.new()
	var _err = file.open(data_path,File.WRITE)
	if _err != OK:
		GuiManager.console_print_error("数据库文件保存失败，请检查文件权限是否配置正确! 路径:"+data_path)
		file.close()
	else:
		file.store_var(plugin_data,true)
		file.close()
		GuiManager.console_print_success("数据库文件保存成功，路径: "+data_path)
		
		
func get_plugin_data(key):
	if plugin_data.has(key):
		return plugin_data[key]
		
		
func set_plugin_data(key,value,save_file:bool=true):
	plugin_data[key]=value
	if save_file:
		save_plugin_data()


func unload_plugin():
	PluginManager.unload_plugin(self)
