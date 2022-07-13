#RainyBot插件模板
#相关帮助文档，示例插件及API请访问 https://docs.rainybot.dev 进行查阅
extends Plugin #默认继承插件类，请勿随意改动


#可以在此处定义各种插件范围的全局变量/常量/枚举等，例如：
#var data:Dictionary = {}
#var lib:Plugin = null
#var connected:bool = true


#将在此插件的文件被读取时执行的操作
#必须在此处使用set_plugin_info函数来设置插件信息，插件才能被正常加载
#例如：set_plugin_info("example","示例插件","author","1.0","这是插件的介绍")
#可以在此处初始化和使用一些基本变量，但不建议执行其它代码，可能会导致出现未知问题
func _on_init()->void:
	#set_plugin_info("","","","","")
	pass
	

#将在RainyBot与协议后端恢复连接时执行的操作
#可以在此处进行一些与连接状态相关的操作，例如恢复连接后发送通知等
func _on_connect()->void:
	#connected = true
	pass


#将在此插件被完全加载后执行的操作
#可以在此处进行各类事件/关键词/命令的注册，以及配置/数据文件的初始化等
func _on_load()->void:
	#register_event(Event,"")
	#register_keyword("","")
	#register_console_command("","")
	#init_plugin_config({})
	#init_plugin_data()
	pass


#将在所有插件被完全加载后执行的操作
#可以在此处进行一些与其他插件交互相关的操作，例如获取某插件的实例等
#注意：如果此插件硬性依赖某插件，推荐在插件信息中注册所依赖的插件，以确保其在此插件之前被正确加载
func _on_ready()->void:
	#lib = get_plugin_instance("")
	pass


#将在此插件运行的每一秒执行的操作
#可在此处进行一些计时，或时间判定相关的操作，例如整点报时等
func _on_process()->void:
	#var _runtime:int = get_plugin_runtime()
	pass


#将在RainyBot与协议后端断开连接时执行的操作
#可以在此处进行一些与连接状态相关的操作，例如断开连接后暂停某些任务的运行等
func _on_disconnect()->void:
	#connected = false
	pass


#将在此插件即将被卸载时执行的操作
#可在此处执行一些自定义保存或清理相关的操作，例如储存自定义的文件或清除缓存等
#无需在此处取消注册事件/关键词/命令，或者对内置的配置/数据功能进行保存，插件卸载时将会自动进行处理
func _on_unload()->void:
	#lib.save_file("")
	pass
