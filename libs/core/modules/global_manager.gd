extends Node


const INIT_PATH = [
	"/plugins/",
	"/config/",
	"/data/",
	"/data/cache/",
	"/logs/",
]

var adapter_path:String = OS.get_executable_path().get_base_dir()+"/adapters/"
var plugin_path:String = OS.get_executable_path().get_base_dir()+"/plugins/"
var config_path:String = OS.get_executable_path().get_base_dir()+"/config/"
var data_path:String = OS.get_executable_path().get_base_dir()+"/data/"
var cache_path:String = OS.get_executable_path().get_base_dir()+"/data/cache/"
var log_path:String = OS.get_executable_path().get_base_dir()+"/logs/"


func _init():
	var icon = Image.new()
	icon.load("res://libs/resources/logo.png")
	DisplayServer.set_icon(icon)
	randomize()
	_init_dir()


func _ready():
	get_tree().set_auto_accept_quit(false)
	add_to_group("console_command_stop")
	CommandManager.register_console_command("stop",false,["stop - 卸载所有插件并安全退出RainyBot进程"],"RainyBot-Core",false)


func _init_dir():
	var dir = Directory.new()
	for p in INIT_PATH:
		var path = OS.get_executable_path().get_base_dir() + p
		if !dir.dir_exists(path):
			dir.make_dir(path)
			
			
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Console.print_warning("正在安全退出RainyBot核心进程.....")
		await PluginManager.unload_plugins()
		BotAdapter.mirai_client.disconnect_to_mirai()
		await get_tree().create_timer(0.5).timeout
		Console.print_success("RainyBot核心进程已被安全退出!")
		await get_tree().create_timer(0.5).timeout
		Console.save_log(true)
		clear_cache()
		get_tree().quit()


func _call_console_command(_cmd:String,_args:Array):
	notification(NOTIFICATION_WM_CLOSE_REQUEST)


func clear_cache():
	var dir = Directory.new()
	if dir.dir_exists(cache_path):
		dir.open(cache_path)
		for _file in dir.get_files():
			dir.remove(cache_path+_file)
