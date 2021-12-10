extends Node
	
class_name Plugin


enum MatchMode{
	BEGIN,
	BETWEEN,
	END,
	INCLUDE,
	EXCLUDE,
	EQUAL,
	REGEX
}


var match_mode_dic:Dictionary = {
	int(MatchMode.BEGIN) : "关键词位于开头",
	int(MatchMode.BETWEEN) : "关键词位于中间",
	int(MatchMode.END) : "关键词位于结尾",
	int(MatchMode.INCLUDE) : "包含关键词",
	int(MatchMode.EXCLUDE) : "不包含关键词",
	int(MatchMode.EQUAL) : "与关键词完全相等",
	int(MatchMode.REGEX) : "满足正则表达式"
}

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
var plugin_keyword_dic:Dictionary = {}
var plugin_keyword_arr:Array = []
var plugin_console_command_dic:Dictionary = {}
var plugin_timer:Timer = null
var plugin_time_passed:int = 0
var plugin_config_loaded = false
var plugin_data_loaded = false


func _init():
	_on_init()
	

func _ready():
	plugin_timer = Timer.new()
	plugin_timer.one_shot = false
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
	for kw in plugin_keyword_dic.duplicate():
		unregister_keyword(kw)
	if plugin_config_loaded:
		save_plugin_config()
	if plugin_data_loaded:
		save_plugin_data()


func _on_init():
	pass


func _on_connect():
	pass


func _on_load():
	pass


func _on_ready():
	pass


func _on_process():
	pass


func _on_disconnect():
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


func set_plugin_info(p_id:String,p_name:String,p_author:String,p_version:String,p_description:String,p_dependency=[]):
	plugin_info.id = p_id
	plugin_info.name = p_name
	plugin_info.author = p_author
	plugin_info.version = p_version
	plugin_info.description = p_description
	if p_dependency is String:
		p_dependency = [p_dependency]
	plugin_info.dependency = p_dependency

	
func get_plugin_info()->Dictionary:
	return plugin_info


func get_plugin_filename()->String:
	return plugin_file


func get_plugin_path()->String:
	return plugin_path


func get_plugin_runtime()->int:
	return plugin_time_passed
	

func get_plugin_instance(plugin_id:String)->Plugin:
	var ins = PluginManager.get_plugin_instance(plugin_id)
	if ins == null:
		GuiManager.console_print_error("无法获取ID为%s的插件实例，可能是ID有误或插件未被加载；请检查依赖关系是否设置正确！" % [plugin_id])
	return ins


func register_event(event,function,priority:int=0):
func register_event(event,function="",priority:int=0,can_block:bool=true):
	if function is String:
		function = Callable(self,function)
	if function is Callable and function.is_valid():
		var _callable = {"priority":priority,"function":function,"can_block":can_block}
		if event is GDScript and is_instance_valid(event):
			_register_event(event,_callable,priority)
		elif event is Array and event.size() > 0:
			for _e in event:
				if _e is GDScript and is_instance_valid(_e):
					_register_event(_e,_callable,priority)
				else:
					GuiManager.console_print_error("事件注册出错: 指定内容不是一个事件类型！")
		else:
			GuiManager.console_print_error("事件注册出错: 指定内容不是一个事件类型！")
	else:
		GuiManager.console_print_error("事件注册出错: 指定的函数不存在！")


func _register_event(event:GDScript,data_dic:Dictionary,priority:int):
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
			arr.insert(_idx,data_dic)
		else:
			arr.insert(_idx+1,data_dic)
	else:
		arr.append(data_dic)	
	plugin_event_dic[event]=data_dic
	GuiManager.console_print_success("成功注册事件: %s (优先级:%s)" % [event.resource_path.get_file().replacen(".gd",""),str(priority)])


func unregister_event(event):
	if event is GDScript and is_instance_valid(event):
		_unregister_event(event)
	elif event is Array and event.size() > 0:
		for _e in event:
			if _e is GDScript and is_instance_valid(_e):
				_unregister_event(_e)
			else:
				GuiManager.console_print_error("事件取消注册出错: 指定内容不是一个事件类型！")
	else:
		GuiManager.console_print_error("事件取消注册出错: 指定内容不是一个事件类型！")


func _unregister_event(event:GDScript):
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


func register_console_command(command,function,need_arguments:bool=false,usages:Array=[],need_connect:bool=false):
	if function is String:
		function = Callable(self,function)
	if command is String and command.length() > 0:
		_register_console_command(command,function,need_arguments,usages,need_connect)
	elif command is Array and command.size() > 0:
		for _c in command:
			if _c is String and _c.length() > 0:
				_register_console_command(_c,function,need_arguments,usages,need_connect)
			else:
				GuiManager.console_print_error("无法注册命令，因为传入的命令格式不合法！")
	else:
		GuiManager.console_print_error("无法注册命令，因为传入的命令格式不合法！")


func _register_console_command(command:String,function:Callable,need_arguments:bool,usages:Array,need_connect:bool):
	if plugin_console_command_dic.has(command):
		GuiManager.console_print_error("无法注册以下命令，因为此命令已在此插件被注册: " + command)
		return
	if (!function is Callable) or (!function.is_valid()):
		GuiManager.console_print_error("无法注册以下命令，因为指定的函数不存在: " + command)
		return
	if CommandManager.register_console_command(command,need_arguments,usages,plugin_info.name,need_connect)==OK:
		plugin_console_command_dic[command] = function
		add_to_group("console_command_"+command)
		GuiManager.console_print_success("成功注册命令: %s!" % [command])


func unregister_console_command(command):
	if command is String and command.length() > 0:
		_unregister_console_command(command)
	elif command is Array and command.size() > 0:
		for _c in command:
			if _c is String and _c.length() > 0:
				_unregister_console_command(_c)
			else:
				GuiManager.console_print_error("无法取消注册命令，因为传入的命令格式不合法！")
	else:
		GuiManager.console_print_error("无法取消注册命令，因为传入的命令格式不合法！")


func _unregister_console_command(command:String):
	if !plugin_console_command_dic.has(command):
		GuiManager.console_print_error("无法取消注册以下命令，因为此命令不属于此插件: " + command)
		return
	if CommandManager.unregister_console_command(command) == OK:
		plugin_console_command_dic.erase(command)
		remove_from_group("console_command_"+command)
		GuiManager.console_print_success("成功取消注册命令: %s!" % [command])
	

func register_keyword(keyword,function,filter="null",failed_reply:String="",match_mode:int=MatchMode.BEGIN):
	if function is String:
		function = Callable(self,function)
	if filter is String:
		if filter == "":
			filter = "null"
		filter = Callable(self,filter)
	if keyword is String and keyword.length() > 0:
		_register_keyword(keyword,function,filter,failed_reply,match_mode)
	elif keyword is Array and keyword.size() > 0:
		for _k in keyword:
			if _k is String and _k.length() > 0:
				_register_keyword(_k,function,filter,failed_reply,match_mode)
			else:
				GuiManager.console_print_error("无法注册关键词，因为传入的关键词格式不合法！")
	else:
		GuiManager.console_print_error("无法注册关键词，因为传入的关键词格式不合法！")
	
	
func _register_keyword(keyword:String,function:Callable,filter:Callable,failed_reply:String,match_mode:int):
	if plugin_keyword_dic.has(keyword):
		GuiManager.console_print_error("无法注册以下关键词，因为此关键词已在此插件被注册: " + keyword)
		return
	if (!function is Callable) or (!function.is_valid()):
		GuiManager.console_print_error("无法注册以下关键词，因为指定的函数不存在: " + keyword)
		return
	if (!filter is Callable) or (!filter.is_valid()):
		GuiManager.console_print_warning("警告: 过滤器函数未定义或不存在，所有人默认将可触发关键词\"%s\"!"%[keyword])
	plugin_keyword_dic[keyword] = {"function":function,"filter":filter,"failed_reply":failed_reply,"match_mode":match_mode}
	_update_keyword_arr()
	GuiManager.console_print_success("成功注册关键词: \"%s\"，匹配模式为: %s" % [keyword,match_mode_dic[match_mode]])
	
	
func unregister_keyword(keyword):
	if keyword is String and keyword.length() > 0:
		_unregister_keyword(keyword)
	elif keyword is Array and keyword.size() > 0:
		for _k in keyword:
			if _k is String and _k.length() > 0:
				_unregister_keyword(_k)
			else:
				GuiManager.console_print_error("无法取消注册关键词，因为传入的关键词格式不合法！")
	else:
		GuiManager.console_print_error("无法取消注册关键词，因为传入的关键词格式不合法！")
	
	
func _unregister_keyword(keyword:String):
	if !plugin_keyword_dic.has(keyword):
		GuiManager.console_print_error("无法取消注册以下关键词，因为此关键词未在此插件被注册: " + keyword)
		return
	plugin_keyword_dic.erase(keyword)
	_update_keyword_arr()
	GuiManager.console_print_success("成功取消注册关键词: \"%s\"!" % [keyword])
	

func _sort_keyword(_a:String,_b:String)->bool:
	if _a.length() > _b.length():
		return true
	return false


func _update_keyword_arr():
	var _arr:Array = plugin_keyword_dic.keys()
	_arr.sort_custom(_sort_keyword)
	plugin_keyword_arr = _arr

	
func trigger_keyword(event:Event)->bool:
	if event is MessageEvent and is_instance_valid(event):
		var _at:bool = false
		var _text:String = ""
		for msg in event.get_message_chain():
			if msg is AtMessage:
				if msg.get_target_id() == BotAdapter.get_bot_id():
					_text += msg.get_as_text()
					_at = true
			elif msg is TextMessage:
				_text += msg.get_as_text()
		if _at:
			_text = _text.replace("@"+str(BotAdapter.get_bot_id())+" ","")
		for _kw in plugin_keyword_arr:
			var _func:Callable = plugin_keyword_dic[_kw]["function"]
			var _filter:Callable = plugin_keyword_dic[_kw]["filter"]
			var _rep:String = plugin_keyword_dic[_kw]["failed_reply"]
			var _mode:int = plugin_keyword_dic[_kw]["match_mode"]
			var _word:String = _kw
			if _kw.begins_with("[@]"):
				if _at:
					_word = _kw.substr(3)
					if _word.length() == 0:
						var _arg = _text
						_trigger_keyword(_func,_filter,_kw,_arg,event,_rep)
						return true
				else:
					continue
			match _mode:
				int(MatchMode.BEGIN):
					if _text.begins_with(_word):
						var _arg = _text.substr(_word.length())
						_trigger_keyword(_func,_filter,_kw,_arg,event,_rep)
						return true
				int(MatchMode.BETWEEN):
					var _idx = _text.find(_word)
					if _idx != -1 and (!(_text.begins_with(_word) or _text.ends_with(_word)) or _text == _word):
						var _arg = _text.left(_idx)+_text.substr(_idx+_word.length())
						_trigger_keyword(_func,_filter,_kw,_arg,event,_rep)
						return true
				int(MatchMode.END):
					if _text.ends_with(_word):
						var _arg = _text.left(_text.length()-_word.length())
						_trigger_keyword(_func,_filter,_kw,_arg,event,_rep)
						return true
				int(MatchMode.INCLUDE):
					var _idx = _text.find(_word)
					if _idx != -1:
						var _arg = _text.left(_idx)+_text.substr(_idx+_word.length())
						_trigger_keyword(_func,_filter,_kw,_arg,event,_rep)
						return true
				int(MatchMode.EXCLUDE):
					var _idx = _text.find(_word)
					if _idx == -1:
						var _arg = _text
						_trigger_keyword(_func,_filter,_kw,_arg,event,_rep)
						return true
				int(MatchMode.EQUAL):
					if _text == _word:
						var _arg = ""
						_trigger_keyword(_func,_filter,_kw,_arg,event,_rep)
						return true
				int(MatchMode.REGEX):
					if _text.match(_word):
						var _arg = _text
						_trigger_keyword(_func,_filter,_kw,_arg,event,_rep)
						return true
	else:
		GuiManager.console_print_error("无法使用传入的事件来匹配关键词，请确保其是一个消息事件！")
	return false


func _trigger_keyword(_func:Callable,_filter:Callable,_kw:String,_arg:String,event:MessageEvent,_rep:String):
	GuiManager.console_print_warning("匹配到关键词:\"%s\"，参数为:\"%s\" | 正在检查是否可以触发....."%[_kw,_arg])
	if _filter.is_valid():
		if !_filter.call(_kw,_arg,event):
			GuiManager.console_print_warning("关键词触发过滤器检测不通过，未触发关键词.....")
			if _rep != "":
				GuiManager.console_print_warning("正在发送检测未通过时的自定义回复:\"%s\""%[_rep])
				event.reply(_rep,true,true)
			return
	else:
		GuiManager.console_print_warning("关键词触发过滤器函数无效或未定义，将直接触发关键词.....")
	if _func.is_valid():
		GuiManager.console_print_success("成功触发关键词:\"%s\"，参数为:\"%s\"！"%[_kw,_arg])
		_func.call(_kw,_arg,event)
	else:
		GuiManager.console_print_error("关键词试图触发的函数无效或不存在，请检查配置是否有误！")


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
	if plugin_context_dic.has(context_id) && is_instance_valid(plugin_context_dic[context_id]):
		_cont = plugin_context_dic[context_id]
		timeout = 0.0
	else:
		_cont = PluginContextHelper.new()
		_cont.id = context_id
		plugin_context_dic[context_id] = _cont
	if timeout > 0.0:
		_tick_context_timeout(_cont,timeout)
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
