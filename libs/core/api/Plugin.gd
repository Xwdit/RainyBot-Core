extends Node #继承Node类，用于RainyBot内部处理与加载，请勿进行改动

##
## RainyBot的插件类，代表一个实例，用于在插件中实现各类相关功能
##
##
## 这是RainyBot的插件类，代表一个插件实例，用于在插件中实现各类相关功能。
## 所有插件应当继承此类，以便在RainyBot中正确加载与运行。
##

class_name Plugin #定义类名为Plugin，请勿进行改动


## 关键词的匹配模式枚举，决定了触发某关键词判定的条件
enum MatchMode{
	BEGIN, ## 仅当关键词位于消息开头时触发判定
	BETWEEN, ## 仅当关键词位于消息中间时触发判定
	END, ## 仅当关键词位于消息末尾时触发判定
	INCLUDE, ## 消息中只要包含关键词就触发判定
	EXCLUDE, ## 消息中只要不包含关键词就触发判定
	EQUAL, ## 消息与关键词完全匹配时触发判定
	REGEX ## 消息满足正则表达式时触发判定（此时关键词内容应为一个正则表达式）
}


## 事件在处理时被标记为停止传递后的阻断模式枚举，决定了该事件将如何被阻断传递
enum BlockMode{
	DISABLE, ## 即使标记为停止传递也不会进行阻断
	EVENT, ## 在当前插件中的所有该事件函数处理完毕后，将阻断传递，即不会传递给后续插件
	FUNCTION, ## 当前函数处理完毕后，阻断事件在当前插件内的传递，但后续插件仍会接收到事件
	ALL ## 当前函数处理完毕后，将完全阻断事件传递，事件后续函数及其他插件均不会收到事件
}


const match_mode_dic:Dictionary = {
	int(MatchMode.BEGIN) : "关键词位于开头",
	int(MatchMode.BETWEEN) : "关键词位于中间",
	int(MatchMode.END) : "关键词位于结尾",
	int(MatchMode.INCLUDE) : "包含关键词",
	int(MatchMode.EXCLUDE) : "不包含关键词",
	int(MatchMode.EQUAL) : "与关键词完全相等",
	int(MatchMode.REGEX) : "满足正则表达式"
}

const block_mode_dic:Dictionary = {
	int(BlockMode.DISABLE) : "即使标记为停止传递也不会进行阻断",
	int(BlockMode.EVENT) : "若标记为停止传递，在当前插件中的所有该事件函数处理完毕后，将阻断传递，不会传递给后续插件",
	int(BlockMode.FUNCTION) : "若标记为停止传递，在当前函数处理完毕后，将阻断事件在当前插件内的传递，但后续插件仍会接收到事件",
	int(BlockMode.ALL) : "若标记为停止传递，在当前函数处理完毕后，将完全阻断事件传递，事件后续函数及其他插件均不会收到事件",
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

var default_plugin_config:Dictionary = {}
var plugin_config:Dictionary = {}
var plugin_data:Dictionary = {}
var plugin_cache:Dictionary = {}
var plugin_event_dic:Dictionary = {}
var plugin_context_dic:Dictionary = {}
var plugin_keyword_dic:Dictionary = {}
var plugin_keyword_arr:Array = []
var plugin_console_command_dic:Dictionary = {}
var plugin_timer:Timer = null
var plugin_time_passed:int = 0
var plugin_config_loaded:bool = false
var plugin_data_loaded:bool = false
var plugin_cache_loaded:bool = false


func _init()->void:
	_on_init()
	

func _ready()->void:
	plugin_timer = Timer.new()
	plugin_timer.one_shot = false
	plugin_timer.wait_time = 1
	plugin_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	plugin_timer.connect("timeout",_plugin_timer_timeout)
	add_child(plugin_timer)
	plugin_timer.start()
	_on_load()
	
	
func _exit_tree()->void:
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
	if plugin_cache_loaded:
		save_plugin_cache()


## 在插件中覆盖此虚函数，以便定义将在此插件的文件被读取时执行的操作
## 必须在此处使用set_plugin_info函数来设置插件信息，插件才能被正常加载
## 例如：set_plugin_info("example","示例插件","author","1.0","这是插件的介绍")
## 可以在此处初始化和使用一些基本变量，但不建议执行其它代码，可能会导致出现未知问题
func _on_init()->void:
	pass


## 在插件中覆盖此虚函数，以便定义RainyBot在与协议后端建立连接后插件将执行的操作
## 可以在此处进行一些与连接状态相关的操作，例如恢复连接后发送通知等
func _on_connect()->void:
	pass


## 在插件中覆盖此虚函数，以便定义插件在被加载完毕后执行的操作
## 可以在此处进行各类事件/关键词/命令的注册，以及配置/数据文件的初始化等
func _on_load()->void:
	pass


## 在插件中覆盖此虚函数，以便定义插件在所有其他插件加载完毕后执行的操作
## 可以在此处进行一些与其他插件交互相关的操作，例如获取某插件的实例等
## 注意：如果此插件硬性依赖某插件，推荐在插件信息中注册所依赖的插件，以确保其在此插件之前被正确加载
func _on_ready()->void:
	pass


## 在插件中覆盖此虚函数，以便定义插件运行中的每一秒将执行的操作
## 可在此处进行一些计时，或时间判定相关的操作，例如整点报时等
func _on_process()->void:
	pass


## 在插件中覆盖此虚函数，以便定义在RainyBot检测到运行时错误后将执行的操作
## 您可以使用[method get_last_errors]函数来获取错误的详细内容
func _on_error()->void:
	pass


## 在插件中覆盖此虚函数，以便定义RainyBot在与协议后端断开建立连接后插件将执行的操作
## 可以在此处进行一些与连接状态相关的操作，例如断开连接后暂停某些任务的运行等
func _on_disconnect()->void:
	pass


## 在插件中覆盖此虚函数，以便定义插件在即将被卸载时执行的操作
## 可在此处执行一些自定义保存或清理相关的操作，例如储存自定义的文件或清除缓存等
## 无需在此处取消注册事件/关键词/命令，或者对内置的配置/数据功能进行保存，插件卸载时将会自动进行处理
func _on_unload()->void:
	pass


func _call_console_command(cmd:String,args:Array)->void:
	if plugin_console_command_dic.has(cmd):
		var function:Callable = plugin_console_command_dic[cmd].function
		function.call(cmd,args)


func _plugin_timer_timeout()->void:
	plugin_time_passed += 1
	_on_process()


## 用于设定插件的相关信息，需要在_on_init()虚函数中执行以便RainyBot正确加载您的插件
## 需要的参数从左到右分别为插件ID(不可与其它已加载插件重复),插件名,插件作者,插件版本,插件描述,插件依赖(可选)
## 最后一项可选参数为此插件的依赖插件列表(数组)，需要以所依赖的插件的ID作为列表中的元素，如:["example","example_1"]
## 设置了插件依赖后，可以保证所依赖的插件一定在此插件之前被加载
func set_plugin_info(p_id:String,p_name:String,p_author:String,p_version:String,p_description:String,p_dependency=[])->void:
	plugin_info.id = p_id.to_lower()
	plugin_info.name = p_name
	plugin_info.author = p_author
	plugin_info.version = p_version
	plugin_info.description = p_description
	if p_dependency is String:
		p_dependency = [p_dependency.to_lower()]
	elif p_dependency is Array:
		for i in range(p_dependency.size()):
			if p_dependency[i] is String:
				p_dependency[i]=p_dependency[i].to_lower()
			else:
				p_dependency.clear()
				break
	else:
		p_dependency = []
	plugin_info.dependency = p_dependency


## 用于获取插件的相关信息，将返回一个包含插件信息的字典
## 使用id,name,author,version,description,dependency作为key即可从字典中获取对应信息
func get_plugin_info()->Dictionary:
	return plugin_info


## 用于获取插件对应的文件名，将返回插件文件的名称 (如ChatBot.gd)
func get_plugin_filename()->String:
	return plugin_file


## 用于获取插件对应的文件路径，将返回插件文件的绝对路径 (如 D://RainyBot/plugins/ChatBot.gd)
func get_plugin_filepath()->String:
	return plugin_path


## 用于获取RainyBot的插件文件夹的路径，将返回插件文件夹的绝对路径 (如 D://RainyBot/plugins/)
static func get_plugin_path()->String:
	return PluginManager.plugin_path


## 用于获取插件的已运行时间，默认情况下为插件成功加载以来经过的秒数
func get_plugin_runtime()->int:
	return plugin_time_passed
	

## 用于获取RainyBot全局的已运行时间，默认情况下为RainyBot成功加载以来经过的秒数
static func get_global_runtime()->int:
	return GlobalManager.global_run_time


## 用于获取其他插件的实例引用，可用于插件之间的联动与数据互通等
## 需要传入其他插件的ID作为参数来获取其实例，若未找到插件则返回null
static func get_plugin_instance(plugin_id:String)->Plugin:
	var ins:Plugin = PluginManager.get_plugin_instance(plugin_id)
	if ins == null:
		GuiManager.console_print_error("无法获取ID为%s的插件实例，可能是ID有误或插件未被加载；请检查依赖关系是否设置正确！" % [plugin_id])
	return ins


## 用于获取RainyBot的数据文件夹的路径，将返回数据文件夹的绝对路径 (如 D://RainyBot/data/)
static func get_data_path()->String:
	return PluginManager.plugin_data_path
	

## 用于获取该插件对应的数据库文件的路径，即插件对应的.rdb格式文件的绝对路径
func get_data_filepath()->String:
	return PluginManager.plugin_data_path + plugin_info["id"] + ".rdb"
	

## 用于获取RainyBot的配置文件夹的路径，将返回配置文件夹的绝对路径 (如 D://RainyBot/config/)	
static func get_config_path()->String:
	return PluginManager.plugin_config_path
	

## 用于获取该插件对应的配置文件的路径，即插件对应的.json格式文件的绝对路径
func get_config_filepath()->String:
	return PluginManager.plugin_config_path + plugin_info["id"] + ".json"
	

## 用于获取RainyBot的缓存文件夹的路径，将返回缓存文件夹的绝对路径 (如 D://RainyBot/cache)
static func get_cache_path()->String:
	return PluginManager.plugin_cache_path
	
	
## 用于获取该插件对应的缓存数据库文件的路径，即插件对应的.rca格式文件的绝对路径
func get_cache_filepath()->String:
	return PluginManager.plugin_cache_path + plugin_info["id"] + ".rca"


## 用于检查插件对应的配置文件内容是否已被加载
func is_config_loaded()->bool:
	return plugin_config_loaded
	

## 用于检查插件对应的数据库文件内容是否已被加载
func is_data_loaded()->bool:
	return plugin_data_loaded


## 用于检查插件对应的缓存数据库文件内容是否已被加载
func is_cache_loaded()->bool:
	return plugin_cache_loaded


static func get_last_errors()->PackedStringArray:
	return GlobalManager.last_errors


## 用于注册一个或多个事件并将其绑定到一个或多个函数，事件发生时将触发绑定的函数并传入事件实例
## 需要的参数从左到右分别为:
## 事件的类型:
## - 此处可传入单个事件类型名，或一个包含了任意数量事件类型名的数组以批量注册事件
## - 传入的事件需要直接或间接继承Event类，如GroupMessageEvent(群消息事件)
##
## 事件绑定的函数名:
## - 此处可传入单个函数名，或一个包含了任意数量函数名的数组以批量绑定函数
## - 当对应事件发生时将依次传递并触发绑定的函数，绑定的函数需要定义一个参数用于接收事件实例
##
## 事件的全局优先级(可选,默认为0):
## - 在多个插件同时注册了同一事件后，事件发生时将按照优先级由高到低的顺序传递事件到对应的插件
## - 优先级相同时，将根据注册事件的时间顺序来依次传递事件
##
## 事件的阻断模式(可选,默认为BlockMode.ALL):
## - 事件绑定的函数若返回true，将阻断事件被传递到后续函数或插件中 (异步函数无效)
## - 阻断的具体行为将由阻断模式决定, 每种阻断模式的具体效果请参见上方的BlockMode枚举
func register_event(event,function,priority:int=0,block_mode:int=BlockMode.ALL)->void:
	if function is String:
		function = [Callable(self,function)]
	elif function is Callable:
		function = [function]
	if function is Array and function.size() > 0:
		var _arr:Array = []
		for _func in function:
			if _func is String:
				_func = Callable(self,_func)
			if !(_func is Callable) or !_func.is_valid():
				GuiManager.console_print_error("事件注册出错: 指定的函数无效或不存在！")
				return
			_arr.append(_func)
		var _callable:Dictionary = {"priority":priority,"function":_arr,"block_mode":block_mode}
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
		GuiManager.console_print_error("事件注册出错: 指定的函数无效或不存在！")


func _register_event(event:GDScript,data_dic:Dictionary,priority:int)->void:
	if plugin_event_dic.has(event):
		GuiManager.console_print_error("事件注册出错: 无法重复注册事件%s，此插件已注册过此事件！" % [event.resource_path.get_file().replacen(".gd","")])
		return
	var arr:Array = []
	if PluginManager.plugin_event_dic.has(event):
		arr = PluginManager.plugin_event_dic[event]
	else:
		PluginManager.plugin_event_dic[event] = arr
	if arr.size() != 0:
		var _idx:int = 0
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


## 用于取消注册一个或多个事件，取消注册后插件将不再对此事件做出响应
## 此处可传入单个事件类型名，或一个包含了任意数量事件类型名的数组以批量取消注册事件
func unregister_event(event)->void:
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


func _unregister_event(event:GDScript)->void:
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


## 用于注册一个控制台命令并将其绑定到指定函数，命令被执行时将触发此函数，并传入对应的命令名与参数数组
## 命令被注册后将会在帮助菜单中自动显示，无法注册已经存在的命令
## 绑定函数接收的参数数组中包含了以空格分隔的命令参数的列表，如命令 plugins load xxx.gd ，传入的数组中将包含["load","xxx.gd"]
## 注册命令需要的参数从左到右分别为:
## 命令的名称 (即为在控制台触发此命令需要输入的内容，请勿包含空格，不可与已存在的命令重复):
## - Tips: 此处可传入单个命令名，或一个包含了任意数量命令名的数组以批量注册某个命令及其别称
## 命令触发的函数名(当命令被执行时将触发的函数，此函数需要定义两个参数，分别用于接收命令名与传入的参数数组)
## [可选,默认为false]命令是否强制要求传入参数(若为true则在执行命令时必须传入参数，否则判定为用法错误)
## [可选,默认为空数组]命令的用法介绍(将在使用help指令或命令用法错误时显示。数组中的每项需为字符串，代表着一个子命令的用法)
## [可选,默认为false]命令是否需要在连接到协议后端后才能使用(若为true则在未连接协议后端时无法在控制台调用此命令)
func register_console_command(command,function,need_arguments:bool=false,usages:Array=[],need_connect:bool=false)->void:
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


func _register_console_command(command:String,function:Callable,need_arguments:bool,usages:Array,need_connect:bool)->void:
	if plugin_console_command_dic.has(command):
		GuiManager.console_print_error("无法注册以下命令，因为此命令已在此插件被注册: " + command)
		return
	if (!function is Callable) or (!function.is_valid()):
		GuiManager.console_print_error("无法注册以下命令，因为指定的函数不存在: " + command)
		return
	if CommandManager.register_console_command(command,need_arguments,usages,plugin_info.name,need_connect)==OK:
		plugin_console_command_dic[command] = {"function":function,"need_arg":need_arguments,"need_connect":need_connect,"usages":usages}
		add_to_group("console_command_"+command)
		GuiManager.console_print_success("成功注册命令: %s!" % [command])


## 用于取消注册一个控制台命令，命令被取消注册后将无法在控制台被执行，且不会在帮助菜单中显示
## 需要传入对应的命令名来将其取消注册，无法取消注册不属于此插件的命令
func unregister_console_command(command)->void:
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


func _unregister_console_command(command:String)->void:
	if !plugin_console_command_dic.has(command):
		GuiManager.console_print_error("无法取消注册以下命令，因为此命令不属于此插件: " + command)
		return
	if CommandManager.unregister_console_command(command) == OK:
		plugin_console_command_dic.erase(command)
		remove_from_group("console_command_"+command)
		GuiManager.console_print_success("成功取消注册命令: %s!" % [command])
	

## 用于注册一个或多个关键词并将其绑定到某个函数，关键词匹配时将触发绑定的函数并传入相关数据
## 注册的关键词不会自动进行匹配，而是需要手动调用或者在注册事件时将需要检测关键词的消息事件手动绑定到"trigger_keyword"函数即可
## 注册需要的参数从左到右分别为:
## 关键词的内容:
## - 此处可传入单个关键词字符串，或一个包含了任意数量关键词字符串的数组以批量注册关键词
## - 若关键词包含{@}，则满足匹配条件的同时还需要At机器人才视为匹配成功
## - 若匹配模式为正则表达式模式，则关键词需要为一个正则表达式
##
## 关键词绑定的函数名:
## - 当对应关键词匹配成功后将调用此函数，并传入四个参数
## - 传入的四个参数分别为：关键词文本，解析后的关键词文本，关键词参数(通常为原消息去掉关键词后的文本)，触发关键词的事件实例引用
##
## 动态解析字典:
## - 此处可以传入一个字典的引用，字典中的键与值均需要为字符串类型
## - 若关键词中包含如"{xxx}"格式的文本，并且字典中拥有"xxx"这个键，那么实际用于匹配的关键词中的"{xxx}"文本将会被替换成字典中"xxx"键对应的值
## - 例如，若您希望在运行时更改某插件中机器人的唤醒词，则只需将"{name}"注册为关键词，并指定一个包含"name"键的字典作为动态解析字典
## - 后续您只需更改该字典中的"name"键对应的值，即可实时变更唤醒机器人的关键词
##
## 关键词的匹配模式
## - 在某个消息事件触发"trigger_keyword"函数后，将提取消息事件的文本并根据匹配模式进行匹配
## - 只有满足匹配模式对应的条件的关键词才会触发绑定的函数，匹配模式的具体行为请参见上方的MatchMode枚举
##
## 关键词匹配成功后阻断对应事件的传递 (可选,默认为true):
## - 若此项为true,则在成功匹配关键词后，被对应事件调用的"trigger_keyword"函数将返回true以尝试阻断事件的传递
## - 若此项为false,但是关键词所触发的函数返回了true,那么被对应事件调用的"trigger_keyword"函数也将返回true以尝试阻断事件的传递
## - 阻断的具体行为将由相关事件注册时设置的阻断模式决定
func register_keyword(keyword,function,var_dic:Dictionary={},match_mode:int=MatchMode.BEGIN,block:bool=true)->void:
	if function is String:
		function = Callable(self,function)
	if keyword is String and keyword.length() > 0:
		_register_keyword(keyword,function,var_dic,match_mode,block)
	elif keyword is Array and keyword.size() > 0:
		for _k in keyword:
			if _k is String and _k.length() > 0:
				_register_keyword(_k,function,var_dic,match_mode,block)
			else:
				GuiManager.console_print_error("无法注册关键词，因为传入的关键词格式不合法！")
	else:
		GuiManager.console_print_error("无法注册关键词，因为传入的关键词格式不合法！")
	
	
func _register_keyword(keyword:String,function:Callable,var_dic:Dictionary,match_mode:int,block:bool)->void:
	if plugin_keyword_dic.has(keyword):
		GuiManager.console_print_error("无法注册以下关键词，因为此关键词已在此插件被注册: " + keyword)
		return
	if (!function is Callable) or (!function.is_valid()):
		GuiManager.console_print_error("无法注册以下关键词，因为指定的函数不存在: " + keyword)
		return
	plugin_keyword_dic[keyword] = {"function":function,"var_dic":var_dic,"match_mode":match_mode,"block":block}
	_update_keyword_arr()
	GuiManager.console_print_success("成功注册关键词: \"%s\"，匹配模式为: %s" % [keyword,match_mode_dic[match_mode]])
	

## 用于取消注册一个关键词，关键词被取消注册后将不会被用于匹配
## 需要传入对应的关键词字符串来将其取消注册，无法取消注册不属于此插件的关键词
func unregister_keyword(keyword)->void:
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
	
	
func _unregister_keyword(keyword:String)->void:
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


func _update_keyword_arr()->void:
	var _arr:Array = plugin_keyword_dic.keys()
	_arr.sort_custom(_sort_keyword)
	plugin_keyword_arr = _arr


## 根据传入的消息事件来提取文本并从中匹配关键词
## 通常只需在注册消息事件时将其与事件直接绑定即可	
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
			var _matched:bool = false
			var _word:String = _kw.format(_var_dic)
			var _arg:String
			if _word.begins_with("{@}"):
				if _at:
					_word = _word.substr(3)
					if _word.length() == 0:
						_arg = _text
						_matched = true
				else:
					continue
			if !_matched:
				match _mode:
					int(MatchMode.BEGIN):
						if _text.begins_with(_word):
							_arg = _text.substr(_word.length())
							_matched = true
					int(MatchMode.BETWEEN):
						var _idx:int = _text.find(_word)
						if _idx != -1 and (!(_text.begins_with(_word) or _text.ends_with(_word)) or _text == _word):
							_arg = _text.left(_idx)+_text.substr(_idx+_word.length())
							_matched = true
					int(MatchMode.END):
						if _text.ends_with(_word):
							_arg = _text.left(_text.length()-_word.length())
							_matched = true
					int(MatchMode.INCLUDE):
						var _idx:int = _text.find(_word)
						if _idx != -1:
							_arg = _text.left(_idx)+_text.substr(_idx+_word.length())
							_matched = true
					int(MatchMode.EXCLUDE):
						var _idx:int = _text.find(_word)
						if _idx == -1:
							_arg = _text
							_matched = true
					int(MatchMode.EQUAL):
						if _text == _word:
							_arg = ""
							_matched = true
					int(MatchMode.REGEX):
						if _text.match(_word):
							_arg = _text
							_matched = true
					_:
						continue
			if _matched:
				var _result:bool = _trigger_keyword(_func,_kw,_word,_arg,event)
				if _block:
					return true
				else:
					return _result
	else:
		GuiManager.console_print_error("无法使用传入的事件来匹配关键词，请确保其是一个消息事件！")
	return false


func _trigger_keyword(_func:Callable,_kw:String,_word:String,_arg:String,event:MessageEvent)->bool:
	if _func.is_valid():
		GuiManager.console_print_success("成功触发关键词:\"%s\"(解析后:\"%s\")，参数为:\"%s\"！"%[_kw,_word,_arg])
		var _result = _func.call(_kw,_word,_arg,event) 
		return _result if (_result is bool) else false
	else:
		GuiManager.console_print_error("关键词\"%s\"试图触发的函数无效或不存在，请检查配置是否有误！"%[_kw])
		return false


## 用于初始化插件的配置文件，并将其加载到内存中，以便在后续对其内容进行操作
## 对于数据的储存，建议使用插件数据库功能，可以提供更快的读写速度及更好的类型安全性，且可储存几乎任何类型的数据
## 执行此函数时，将会检测是否已存在此插件对应的配置文件，否则将会基于给定的默认配置字典来新建一个配置文件
## 需要的参数从左到右分别为:
## 默认配置的字典(即为新建配置文件时其中将包含的内容，RainyBot将以Json格式将其保存为配置文件)
## [可选,默认为空字典]每个配置项的介绍(字典的key为配置项的名称,对应的值为此配置项的相关介绍,两者均为字符串)
func init_plugin_config(default_config:Dictionary,config_description:Dictionary={})->int:
	if plugin_config_loaded:
		GuiManager.console_print_error("插件配置已被加载，因此无法对其进行初始化!")
		return ERR_ALREADY_IN_USE
	GuiManager.console_print_warning("正在加载插件配置文件.....")
	if default_config.is_empty():
		GuiManager.console_print_error("默认配置字典不能为空，插件配置初始化失败！")
		return ERR_INVALID_DATA
	default_plugin_config = default_config
	plugin_config = default_config.duplicate(true)
	var config_path:String = PluginManager.plugin_config_path + plugin_info["id"] + ".json"
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
					GuiManager.console_print_warning("若有需要，您可以访问以下路径进行配置: "+config_path)
				else:
					GuiManager.console_print_error("配置文件更新失败，请检查文件权限是否配置正确! 路径:"+config_path)
					GuiManager.console_print_warning("若需重试，请重新加载此插件!")
					return FileAccess.get_open_error()
			for key in _config:
				if (_config[key] is String && _config[key] == "") or (_config[key] == null):
					GuiManager.console_print_warning("警告:检测到内容为空的配置项，可能会导致出现问题: "+str(key))
					GuiManager.console_print_warning("可以前往以下路径来验证与修改配置: "+config_path)
			plugin_config = _config
			plugin_config_loaded = true
			GuiManager.console_print_success("插件配置加载成功")
			return OK
		else:
			GuiManager.console_print_error("配置文件读取失败，请删除配置文件后重新生成! 路径:"+config_path)
			return ERR_FILE_CANT_READ
	else:
		GuiManager.console_print_warning("没有已存在的配置文件，正在生成新的配置文件...")
		var file:FileAccess = FileAccess.open(config_path,FileAccess.WRITE)
		if !file:
			GuiManager.console_print_error("配置文件创建失败，请检查文件权限是否配置正确! 路径:"+config_path)
			return FileAccess.get_open_error()
		else:
			var json:JSON = JSON.new()
			file.store_string(json.stringify(plugin_config,"\t"))
			GuiManager.console_print_success("配置文件创建成功，可以访问以下路径进行配置: "+config_path)
			if !config_description.is_empty():
				GuiManager.console_print_text("配置选项说明:")
				for key in config_description:
					GuiManager.console_print_text(str(key)+":"+str(config_description[key]))
			GuiManager.console_print_warning("配置完成后请重新加载此插件!")
			plugin_config_loaded = true
			return OK


## 用于将内存中的配置保存到配置文件中，需要先初始化配置文件才能使用此函数
func save_plugin_config()->int:
	if !plugin_config_loaded:
		GuiManager.console_print_error("配置文件保存失败，请先初始化配置后再执行此操作")
		return ERR_FILE_CANT_WRITE
	GuiManager.console_print_warning("正在保存配置文件...")
	var config_path:String = PluginManager.plugin_config_path + plugin_info["id"] + ".json"
	var file:FileAccess = FileAccess.open(config_path,FileAccess.WRITE)
	if !file:
		GuiManager.console_print_error("配置文件保存失败，请检查文件权限是否配置正确! 路径:"+config_path)
		return FileAccess.get_open_error()
	else:
		var json:JSON = JSON.new()
		file.store_string(json.stringify(plugin_config,"\t"))
		GuiManager.console_print_success("配置文件保存成功，路径: "+config_path)
		return OK


## 用于从已加载的配置中获取指定key对应的内容，需要先初始化配置文件才能使用此函数
func get_plugin_config(key)->Variant:
	if !plugin_config_loaded:
		GuiManager.console_print_error("配置内容获取失败，请先初始化配置后再执行此操作")
		return null
	if plugin_config.has(key):
		return plugin_config[key]
	else:
		GuiManager.console_print_error("配置内容获取失败，试图获取的key在插件配置中不存在!")
		return null
		

## 用于从已加载的配置中检查指定key是否存在，需要先初始化配置文件才能使用此函数	
func has_plugin_config(key)->bool:
	if !plugin_config_loaded:
		GuiManager.console_print_error("配置内容获取失败，请先初始化配置后再执行此操作")
		return false
	return plugin_config.has(key)
		

## 用于在已加载的配置中设定指定key的对应内容，需要先初始化配置文件才能使用此函数
## 最后一项可选的参数用于指定是否在设定的同时将更改立刻保存到配置文件中	
func set_plugin_config(key,value,save_file:bool=true)->int:
	if !plugin_config_loaded:
		GuiManager.console_print_error("配置内容设定失败，请先初始化配置后再执行此操作")
		return ERR_FILE_CANT_WRITE
	if plugin_config.has(key):
		plugin_config[key]=value
		if save_file:
			save_plugin_config()
		return OK
	else:
		GuiManager.console_print_error("配置内容设定失败，试图设置的key在插件配置中不存在!")
		return ERR_FILE_CANT_WRITE


## 用于在已加载的配置中将指定key还原回默认值，需要先初始化配置文件才能使用此函数
## 最后一项可选的参数用于指定是否在还原的同时将更改立刻保存到配置文件中	
func reset_plugin_config(key,save_file:bool=true)->int:
	if !plugin_config_loaded:
		GuiManager.console_print_error("配置内容还原失败，请先初始化配置后再执行此操作")
		return ERR_FILE_CANT_WRITE
	if plugin_config.has(key):
		if default_plugin_config.has(key):
			plugin_config[key]=default_plugin_config[key]
			if save_file:
				save_plugin_config()
			return OK
		else:
			GuiManager.console_print_error("配置内容还原失败，试图设置的key在插件默认配置中不存在!")
			return ERR_DOES_NOT_EXIST
	else:
		GuiManager.console_print_error("配置内容还原失败，试图设置的key在插件配置中不存在!")
		return ERR_DOES_NOT_EXIST


## 用于在已加载的配置中将所有内容还原回默认值，需要先初始化配置文件才能使用此函数
## 最后一项可选参数用于指定是否在还原的同时将更改立即保存到配置文件中
func reset_all_plugin_config(save_file:bool=true)->int:
	if !plugin_config_loaded:
		GuiManager.console_print_error("配置文件还原失败，请先初始化配置文件后再执行此操作!")
		return ERR_CANT_OPEN
	plugin_config = default_plugin_config.duplicate(true)
	if save_file:
		save_plugin_config()
	return OK


## 用于直接获取已加载的配置的字典，便于以字典的形式对其进行操作，需要先初始化配置文件才能使用此函数
func get_plugin_config_metadata()->Dictionary:
	if !plugin_config_loaded:
		GuiManager.console_print_error("配置内容获取失败，请先初始化配置后再执行此操作")
		return {}
	return plugin_config


## 用于直接替换已加载的配置的字典为指定的字典，便于以字典的形式对其进行操作，需要先初始化配置文件才能使用此函数
## 最后一项参数用于指定是否在设定的同时将更改立刻保存到配置文件中	
func set_plugin_config_metadata(dic:Dictionary,save_file:bool=true)->int:
	if !plugin_config_loaded:
		GuiManager.console_print_error("配置内容设定失败，请先初始化配置后再执行此操作")
		return ERR_FILE_CANT_WRITE
	plugin_config = dic
	if save_file:
		save_plugin_config()
	return OK
	

## 用于直接获取已加载的数据库的字典，便于以字典的形式对其进行操作，需要先初始化数据库文件才能使用此函数
func get_plugin_data_metadata()->Dictionary:
	if !plugin_data_loaded:
		GuiManager.console_print_error("数据库内容获取失败，请先初始化数据库后再执行此操作")
		return {}
	return plugin_data


## 用于直接替换已加载的数据库的字典为指定的字典，便于以字典的形式对其进行操作，需要先初始化数据库文件才能使用此函数
## 最后一项可选参数用于指定是否在设定的同时立即将更改保存到数据库文件中
func set_plugin_data_metadata(dic:Dictionary,save_file:bool=true)->int:
	if !plugin_data_loaded:
		GuiManager.console_print_error("数据库内容设定失败，请先初始化数据库后再执行此操作")
		return ERR_DATABASE_CANT_WRITE
	plugin_data = dic
	if save_file:
		save_plugin_data()
	return OK


## 用于直接获取已加载的缓存数据库的字典，便于以字典的形式对其进行操作，需要先初始化缓存数据库文件才能使用此函数
func get_plugin_cache_metadata()->Dictionary:
	if !plugin_cache_loaded:
		GuiManager.console_print_error("缓存数据库内容获取失败，请先初始化缓存数据库后再执行此操作")
		return {}
	return plugin_cache


## 用于直接替换已加载的缓存数据库的字典为指定的字典，便于以字典的形式对其进行操作，需要先初始化缓存数据库文件才能使用此函数
## 最后一项可选参数用于指定是否在设定的同时立即将更改保存到缓存数据库文件中
func set_plugin_cache_metadata(dic:Dictionary,save_file:bool=true)->int:
	if !plugin_cache_loaded:
		GuiManager.console_print_error("缓存数据库内容设定失败，请先初始化缓存数据库后再执行此操作")
		return ERR_DATABASE_CANT_WRITE
	plugin_cache = dic
	if save_file:
		save_plugin_cache()
	return OK


## 用于初始化插件的数据库文件，并将其加载到内存中，以便在后续对其内容进行操作
## 对于配置的储存，建议使用插件配置功能，以便指定默认配置与配置说明，且能使用常规编辑器对其进行编辑与更改
## 执行此函数时，将会检测是否已存在此插件对应的数据库文件，否则将会新建一个空白的数据库文件(.rdb格式)
func init_plugin_data()->int:
	if plugin_data_loaded:
		GuiManager.console_print_error("插件数据库已被加载，因此无法对其进行初始化!")
		return ERR_ALREADY_IN_USE
	GuiManager.console_print_warning("正在加载插件数据库.....")
	var data_path:String = PluginManager.plugin_data_path + plugin_info["id"] + ".rdb"
	if FileAccess.file_exists(data_path):
		var file:FileAccess = FileAccess.open(data_path,FileAccess.READ)
		var _data = file.get_var(true) if file else null
		if _data is Dictionary:
			plugin_data = _data
			plugin_data_loaded = true
			GuiManager.console_print_success("插件数据库加载成功")
			return OK
		else:
			GuiManager.console_print_error("插件数据库读取失败，请删除后重新生成! 路径:"+data_path)
			return ERR_DATABASE_CANT_READ
	else:
		GuiManager.console_print_warning("没有已存在的数据库文件，正在生成新的数据库文件...")
		var file:FileAccess = FileAccess.open(data_path,FileAccess.WRITE)
		if !file:
			GuiManager.console_print_error("数据库文件创建失败，请检查文件权限是否配置正确! 路径:"+data_path)
			return FileAccess.get_open_error()
		else:
			file.store_var(plugin_data,true)
			plugin_data_loaded = true
			GuiManager.console_print_success("数据库文件创建成功，路径: "+data_path)
			GuiManager.console_print_warning("若发生任何数据库文件更改，请重载此插件")
			return OK
			

## 用于将内存中的数据保存到数据库文件中，需要先初始化数据库文件才能使用此函数		
func save_plugin_data()->int:
	if !plugin_data_loaded:
		GuiManager.console_print_error("数据库文件保存失败，请先初始化数据库后再执行此操作")
		return ERR_DATABASE_CANT_WRITE
	GuiManager.console_print_warning("正在保存插件数据库.....")
	var data_path:String = PluginManager.plugin_data_path + plugin_info["id"] + ".rdb"
	var file:FileAccess = FileAccess.open(data_path,FileAccess.WRITE)
	if !file:
		GuiManager.console_print_error("数据库文件保存失败，请检查文件权限是否配置正确! 路径:"+data_path)
		return FileAccess.get_open_error()
	else:
		file.store_var(plugin_data,true)
		GuiManager.console_print_success("数据库文件保存成功，路径: "+data_path)
		return OK
		

## 用于从已加载的数据库中获取指定key对应的内容，需要先初始化数据库文件才能使用此函数	
func get_plugin_data(key)->Variant:
	if !plugin_data_loaded:
		GuiManager.console_print_error("数据库内容获取失败，请先初始化数据库后再执行此操作!")
		return null
	if plugin_data.has(key):
		return plugin_data[key]
	else:
		GuiManager.console_print_error("数据库内容获取失败，试图获取的key在插件数据库中不存在!")
		return null
		

## 用于从已加载的数据库中检查指定key是否存在，需要先初始化数据库文件才能使用此函数			
func has_plugin_data(key)->bool:
	if !plugin_data_loaded:
		GuiManager.console_print_error("数据库内容获取失败，请先初始化数据库后再执行此操作!")
		return false
	return plugin_data.has(key)
		

## 用于在已加载的数据库中设定指定key的对应内容，需要先初始化数据库文件才能使用此函数
## 最后一项可选参数用于指定是否在设定的同时将更改立即保存到数据库文件中
func set_plugin_data(key,value,save_file:bool=true)->int:
	if !plugin_data_loaded:
		GuiManager.console_print_error("数据库内容设定失败，请先初始化数据库后再执行此操作!")
		return ERR_DATABASE_CANT_WRITE
	plugin_data[key]=value
	if save_file:
		save_plugin_data()
	return OK


## 用于在已加载的数据库中删除指定key及其对应内容，需要先初始化数据库文件才能使用此函数
## 最后一项可选参数用于指定是否在删除的同时将更改立即保存到数据库文件中
func remove_plugin_data(key,save_file:bool=true)->int:
	if !plugin_data_loaded:
		GuiManager.console_print_error("数据库内容删除失败，请先初始化数据库后再执行此操作!")
		return ERR_DATABASE_CANT_WRITE
	if plugin_data.has(key):
		plugin_data.erase(key)
		if save_file:
			save_plugin_data()
		return OK
	else:
		GuiManager.console_print_error("数据库内容删除失败，试图删除的key在插件数据库中不存在!")
		return ERR_DATABASE_CANT_WRITE
		

## 用于在已加载的数据库中清空所有内容，需要先初始化数据库文件才能使用此函数
## 最后一项可选参数用于指定是否在清空的同时将更改立即保存到数据库文件中
func clear_plugin_data(save_file:bool=true)->int:
	if !plugin_data_loaded:
		GuiManager.console_print_error("数据库内容清空失败，请先初始化数据库后再执行此操作!")
		return ERR_DATABASE_CANT_WRITE
	plugin_data.clear()
	if save_file:
		save_plugin_data()
	return OK


func init_plugin_cache()->int:
	if plugin_cache_loaded:
		GuiManager.console_print_error("插件缓存数据库已被加载，因此无法对其进行初始化!")
		return ERR_ALREADY_IN_USE
	GuiManager.console_print_warning("正在加载插件缓存数据库.....")
	var data_path:String = PluginManager.plugin_cache_path + plugin_info["id"] + ".rca"
	if FileAccess.file_exists(data_path):
		var file:FileAccess = FileAccess.open(data_path,FileAccess.READ)
		var _data = file.get_var(true) if file else null
		if _data is Dictionary:
			plugin_cache = _data
			plugin_cache_loaded = true
			GuiManager.console_print_success("插件缓存数据库加载成功")
			return OK
		else:
			GuiManager.console_print_error("插件缓存数据库读取失败，请删除后重新生成! 路径:"+data_path)
			return ERR_DATABASE_CANT_READ
	else:
		GuiManager.console_print_warning("没有已存在的缓存数据库文件，正在生成新的缓存数据库文件...")
		var file:FileAccess = FileAccess.open(data_path,FileAccess.WRITE)
		if !file:
			GuiManager.console_print_error("缓存数据库文件创建失败，请检查文件权限是否配置正确! 路径:"+data_path)
			return FileAccess.get_open_error()
		else:
			file.store_var(plugin_cache,true)
			plugin_cache_loaded = true
			GuiManager.console_print_success("缓存数据库文件创建成功，路径: "+data_path)
			GuiManager.console_print_warning("若发生任何缓存数据库文件更改，请重载此插件")
			return OK
			

## 用于将内存中的缓存数据保存到数据库文件中，需要先初始化缓存数据库文件才能使用此函数		
func save_plugin_cache()->int:
	if !plugin_cache_loaded:
		GuiManager.console_print_error("缓存数据库文件保存失败，请先初始化缓存数据库后再执行此操作")
		return ERR_DATABASE_CANT_WRITE
	GuiManager.console_print_warning("正在保存插件缓存数据库.....")
	var data_path:String = PluginManager.plugin_cache_path + plugin_info["id"] + ".rca"
	var file:FileAccess = FileAccess.open(data_path,FileAccess.WRITE)
	if !file:
		GuiManager.console_print_error("缓存数据库文件保存失败，请检查文件权限是否配置正确! 路径:"+data_path)
		return FileAccess.get_open_error()
	else:
		file.store_var(plugin_cache,true)
		GuiManager.console_print_success("缓存数据库文件保存成功，路径: "+data_path)
		return OK
		

## 用于从已加载的缓存数据库中获取指定key对应的内容，需要先初始化缓存数据库文件才能使用此函数	
func get_plugin_cache(key)->Variant:
	if !plugin_cache_loaded:
		GuiManager.console_print_error("缓存数据库内容获取失败，请先初始化缓存数据库后再执行此操作!")
		return null
	if plugin_cache.has(key):
		return plugin_cache[key]
	else:
		GuiManager.console_print_error("缓存数据库内容获取失败，试图获取的key在插件缓存数据库中不存在!")
		return null
		

## 用于从已加载的缓存数据库中检查指定key是否存在，需要先初始化缓存数据库文件才能使用此函数			
func has_plugin_cache(key)->bool:
	if !plugin_cache_loaded:
		GuiManager.console_print_error("缓存数据库内容获取失败，请先初始化数据库后再执行此操作!")
		return false
	return plugin_cache.has(key)
		

## 用于在已加载的缓存数据库中设定指定key的对应内容，需要先初始化缓存数据库文件才能使用此函数
## 最后一项可选参数用于指定是否在设定的同时将更改立即保存到缓存数据库文件中
func set_plugin_cache(key,value,save_file:bool=true)->int:
	if !plugin_cache_loaded:
		GuiManager.console_print_error("缓存数据库内容设定失败，请先初始化缓存数据库后再执行此操作!")
		return ERR_DATABASE_CANT_WRITE
	plugin_cache[key]=value
	if save_file:
		save_plugin_cache()
	return OK


## 用于在已加载的缓存数据库中删除指定key及其对应内容，需要先初始化缓存数据库文件才能使用此函数
## 最后一项可选参数用于指定是否在删除的同时将更改立即保存到缓存数据库文件中
func remove_plugin_cache(key,save_file:bool=true)->int:
	if !plugin_cache_loaded:
		GuiManager.console_print_error("缓存数据库内容删除失败，请先初始化缓存数据库后再执行此操作!")
		return ERR_DATABASE_CANT_WRITE
	if plugin_cache.has(key):
		plugin_cache.erase(key)
		if save_file:
			save_plugin_cache()
		return OK
	else:
		GuiManager.console_print_error("缓存数据库内容删除失败，试图删除的key在插件缓存数据库中不存在!")
		return ERR_DATABASE_CANT_WRITE
		

## 用于在已加载的缓存数据库中清空所有内容，需要先初始化缓存数据库文件才能使用此函数
## 最后一项可选参数用于指定是否在清空的同时将更改立即保存到缓存数据库文件中
func clear_plugin_cache(save_file:bool=true)->int:
	if !plugin_cache_loaded:
		GuiManager.console_print_error("缓存数据库内容清空失败，请先初始化缓存数据库后再执行此操作!")
		return ERR_DATABASE_CANT_WRITE
	plugin_cache.clear()
	if save_file:
		save_plugin_cache()
	return OK


## 调用此函数后，插件将会尝试卸载自身
## 若此插件被其他插件依赖，则可能会卸载失败
func unload_plugin()->void:
	PluginManager.unload_plugin(self)


func load_scene(path:String,for_capture:bool=false)->Node:
	GuiManager.console_print_warning("正在尝试加载场景文件: %s"% path)
	var _scene:PackedScene = await GlobalManager.load_threaded(path)
	if is_instance_valid(_scene) and _scene.can_instantiate():
		var _ins:Node = _scene.instantiate()
		if for_capture:
			var _v_port:SubViewport = SubViewport.new()
			_v_port.render_target_update_mode = SubViewport.UPDATE_DISABLED
			add_child(_v_port)
			_v_port.add_child(_ins)
			_ins.connect("tree_exited",_v_port.queue_free)
			GuiManager.console_print_success("成功加载场景文件，并准备好对其内容进行图像获取: %s"% path)
		else:
			add_child(_ins)
			GuiManager.console_print_success("成功加载场景文件，并将其添加为插件的子级以便于后续使用: %s"% path)
		return _ins
	else:
		GuiManager.console_print_error("无法加载场景文件 %s，请检查路径及文件是否正确，或尝试在插件菜单中重新导入资源!"% path)
		return null


func get_scene_image(scene:Node,size:Vector2i,stretch_size:Vector2i=Vector2i.ZERO,transparent:bool=false)->Image:
	if !is_instance_valid(scene):
		GuiManager.console_print_error("指定的场景无效，因此无法根据其中的内容生成图像!")
		return null
	await get_tree().process_frame
	var _v_port:SubViewport = scene.get_parent()
	if !is_instance_valid(_v_port) or !(_v_port is SubViewport):
		GuiManager.console_print_error("无法基于指定的场景生成图像，请确保此场景是通过load_scene()函数加载的，且加载时在函数中启用了for_capture参数!")
		return null
	if (size.x < 0 or size.y < 0) or (stretch_size.x < 0 or stretch_size.y < 0):
		GuiManager.console_print_error("无法基于指定的场景生成图像，因为传入的大小或拉伸大小不能小于(0,0)!")
		return null
	_v_port.transparent_bg = transparent
	_v_port.size = Vector2i.ZERO
	_v_port.size = size
	_v_port.render_target_update_mode = SubViewport.UPDATE_ONCE
	await get_tree().process_frame
	var img:Image = _v_port.get_texture().get_image()
	if is_instance_valid(img):
		if stretch_size != Vector2i.ZERO:
			img.resize(stretch_size.x,stretch_size.y,Image.INTERPOLATE_LANCZOS)
			GuiManager.console_print_success("成功基于指定场景中的内容生成图像! 大小为:%s, 拉伸大小为:%s, 背景透明状态为:%s"% [_v_port.size,stretch_size,"启用" if _v_port.transparent_bg else "禁用"])
		else:
			GuiManager.console_print_success("成功基于指定场景中的内容生成图像! 大小为:%s, 背景透明状态为:%s"% [_v_port.size,"启用" if _v_port.transparent_bg else "禁用"])
		return img
	else:
		if stretch_size != Vector2i.ZERO:
			GuiManager.console_print_error("无法根据指定场景中的内容生成图像，请检查传入的各项参数是否正确! (大小为:%s, 拉伸大小为:%s, 背景透明状态为:%s)"% [_v_port.size,stretch_size,"启用" if _v_port.transparent_bg else "禁用"])
		else:
			GuiManager.console_print_error("无法根据指定场景中的内容生成图像，请检查传入的各项参数是否正确! (大小为:%s, 背景透明状态为:%s)"% [_v_port.size,"启用" if _v_port.transparent_bg else "禁用"])
		return null
	

## 通过await调用后，将等待一个满足指定发送者id，指定群组id的指定类型的消息事件
## 消息事件不会自动进行上下文匹配，而是需要手动调用或者在注册消息事件时将需要匹配上下文的消息事件手动绑定到"respond_context"函数即可
## 接收到满足条件的事件后，该函数将返回该事件的引用，否则在达到指定的超时秒数后，将返回null
## 需要的参数从左到右分别为：
## 要等待的消息事件的类型
## 要匹配的发送者ID(可选，若为-1则不匹配此项)
## 要匹配的群组ID(可选，若为-1则不匹配此项)
## 等待的超时时间(可选，默认为20秒; 若数值小于等于0, 或已存在相同的等待, 则不启用超时)
## 消息事件匹配成功后阻断对应事件的传递 (可选,默认为true)
func wait_context_custom(event_type:GDScript,sender_id:int=-1,group_id:int=-1,timeout:float=20.0,block:bool=true)->MessageEvent:
	if event_type.get_base_script() != MessageEvent:
		GuiManager.console_print_error("无法开始等待上下文响应，需要等待的事件类型应该是一个消息事件!")
		return null
	if group_id == -1 and sender_id == -1:
		GuiManager.console_print_error("无法开始等待上下文响应，需要至少指定一个发送者ID或群组ID!")
		return null
	if !((event_type == GroupMessageEvent) or (event_type == TempMessageEvent)) and sender_id == -1:
		GuiManager.console_print_error("无法开始等待上下文响应，此消息事件类型必须指定一个发送者ID!")
		return null
	var _dic:Dictionary = {}
	_dic["event"] = event_type.resource_path.get_file().replacen(".gd","")
	if sender_id != -1:
		_dic["sender_id"] = sender_id
	if ((event_type == GroupMessageEvent) or (event_type == TempMessageEvent)) and group_id != -1:
		_dic["group_id"] = group_id
	var context_id:String = str(_dic)
	return await wait_context_id(context_id,timeout,block)


## 通过await调用后，将等待另外一个与指定消息事件相匹配的消息事件
## 消息事件不会自动进行上下文匹配，而是需要手动调用或者在注册消息事件时将需要进行匹配的消息事件手动绑定到"respond_context"函数即可
## 接收到满足条件的事件后，该函数将返回该事件的引用，否则在达到指定的超时秒数后，将返回null
## 需要的参数从左到右分别为：
## 要匹配的消息事件的实例引用
## 是否要匹配消息事件中的发送者ID(可选，默认为true)
## 是否要匹配消息事件中的群组ID(可选，默认为true)
## 等待的超时时间(可选，默认为20秒; 若数值小于等于0, 或已存在相同的等待, 则不启用超时)
## 消息事件匹配成功后阻断对应事件的传递 (可选,默认为true)
func wait_context(event:MessageEvent,match_sender:bool=true,match_group:bool=true,timeout:float=20.0,block:bool=true)->MessageEvent:
	if !is_instance_valid(event):
		GuiManager.console_print_error("无法开始等待上下文响应，需要等待的事件应该是一个有效的消息事件!")
		return null
	if !match_sender and !match_group:
		GuiManager.console_print_error("无法开始等待上下文响应，需要至少指定一个将要匹配的条目!")
		return null
	if !((event is GroupMessageEvent) or (event is TempMessageEvent)) and !match_sender:
		GuiManager.console_print_error("无法开始等待上下文响应，此类消息事件必须对发送者ID进行匹配!")
		return null
	var _dic:Dictionary = {}
	_dic["event"] = event.get_script().resource_path.get_file().replacen(".gd","")
	if match_sender:
		_dic["sender_id"] = event.get_sender_id()
	if ((event is GroupMessageEvent) or (event is TempMessageEvent)) and match_group:
		_dic["group_id"] = event.get_group_id()
	var context_id:String = str(_dic)
	return await wait_context_id(context_id,timeout,block)
	

## 通过await调用后，将等待指定id的响应，并在收到响应后返回响应的内容
## 要进行响应，需要在某处手动调用"respond_context"函数并传入相同的ID
## 若未进行响应且在达到指定的超时秒数后，将返回null
## 需要的参数从左到右分别为：
## 要等待响应的自定义ID
## 等待的超时时间(可选，默认为20秒; 若数值小于等于0, 或已存在相同的等待, 则不启用超时)
func wait_context_id(context_id:String,timeout:float=20.0,block:bool=true)->Variant:
	if context_id.length() < 1:
		GuiManager.console_print_error("无法开始等待上下文响应，需要等待的上下文ID不能为空!")
		return null
	GuiManager.console_print_warning("开始等待上下文响应，ID为: %s，超时时间为: %s秒！"%[context_id,str(timeout)])
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
	GuiManager.console_print_warning("上下文已完成，ID为: %s，响应结果为: %s！"%[context_id,str(_cont.get_result())])
	plugin_context_dic.erase(context_id)
	return _cont.get_result()


## 用于响应正在进行中的上下文等待
## 若第一个参数传入内容为一个消息事件，则将用于响应与消息事件相关的上下文等待，并且第二个参数将被忽略
## 通常只需在注册消息事件时将其与事件直接绑定后即可自动进行此类上下文响应
##
## 若第一个参数传入内容为一个字符串，则将用于响应指定ID的上下文等待，此时可通过第二个参数指定响应的内容
## 第二个参数为可选参数，可以是任何类型的值；若不填则默认响应内容为布尔值true
func respond_context(context,response=true)->bool:
	var context_id:String = ""
	if context is String and context.length() > 0:
		context_id = context
	elif context is MessageEvent and is_instance_valid(context):
		var _event:String = context.get_script().resource_path.get_file().replacen(".gd","")
		var _sender:int = context.get_sender_id()
		var _dic_sender:Dictionary = {}
		var _dic_group:Dictionary = {}
		var _dic_all:Dictionary = {}
		_dic_sender["event"] = _event
		_dic_group["event"] = _event
		_dic_all["event"] = _event
		_dic_all["sender_id"] = _sender
		_dic_sender["sender_id"] = _sender
		if (context is GroupMessageEvent) or (context is TempMessageEvent):
			var _group:int = context.get_group_id()
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
		GuiManager.console_print_error("无法响应上下文，需要响应的内容应该是一个上下文ID或一个消息事件")
	if plugin_context_dic.has(context_id) && is_instance_valid(plugin_context_dic[context_id]):
		var _cont:PluginContextHelper = plugin_context_dic[context_id]
		_cont.result = response
		_cont.emit_signal("finished")
		GuiManager.console_print_success("成功响应上下文，ID为: %s，响应结果为: %s！"%[context_id,str(response)])
		return _cont.block
	elif context is String:
		GuiManager.console_print_warning("未找到指定的上下文ID，无法进行响应: " + context_id)
	return false
		

func _tick_context_timeout(cont_ins:PluginContextHelper,_timeout:float)->void:
	await get_tree().create_timer(_timeout).timeout
	if is_instance_valid(cont_ins) && cont_ins.result == null:
		GuiManager.console_print_warning("等待上下文响应超时，无法获取到返回结果: "+str(cont_ins.id))
		cont_ins.emit_signal("finished")


class PluginContextHelper:
	extends RefCounted
	signal finished
	var id:String = ""
	var block:bool = false
	var result = null
	
	func get_result()->Variant:
		return result
