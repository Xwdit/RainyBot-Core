#插件类Api，请勿改动下方内容

extends Node #基于内部Node类构建
	
class_name Plugin #定义类名称

#将在此插件初始化时自动调用此函数
func _on_init():
	pass

#将在此插件被完全加载后自动调用此函数
func _on_load():
	pass

#将在此插件即将被卸载时自动调用此函数
func _on_unload():
	pass

#接收Mirai框架推送的事件，并进行处理。将EventName替换为要接受的事件名即可
#data为事件携带的对应数据
#各类事件介绍请参见: https://github.com/project-mirai/mirai-api-http/blob/master/docs/adapter/WebsocketAdapter.md
func _event_EventName(data:Dictionary):
	pass
	
#接收用户的指令输入，并进行处理。将CommandName替换为要接受的指令即可
#args为指令后方携带的参数，若无参数则为空数组
func _command_CommandName(args:Array):
	pass

#设定插件相关信息
#需传入一个Dictionary字典,并且遵照以下格式填写每项:
#{
#	"id":"xxx", #插件唯一ID,不能同时加载两个具有相同ID的插件
#	"name":"xxx", #插件的显示名称
#	"author":"xxx", #插件的作者
#	"version":"1.0", #插件的版本号
#	"description":"xxxxx" #插件的描述
#}
func set_plugin_info(info_dic:Dictionary):
	pass

#用于获取储存了本插件信息的Dictionary字典
func get_plugin_info():
	pass

#获取本插件的文件名
func get_plugin_file():
	pass

#获取本插件的绝对路径
func get_plugin_path():
	pass

#向Mirai发送操作指令，并储存该函数返回的指令实例用于稍后接收指令回调
#若指令发送失败则此函数将返回null，请注意使用函数 is_instance_valid(指令实例) 来进行判断
#参数从左到右分别为指令名称，副指令名称(可选)，指令调用参数字典(可选)
#各类指令介绍请参见: https://github.com/project-mirai/mirai-api-http/blob/master/docs/adapter/WebsocketAdapter.md
func send_mirai_command(command,sub_command=null,content={}):
	pass

#向指定Url发送Http Get请求，并返回请求实例用于后续获取回调结果
#若指令发送失败则此函数将返回null，请注意使用函数 is_instance_valid(请求实例) 来进行判断
func send_http_get_request(url:String,timeout:float = 20):
	pass

#设置是否接收聊天消息事件,需传入true(是)/false(否)
func receive_message_events(enabled:bool):
	pass

#设置是否接收Mirai框架事件(例如加群退群等),需传入true(是)/false(否)
func receive_bot_events(enabled:bool):
	pass

#设置是否接收用户的指令输入,需传入true(是)/false(否)
func receive_commands(enabled:bool):
	pass

#在指令数据库中注册一个指令，用户可调用该指令执行操作
#参数从左到右分别为指令名称(需唯一)，指令是否必需参数，指令用法介绍(数组的每个元素显示为一行)，指令来源(如插件名)
func register_command(command:String,need_arguments:bool,usages:Array,source:String):
	pass

#在指令数据库中取消注册一个指令
func unregister_command(command:String):
	pass

#检查当前与Mirai框架的链接是否正常
func is_connected_to_mirai():
	pass

#获取指定id的插件的实例，可用于插件间交互，若获取失败则返回null
func get_other_plugin_instance(plugin_id):
	pass

#初始化插件的配置文件，若已存在则加载，未存在则创建
#对应参数分别为 新建配置文件的初始内容，配置文件中每一配置项的描述
func init_plugin_config(default_config:Dictionary,config_description:Dictionary={}):
	pass

#保存内存中的配置信息到插件配置文件中
func save_plugin_config():
	pass

#从已加载的插件配置中获取对应键的值
func get_plugin_config(key):
	pass

#设置插件配置中对应键的值，save_file表示是否在设置时立刻保存到文件
func set_plugin_config(key,value,save_file:bool=true):
	pass

#初始化插件的数据库文件，若已存在则加载，未存在则创建，新建的数据库默认为空
func init_plugin_data():
	pass

#保存内存中的数据信息到插件数据库文件中			
func save_plugin_data():
	pass

#从已加载的插件数据库中获取对应键的值		
func get_plugin_data(key):
	pass

#设置插件数据库中对应键的值，save_file表示是否在设置时立刻保存到文件	
func set_plugin_data(key,value,save_file:bool=true):
	pass
