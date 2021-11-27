extends Node


const INIT_PATH = [
	"/plugins/",
	"/config/",
	"/data/",
]


func _init():
	init_dir()


func _ready():
	get_tree().set_auto_accept_quit(false)
	add_to_group("console_command_stop")
	CommandManager.register_console_command("stop",false,["stop - 卸载所有插件并安全关闭RainyBot进程"],"RainyBot-Core",false)


func init_dir():
	var dir = Directory.new()
	for p in INIT_PATH:
		var path = OS.get_executable_path().get_base_dir() + p
		if !dir.dir_exists(path):
			dir.make_dir(path)
			
			
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		await PluginManager.unload_plugins()
		BotAdapter.mirai_client.disconnect_to_mirai()
		get_tree().quit()


func _call_console_command(cmd:String,args:Array):
	notification(NOTIFICATION_WM_CLOSE_REQUEST)
