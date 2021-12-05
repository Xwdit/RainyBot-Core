extends Node
	
class_name Plugin

var plugin_path:String = ""

var plugin_file:String = ""

var plugin_info:Dictionary = {
	"id":"",
	"name":"",
	"author":"",
	"version":"",
	"description":"",
	"dependency":[]
}

var plugin_config:Dictionary = {}
var plugin_data:Dictionary = {}
var plugin_event_dic:Dictionary = {}
var plugin_context_dic:Dictionary = {}
var plugin_console_command_dic:Dictionary = {}
var plugin_timer:Timer = Timer.new()
var plugin_time_passed:int = 0
var plugin_config_loaded = false
var plugin_data_loaded = false


func _init():
	_on_init()
	

func _ready():
	plugin_timer.wait_time = 1
	plugin_timer.connect("timeout",_plugin_timer_timeout)
	add_child(plugin_timer)
	plugin_timer.start()
	_on_load()
	
	
func _exit_tree():
	_on_unload()
	for ev in plugin_event_dic.duplicate():
		unregister_event(ev)
	for cmd in plugin_console_command_dic.duplicate():
		unregister_console_command(cmd)


func _on_init():
	pass


func _on_load():
	pass


func _on_process():
	pass


func _on_unload():
	pass


func _call_console_command(cmd:String,args:Array):
	if plugin_console_command_dic.has(cmd):
		var function:Callable = plugin_console_command_dic[cmd]
		function.call(cmd,args)


func _plugin_timer_timeout():
	plugin_time_passed += 1
	_on_process()


func set_plugin_info(p_id:String,p_name:String,p_author:String,p_version:String,p_description:String,p_dependency:Array=[]):
	plugin_info.id = p_id
	plugin_info.name = p_name
	plugin_info.author = p_author
	plugin_info.version = p_version
	plugin_info.description = p_description
	plugin_info.dependency = p_dependency

	
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
	

func get_other_plugin_instance(plugin_id:String)->Plugin:
	var ins = PluginManager.get_plugin_instance(plugin_id)
	if ins == null:
		GuiManager.console_print_error("无法获取ID为%s的插件实例，可能是ID有误或插件未被加载；请检查依赖关系是否设置正确！" % [plugin_id])
	return ins


func register_event(event:GDScript,function:Callable,priority:int=0):
	if function.is_valid():
		var _callable = {"priority":priority,"function":function}
		if is_instance_valid(event):
			if plugin_event_dic.has(event):
				GuiManager.console_print_error("事件注册出错: 无法重复注册事件%s，此插件已注册过此事件！" % [event.resource_path.get_file().replacen(".gd","")])
				return
			var arr:Array = []
			if PluginManager.plugin_event_dic.has(event):
				arr = PluginManager.plugin_event_dic[event]
			else:
				PluginManager.plugin_event_dic[event] = arr
			if arr.size() != 0:
				var _idx = 0
				for _i in range(arr.size()):
					var _pri:int = arr[_i]["priority"]
					if priority >= _pri:
						_idx = _i
				if arr[_idx]["priority"] > priority:
					arr.insert(_idx,_callable)
				else:
					arr.insert(_idx+1,_callable)
			else:
				arr.append(_callable)	
			plugin_event_dic[event]=_callable
			GuiManager.console_print_success("成功注册事件: %s (优先级:%s)" % [event.resource_path.get_file().replacen(".gd",""),str(priority)])
		else:
			GuiManager.console_print_error("事件注册出错: 指定内容不是一个事件类型！")
	else:
		GuiManager.console_print_error("事件注册出错: 指定的函数不存在！")


func unregister_event(event:GDScript):
	if is_instance_valid(event):
		if PluginManager.plugin_event_dic.has(event):
			var arr:Array = PluginManager.plugin_event_dic[event]
			if plugin_event_dic.has(event):
				arr.erase(plugin_event_dic[event])
				if arr.is_empty():
					PluginManager.plugin_event_dic.erase(event)
				plugin_event_dic.erase(event)
				GuiManager.console_print_success("成功取消注册事件: %s!" % [event.resource_path.get_file().replacen(".gd","")])
				return
			GuiManager.console_print_error("事件取消注册出错: 此插件未注册事件%s！"% [event.resource_path.get_file().replacen(".gd","")])
		else:
			GuiManager.console_print_error("事件取消注册出错: 事件%s未被任何插件注册！"% [event.resource_path.get_file().replacen(".gd","")])
	else:
		GuiManager.console_print_error("事件取消注册出错: 指定内容不是一个事件类型！")


func register_console_command(command:String,function:Callable,need_arguments:bool=false,usages:Array=[]):
	if plugin_console_command_dic.has(command):
		GuiManager.console_print_error("无法注册以下命令，因为此命令已在此插件被注册: " + command)
		return
	if !function.is_valid():
		GuiManager.console_print_error("无法注册以下命令，因为指定的函数不存在: " + command)
		return
	if CommandManager.register_console_command(command,need_arguments,usages,plugin_info.name)==OK:
		plugin_console_command_dic[command] = function
		add_to_group("console_command_"+command)
		GuiManager.console_print_success("成功注册命令: %s!" % [command])


func unregister_console_command(command:String):
	if !plugin_console_command_dic.has(command):
		GuiManager.console_print_error("无法取消注册以下命令，因为此命令不属于此插件: " + command)
		return
	if CommandManager.unregister_console_command(command) == OK:
		plugin_console_command_dic.erase(command)
		remove_from_group("console_command_"+command)
		GuiManager.console_print_success("成功取消注册命令: %s!" % [command])
	
	
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
				plugin_config_loaded = true
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
			file.store_string(json.stringify(plugin_config,"\t"))
			file.close()
			GuiManager.console_print_success("配置文件创建成功，请访问以下路径进行配置: "+config_path)
			if !config_description.is_empty():
				GuiManager.console_print_text("配置选项说明:")
				for key in config_description:
					GuiManager.console_print_text(key+":"+config_description[key])
			GuiManager.console_print_warning("配置完成后请重新加载此插件")
	unload_plugin()


func save_plugin_config():
	if !plugin_config_loaded:
		GuiManager.console_print_error("配置文件保存失败，请先初始化配置后再执行此操作")
		return
	GuiManager.console_print_warning("正在保存配置文件...")
	var config_path = PluginManager.plugin_config_path + plugin_info["id"] + ".json"
	var file = File.new()
	var _err = file.open(config_path,File.WRITE)
	if _err != OK:
		GuiManager.console_print_error("配置文件保存失败，请检查文件权限是否配置正确! 路径:"+config_path)
		file.close()
	else:
		var json = JSON.new()
		file.store_string(json.stringify(plugin_config,"\t"))
		file.close()
		GuiManager.console_print_success("配置文件保存成功，路径: "+config_path)


func get_plugin_config(key):
	if !plugin_config_loaded:
		GuiManager.console_print_error("配置内容获取失败，请先初始化配置后再执行此操作")
		return
	if plugin_config.has(key):
		return plugin_config[key]
		
		
func set_plugin_config(key,value,save_file:bool=true):
	if !plugin_config_loaded:
		GuiManager.console_print_error("配置内容设定失败，请先初始化配置后再执行此操作")
		return
	plugin_config[key]=value
	if save_file:
		save_plugin_config()


func get_plugin_config_metadata()->Dictionary:
	if !plugin_config_loaded:
		GuiManager.console_print_error("配置内容获取失败，请先初始化配置后再执行此操作")
		return {}
	return plugin_config


func set_plugin_config_metadata(dic:Dictionary,save_file:bool=true):
	if !plugin_config_loaded:
		GuiManager.console_print_error("配置内容设定失败，请先初始化配置后再执行此操作")
		return
	plugin_config = dic
	if save_file:
		save_plugin_config()
	
	
func get_plugin_data_metadata()->Dictionary:
	if !plugin_data_loaded:
		GuiManager.console_print_error("数据库内容获取失败，请先初始化数据库后再执行此操作")
		return {}
	return plugin_data


func set_plugin_data_metadata(dic:Dictionary,save_file:bool=true):
	if !plugin_data_loaded:
		GuiManager.console_print_error("数据库内容设定失败，请先初始化数据库后再执行此操作")
		return
	plugin_data = dic
	if save_file:
		save_plugin_data()


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
			plugin_data_loaded = true
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
			plugin_data_loaded = true
			GuiManager.console_print_success("数据库文件创建成功，路径: "+data_path)
			GuiManager.console_print_warning("若发生任何数据库文件更改，请重载此插件")
			return
	unload_plugin()
			
			
func save_plugin_data():
	if !plugin_data_loaded:
		GuiManager.console_print_error("数据库文件保存失败，请先初始化数据库后再执行此操作")
		return
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
	if !plugin_data_loaded:
		GuiManager.console_print_error("数据库内容获取失败，请先初始化数据库后再执行此操作")
		return
	if plugin_data.has(key):
		return plugin_data[key]
		
		
func set_plugin_data(key,value,save_file:bool=true):
	if !plugin_data_loaded:
		GuiManager.console_print_error("数据库内容设定失败，请先初始化数据库后再执行此操作")
		return
	plugin_data[key]=value
	if save_file:
		save_plugin_data()


func unload_plugin():
	PluginManager.unload_plugin(self)


func wait_context(context_id:String,timeout:float=20.0):
	GuiManager.console_print_warning("开始等待上下文响应，ID为: %s，超时时间为: %s秒！"%[context_id,str(timeout)])
	var _cont:PluginContextHelper
	var _timeout:int = timeout
	if plugin_context_dic.has(context_id) && is_instance_valid(plugin_context_dic[context_id]):
		_cont = plugin_context_dic[context_id]
		_timeout = 0.0
	else:
		_cont = PluginContextHelper.new()
		_cont.id = context_id
		plugin_context_dic[context_id] = _cont
	if _timeout > 0.0:
		_tick_context_timeout(_cont,_timeout)
	await _cont.finished
	GuiManager.console_print_warning("上下文已完成，ID为: %s，响应结果为: %s！"%[context_id,str(_cont.get_result())])
	plugin_context_dic.erase(context_id)
	return _cont.get_result()


func respond_context(context_id:String,response):
	if plugin_context_dic.has(context_id) && is_instance_valid(plugin_context_dic[context_id]):
		var _cont:PluginContextHelper = plugin_context_dic[context_id]
		_cont.result = response
		_cont.emit_signal("finished")
		GuiManager.console_print_success("成功回应上下文，ID为: %s，响应结果为: %s！"%[context_id,str(response)])
	else:
		GuiManager.console_print_warning("未找到指定的上下文ID，无法进行回应: " + context_id)
		

func _tick_context_timeout(cont_ins:PluginContextHelper,_timeout:float):
	await get_tree().create_timer(_timeout).timeout
	if is_instance_valid(cont_ins) && cont_ins.result == null:
		GuiManager.console_print_warning("等待上下文响应超时，无法获取到返回结果: "+str(cont_ins.id))
		cont_ins.emit_signal("finished")


class PluginContextHelper:
	extends RefCounted
	signal finished
	var id:String = ""
	var result = null
	
	func get_result():
		return result
