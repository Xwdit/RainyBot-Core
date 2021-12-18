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


enum BlockMode{
	DISABLE,
	EVENT,
	FUNCTION,
	ALL
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


func get_plugin_filepath()->String:
	return plugin_path


func get_plugin_path()->String:
	return PluginManager.plugin_path


func get_plugin_runtime()->int:
	return plugin_time_passed
	

func get_plugin_instance(plugin_id:String)->Plugin:
	var ins = PluginManager.get_plugin_instance(plugin_id)
	if ins == null:
		Console.print_error("无法获取ID为%s的插件实例，可能是ID有误或插件未被加载；请检查依赖关系是否设置正确！" % [plugin_id])
	return ins


func get_data_path()->String:
	return PluginManager.plugin_data_path
	

func get_data_filepath()->String:
	return PluginManager.plugin_data_path + plugin_info["id"] + ".rdb"
	
	
func get_config_path()->String:
	return PluginManager.plugin_config_path
	
	
func get_config_filepath()->String:
	return PluginManager.plugin_config_path + plugin_info["id"] + ".json"
	
	
func is_config_loaded()->bool:
	return plugin_config_loaded
	
	
func is_data_loaded()->bool:
	return plugin_data_loaded


func register_event(event,function,priority:int=0,block_mode:int=BlockMode.ALL):
	if function is String:
		function = [Callable(self,function)]
	elif function is Callable:
		function = [function]
	if function is Array and function.size() > 0:
		var _arr = []
		for _func in function:
			if _func is String:
				_func = Callable(self,_func)
			if !(_func is Callable) or !_func.is_valid():
				Console.print_error("事件注册出错: 指定的函数无效或不存在！")
				return
			_arr.append(_func)
		var _callable = {"priority":priority,"function":_arr,"block_mode":block_mode}
		if event is GDScript and is_instance_valid(event):
			_register_event(event,_callable,priority)
		elif event is Array and event.size() > 0:
			for _e in event:
				if _e is GDScript and is_instance_valid(_e):
					_register_event(_e,_callable,priority)
				else:
					Console.print_error("事件注册出错: 指定内容不是一个事件类型！")
		else:
			Console.print_error("事件注册出错: 指定内容不是一个事件类型！")
	else:
		Console.print_error("事件注册出错: 指定的函数无效或不存在！")


func _register_event(event:GDScript,data_dic:Dictionary,priority:int):
	if plugin_event_dic.has(event):
		Console.print_error("事件注册出错: 无法重复注册事件%s，此插件已注册过此事件！" % [event.resource_path.get_file().replacen(".gd","")])
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
	Console.print_success("成功注册事件: %s (优先级:%s)" % [event.resource_path.get_file().replacen(".gd",""),str(priority)])


func unregister_event(event):
	if event is GDScript and is_instance_valid(event):
		_unregister_event(event)
	elif event is Array and event.size() > 0:
		for _e in event:
			if _e is GDScript and is_instance_valid(_e):
				_unregister_event(_e)
			else:
				Console.print_error("事件取消注册出错: 指定内容不是一个事件类型！")
	else:
		Console.print_error("事件取消注册出错: 指定内容不是一个事件类型！")


func _unregister_event(event:GDScript):
	if PluginManager.plugin_event_dic.has(event):
		var arr:Array = PluginManager.plugin_event_dic[event]
		if plugin_event_dic.has(event):
			arr.erase(plugin_event_dic[event])
			if arr.is_empty():
				PluginManager.plugin_event_dic.erase(event)
			plugin_event_dic.erase(event)
			Console.print_success("成功取消注册事件: %s!" % [event.resource_path.get_file().replacen(".gd","")])
			return
		Console.print_error("事件取消注册出错: 此插件未注册事件%s！"% [event.resource_path.get_file().replacen(".gd","")])
	else:
		Console.print_error("事件取消注册出错: 事件%s未被任何插件注册！"% [event.resource_path.get_file().replacen(".gd","")])


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
				Console.print_error("无法注册命令，因为传入的命令格式不合法！")
	else:
		Console.print_error("无法注册命令，因为传入的命令格式不合法！")


func _register_console_command(command:String,function:Callable,need_arguments:bool,usages:Array,need_connect:bool):
	if plugin_console_command_dic.has(command):
		Console.print_error("无法注册以下命令，因为此命令已在此插件被注册: " + command)
		return
	if (!function is Callable) or (!function.is_valid()):
		Console.print_error("无法注册以下命令，因为指定的函数不存在: " + command)
		return
	if CommandManager.register_console_command(command,need_arguments,usages,plugin_info.name,need_connect)==OK:
		plugin_console_command_dic[command] = function
		add_to_group("console_command_"+command)
		Console.print_success("成功注册命令: %s!" % [command])


func unregister_console_command(command):
	if command is String and command.length() > 0:
		_unregister_console_command(command)
	elif command is Array and command.size() > 0:
		for _c in command:
			if _c is String and _c.length() > 0:
				_unregister_console_command(_c)
			else:
				Console.print_error("无法取消注册命令，因为传入的命令格式不合法！")
	else:
		Console.print_error("无法取消注册命令，因为传入的命令格式不合法！")


func _unregister_console_command(command:String):
	if !plugin_console_command_dic.has(command):
		Console.print_error("无法取消注册以下命令，因为此命令不属于此插件: " + command)
		return
	if CommandManager.unregister_console_command(command) == OK:
		plugin_console_command_dic.erase(command)
		remove_from_group("console_command_"+command)
		Console.print_success("成功取消注册命令: %s!" % [command])
	

func register_keyword(keyword,function,var_dic:Dictionary={},match_mode:int=MatchMode.BEGIN,block:bool=true):
	if function is String:
		function = Callable(self,function)
	if keyword is String and keyword.length() > 0:
		_register_keyword(keyword,function,var_dic,match_mode,block)
	elif keyword is Array and keyword.size() > 0:
		for _k in keyword:
			if _k is String and _k.length() > 0:
				_register_keyword(_k,function,var_dic,match_mode,block)
			else:
				Console.print_error("无法注册关键词，因为传入的关键词格式不合法！")
	else:
		Console.print_error("无法注册关键词，因为传入的关键词格式不合法！")
	
	
func _register_keyword(keyword:String,function:Callable,var_dic:Dictionary,match_mode:int,block:bool):
	if plugin_keyword_dic.has(keyword):
		Console.print_error("无法注册以下关键词，因为此关键词已在此插件被注册: " + keyword)
		return
	if (!function is Callable) or (!function.is_valid()):
		Console.print_error("无法注册以下关键词，因为指定的函数不存在: " + keyword)
		return
	plugin_keyword_dic[keyword] = {"function":function,"var_dic":var_dic,"match_mode":match_mode,"block":block}
	_update_keyword_arr()
	Console.print_success("成功注册关键词: \"%s\"，匹配模式为: %s" % [keyword,match_mode_dic[match_mode]])
	
	
func unregister_keyword(keyword):
	if keyword is String and keyword.length() > 0:
		_unregister_keyword(keyword)
	elif keyword is Array and keyword.size() > 0:
		for _k in keyword:
			if _k is String and _k.length() > 0:
				_unregister_keyword(_k)
			else:
				Console.print_error("无法取消注册关键词，因为传入的关键词格式不合法！")
	else:
		Console.print_error("无法取消注册关键词，因为传入的关键词格式不合法！")
	
	
func _unregister_keyword(keyword:String):
	if !plugin_keyword_dic.has(keyword):
		Console.print_error("无法取消注册以下关键词，因为此关键词未在此插件被注册: " + keyword)
		return
	plugin_keyword_dic.erase(keyword)
	_update_keyword_arr()
	Console.print_success("成功取消注册关键词: \"%s\"!" % [keyword])
	

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
			var _var_dic:Dictionary = plugin_keyword_dic[_kw]["var_dic"]
			var _mode:int = plugin_keyword_dic[_kw]["match_mode"]
			var _block:bool = plugin_keyword_dic[_kw]["block"]
			var _word:String = _kw.format(_var_dic)
			if _word.begins_with("{@}"):
				if _at:
					_word = _word.substr(3)
					if _word.length() == 0:
						var _arg = _text
						_trigger_keyword(_func,_kw,_word,_arg,event)
						return _block
				else:
					continue
			match _mode:
				int(MatchMode.BEGIN):
					if _text.begins_with(_word):
						var _arg = _text.substr(_word.length())
						_trigger_keyword(_func,_kw,_word,_arg,event)
						return _block
				int(MatchMode.BETWEEN):
					var _idx = _text.find(_word)
					if _idx != -1 and (!(_text.begins_with(_word) or _text.ends_with(_word)) or _text == _word):
						var _arg = _text.left(_idx)+_text.substr(_idx+_word.length())
						_trigger_keyword(_func,_kw,_word,_arg,event)
						return _block
				int(MatchMode.END):
					if _text.ends_with(_word):
						var _arg = _text.left(_text.length()-_word.length())
						_trigger_keyword(_func,_kw,_word,_arg,event)
						return _block
				int(MatchMode.INCLUDE):
					var _idx = _text.find(_word)
					if _idx != -1:
						var _arg = _text.left(_idx)+_text.substr(_idx+_word.length())
						_trigger_keyword(_func,_kw,_word,_arg,event)
						return _block
				int(MatchMode.EXCLUDE):
					var _idx = _text.find(_word)
					if _idx == -1:
						var _arg = _text
						_trigger_keyword(_func,_kw,_word,_arg,event)
						return _block
				int(MatchMode.EQUAL):
					if _text == _word:
						var _arg = ""
						_trigger_keyword(_func,_kw,_word,_arg,event)
						return _block
				int(MatchMode.REGEX):
					if _text.match(_word):
						var _arg = _text
						_trigger_keyword(_func,_kw,_word,_arg,event)
						return _block
	else:
		Console.print_error("无法使用传入的事件来匹配关键词，请确保其是一个消息事件！")
	return false


func _trigger_keyword(_func:Callable,_kw:String,_word:String,_arg:String,event:MessageEvent):
	if _func.is_valid():
		Console.print_success("成功触发关键词:\"%s\"(解析后:\"%s\")，参数为:\"%s\"！"%[_kw,_word,_arg])
		_func.call(_kw,_word,_arg,event)
	else:
		Console.print_error("关键词\"%s\"试图触发的函数无效或不存在，请检查配置是否有误！"%[_kw])


func init_plugin_config(default_config:Dictionary,config_description:Dictionary={})->int:
	Console.print_warning("正在加载插件配置文件.....")
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
					if (_config[key] is String && _config[key] == "") or (_config[key] == null):
						Console.print_warning("警告:检测到内容为空的配置项，可能会导致出现问题: "+str(key))
						Console.print_warning("可以前往以下路径来验证与修改配置: "+config_path)
				plugin_config = _config
				plugin_config_loaded = true
				Console.print_success("插件配置加载成功")
				return OK
			else:
				Console.print_error("配置文件条目出现缺失，请删除配置文件后重新生成! 路径:"+config_path)
				return ERR_FILE_MISSING_DEPENDENCIES
		else:
			Console.print_error("配置文件读取失败，请删除配置文件后重新生成! 路径:"+config_path)
			return ERR_FILE_CANT_READ
	else:
		Console.print_warning("没有已存在的配置文件，正在生成新的配置文件...")
		var _err = file.open(config_path,File.WRITE)
		if _err != OK:
			Console.print_error("配置文件创建失败，请检查文件权限是否配置正确! 路径:"+config_path)
			file.close()
			return _err
		else:
			var json = JSON.new()
			file.store_string(json.stringify(plugin_config,"\t"))
			file.close()
			Console.print_success("配置文件创建成功，可以访问以下路径进行配置: "+config_path)
			if !config_description.is_empty():
				Console.print_text("配置选项说明:")
				for key in config_description:
					Console.print_text(str(key)+":"+str(config_description[key]))
			Console.print_warning("配置完成后请重新加载此插件!")
			plugin_config_loaded = true
			return OK


func save_plugin_config()->int:
	if !plugin_config_loaded:
		Console.print_error("配置文件保存失败，请先初始化配置后再执行此操作")
		return ERR_FILE_CANT_WRITE
	Console.print_warning("正在保存配置文件...")
	var config_path = PluginManager.plugin_config_path + plugin_info["id"] + ".json"
	var file = File.new()
	var _err = file.open(config_path,File.WRITE)
	if _err != OK:
		Console.print_error("配置文件保存失败，请检查文件权限是否配置正确! 路径:"+config_path)
		file.close()
		return _err
	else:
		var json = JSON.new()
		file.store_string(json.stringify(plugin_config,"\t"))
		file.close()
		Console.print_success("配置文件保存成功，路径: "+config_path)
		return OK


func get_plugin_config(key):
	if !plugin_config_loaded:
		Console.print_error("配置内容获取失败，请先初始化配置后再执行此操作")
		return null
	if plugin_config.has(key):
		return plugin_config[key]
	else:
		Console.print_error("配置内容获取失败，试图获取的key在插件数据库中不存在!")
		return null
		
		
func has_plugin_config(key)->bool:
	if !plugin_config_loaded:
		Console.print_error("配置内容获取失败，请先初始化配置后再执行此操作")
		return false
	return plugin_config.has(key)
		
		
func set_plugin_config(key,value,save_file:bool=true)->int:
	if !plugin_config_loaded:
		Console.print_error("配置内容设定失败，请先初始化配置后再执行此操作")
		return ERR_FILE_CANT_WRITE
	if plugin_config.has(key):
		plugin_config[key]=value
		if save_file:
			save_plugin_config()
		return OK
	else:
		Console.print_error("配置内容设定失败，试图设置的key在插件配置中不存在!")
		return ERR_FILE_CANT_WRITE


func get_plugin_config_metadata()->Dictionary:
	if !plugin_config_loaded:
		Console.print_error("配置内容获取失败，请先初始化配置后再执行此操作")
		return {}
	return plugin_config


func set_plugin_config_metadata(dic:Dictionary,save_file:bool=true)->int:
	if !plugin_config_loaded:
		Console.print_error("配置内容设定失败，请先初始化配置后再执行此操作")
		return ERR_FILE_CANT_WRITE
	plugin_config = dic
	if save_file:
		save_plugin_config()
	return OK
	
	
func get_plugin_data_metadata()->Dictionary:
	if !plugin_data_loaded:
		Console.print_error("数据库内容获取失败，请先初始化数据库后再执行此操作")
		return {}
	return plugin_data


func set_plugin_data_metadata(dic:Dictionary,save_file:bool=true)->int:
	if !plugin_data_loaded:
		Console.print_error("数据库内容设定失败，请先初始化数据库后再执行此操作")
		return ERR_DATABASE_CANT_WRITE
	plugin_data = dic
	if save_file:
		save_plugin_data()
	return OK


func init_plugin_data()->int:
	Console.print_warning("正在加载插件数据库.....")
	var data_path = PluginManager.plugin_data_path + plugin_info["id"] + ".rdb"
	var file = File.new()
	if file.file_exists(data_path):
		var _err = file.open(data_path,File.READ)
		var _data = file.get_var(true)
		file.close()
		if _data is Dictionary:
			plugin_data = _data
			plugin_data_loaded = true
			Console.print_success("插件数据库加载成功")
			return OK
		else:
			Console.print_error("插件数据库读取失败，请删除后重新生成! 路径:"+data_path)
			return ERR_DATABASE_CANT_READ
	else:
		Console.print_warning("没有已存在的数据库文件，正在生成新的数据库文件...")
		var _err = file.open(data_path,File.WRITE)
		if _err != OK:
			Console.print_error("数据库文件创建失败，请检查文件权限是否配置正确! 路径:"+data_path)
			file.close()
			return _err
		else:
			file.store_var(plugin_data,true)
			file.close()
			plugin_data_loaded = true
			Console.print_success("数据库文件创建成功，路径: "+data_path)
			Console.print_warning("若发生任何数据库文件更改，请重载此插件")
			return OK
			
			
func save_plugin_data()->int:
	if !plugin_data_loaded:
		Console.print_error("数据库文件保存失败，请先初始化数据库后再执行此操作")
		return ERR_DATABASE_CANT_WRITE
	Console.print_warning("正在保存插件数据库.....")
	var data_path = PluginManager.plugin_data_path + plugin_info["id"] + ".rdb"
	var file = File.new()
	var _err = file.open(data_path,File.WRITE)
	if _err != OK:
		Console.print_error("数据库文件保存失败，请检查文件权限是否配置正确! 路径:"+data_path)
		file.close()
		return _err
	else:
		file.store_var(plugin_data,true)
		file.close()
		Console.print_success("数据库文件保存成功，路径: "+data_path)
		return OK
		
		
func get_plugin_data(key):
	if !plugin_data_loaded:
		Console.print_error("数据库内容获取失败，请先初始化数据库后再执行此操作!")
		return null
	if plugin_data.has(key):
		return plugin_data[key]
	else:
		Console.print_error("数据库内容获取失败，试图获取的key在插件数据库中不存在!")
		return null
		
		
func has_plugin_data(key)->bool:
	if !plugin_data_loaded:
		Console.print_error("数据库内容获取失败，请先初始化数据库后再执行此操作!")
		return false
	return plugin_data.has(key)
		
		
func set_plugin_data(key,value,save_file:bool=true)->int:
	if !plugin_data_loaded:
		Console.print_error("数据库内容设定失败，请先初始化数据库后再执行此操作")
		return ERR_DATABASE_CANT_WRITE
	plugin_data[key]=value
	if save_file:
		save_plugin_data()
	return OK


func remove_plugin_data(key,save_file:bool=true)->int:
	if !plugin_data_loaded:
		Console.print_error("数据库内容删除失败，请先初始化数据库后再执行此操作!")
		return ERR_DATABASE_CANT_WRITE
	if plugin_data.has(key):
		plugin_data.erase(key)
		if save_file:
			save_plugin_data()
		return OK
	else:
		Console.print_error("数据库内容删除失败，试图删除的key在插件数据库中不存在!")
		return ERR_DATABASE_CANT_WRITE
		
		
func clear_plugin_data(save_file:bool=true)->int:
	if !plugin_data_loaded:
		Console.print_error("数据库内容清空失败，请先初始化数据库后再执行此操作!")
		return ERR_DATABASE_CANT_WRITE
	plugin_data.clear()
	if save_file:
		save_plugin_data()
	return OK


func unload_plugin():
	PluginManager.unload_plugin(self)


func wait_context_custom(event_type:GDScript,sender_id:int=-1,group_id:int=-1,timeout:float=20.0,block:bool=true):
	if event_type.get_base_script() != MessageEvent:
		Console.print_error("无法开始等待上下文响应，需要等待的事件类型应该是一个消息事件!")
		return null
	if group_id == -1 and sender_id == -1:
		Console.print_error("无法开始等待上下文响应，需要至少指定一个发送者ID或群组ID!")
		return null
	if !((event_type == GroupMessageEvent) or (event_type == TempMessageEvent)) and sender_id == -1:
		Console.print_error("无法开始等待上下文响应，此消息事件类型必须指定一个发送者ID!")
		return null
	var _dic = {}
	_dic["event"] = event_type.resource_path.get_file().replacen(".gd","")
	if sender_id != -1:
		_dic["sender_id"] = sender_id
	if ((event_type == GroupMessageEvent) or (event_type == TempMessageEvent)) and group_id != -1:
		_dic["group_id"] = group_id
	var context_id = str(_dic)
	return await wait_context_id(context_id,timeout,block)


func wait_context(event:MessageEvent,match_sender:bool=true,match_group:bool=true,timeout:float=20.0,block:bool=true):
	if !is_instance_valid(event):
		Console.print_error("无法开始等待上下文响应，需要等待的事件应该是一个有效的消息事件!")
		return null
	if !match_sender and !match_group:
		Console.print_error("无法开始等待上下文响应，需要至少指定一个将要匹配的条目!")
		return null
	if !((event is GroupMessageEvent) or (event is TempMessageEvent)) and !match_sender:
		Console.print_error("无法开始等待上下文响应，此类消息事件必须对发送者ID进行匹配!")
		return null
	var _dic = {}
	_dic["event"] = event.get_script().resource_path.get_file().replacen(".gd","")
	if match_sender:
		_dic["sender_id"] = event.get_sender_id()
	if ((event is GroupMessageEvent) or (event is TempMessageEvent)) and match_group:
		_dic["group_id"] = event.get_group_id()
	var context_id = str(_dic)
	return await wait_context_id(context_id,timeout,block)
	
	
func wait_context_id(context_id:String,timeout:float=20.0,block:bool=true):
	if context_id.length() < 1:
		Console.print_error("无法开始等待上下文响应，需要等待的上下文ID不能为空!")
		return null
	Console.print_warning("开始等待上下文响应，ID为: %s，超时时间为: %s秒！"%[context_id,str(timeout)])
	var _cont:PluginContextHelper
	if plugin_context_dic.has(context_id) && is_instance_valid(plugin_context_dic[context_id]):
		_cont = plugin_context_dic[context_id]
		timeout = 0.0
	else:
		_cont = PluginContextHelper.new()
		_cont.id = context_id
		_cont.block = block
		plugin_context_dic[context_id] = _cont
	if timeout > 0.0:
		_tick_context_timeout(_cont,timeout)
	await _cont.finished
	Console.print_warning("上下文已完成，ID为: %s，响应结果为: %s！"%[context_id,str(_cont.get_result())])
	plugin_context_dic.erase(context_id)
	return _cont.get_result()


func respond_context(context,response=true)->bool:
	var context_id = ""
	if context is String and context.length() > 0:
		context_id = context
	elif context is MessageEvent and is_instance_valid(context):
		var _event = context.get_script().resource_path.get_file().replacen(".gd","")
		var _sender = context.get_sender_id()
		var _dic_sender = {}
		var _dic_group = {}
		var _dic_all = {}
		_dic_sender["event"] = _event
		_dic_group["event"] = _event
		_dic_all["event"] = _event
		_dic_all["sender_id"] = _sender
		_dic_sender["sender_id"] = _sender
		if (context is GroupMessageEvent) or (context is TempMessageEvent):
			var _group = context.get_group_id()
			_dic_all["group_id"] = _group
			_dic_group["group_id"] = _group
		if plugin_context_dic.has(str(_dic_all)):
			context_id = str(_dic_all)
		elif plugin_context_dic.has(str(_dic_sender)):
			context_id = str(_dic_sender)
		elif plugin_context_dic.has(str(_dic_group)):
			context_id = str(_dic_group)
		response = context
	else:
		Console.print_error("无法响应上下文，需要响应的内容应该是一个上下文ID或一个消息事件")
	if plugin_context_dic.has(context_id) && is_instance_valid(plugin_context_dic[context_id]):
		var _cont:PluginContextHelper = plugin_context_dic[context_id]
		_cont.result = response
		_cont.emit_signal("finished")
		Console.print_success("成功响应上下文，ID为: %s，响应结果为: %s！"%[context_id,str(response)])
		return _cont.block
	elif context is String:
		Console.print_warning("未找到指定的上下文ID，无法进行响应: " + context_id)
	return false
		

func _tick_context_timeout(cont_ins:PluginContextHelper,_timeout:float):
	await get_tree().create_timer(_timeout).timeout
	if is_instance_valid(cont_ins) && cont_ins.result == null:
		Console.print_warning("等待上下文响应超时，无法获取到返回结果: "+str(cont_ins.id))
		cont_ins.emit_signal("finished")


class PluginContextHelper:
	extends RefCounted
	signal finished
	var id:String = ""
	var block:bool = false
	var result = null
	
	func get_result():
		return result
