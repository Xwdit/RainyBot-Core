extends Node


const INIT_PATH = [
	"/plugins/",
	"/config/",
	"/data/",
	"/cache/",
	"/logs/",
]

var root_path:String = OS.get_executable_path().get_base_dir()+"/"
var adapter_path:String = root_path+"adapters/"
var plugin_path:String = root_path+"plugins/"
var config_path:String = root_path+"config/"
var data_path:String = root_path+"data/"
var cache_path:String = root_path+"cache/"
var log_path:String = root_path+"logs/"

var project_file_path:String = root_path+"project.godot"
var import_helper_path:String = "res://libs/resources/addons/import_helper/"
var import_helper_target_path:String = root_path+"addons/import_helper/"

var global_timer:Timer = Timer.new()
var global_run_time:int = 0

var restarting:bool = false

var last_log_text:String = ""
var last_errors:PackedStringArray = []

var loading_resources:Dictionary = {}


func _init():
	var icon = Image.new()
	icon.load("res://libs/resources/logo.png")
	DisplayServer.set_icon(icon)
	randomize()
	_init_dir()


func _ready():
	get_tree().set_auto_accept_quit(false)
	add_to_group("console_command_stop")
	add_to_group("console_command_restart")
	CommandManager.register_console_command("stop",false,["stop - 卸载所有插件并安全退出RainyBot进程"],"RainyBot-Core",false)
	CommandManager.register_console_command("restart",false,["restart - 卸载所有插件并重新启动RainyBot进程"],"RainyBot-Core",false)
	
	global_timer.connect("timeout",_on_global_timer_timeout)
	add_child(global_timer)
	global_timer.start(1.0)


func _process(delta):
	check_error()
	_check_load_status()


func _init_dir():
	var dir = Directory.new()
	var file = File.new()
	for p in INIT_PATH:
		var path = OS.get_executable_path().get_base_dir() + p
		if !dir.dir_exists(path):
			dir.make_dir(path)
		if p != "/plugins/":
			if !file.file_exists(path+".gdignore"):
				file.open(path+".gdignore",File.WRITE)
				file.close()
			
			
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
		if restarting:
			OS.create_instance([])
		get_tree().quit()


func _call_console_command(_cmd:String,_args:Array):
	if _cmd == "stop":
		notification(NOTIFICATION_WM_CLOSE_REQUEST)
	elif _cmd == "restart":
		restart()


func _on_global_timer_timeout():
	global_run_time += 1


func _check_load_status():
	for path in loading_resources:
		if ResourceLoader.load_threaded_get_status(path) != ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var helper:ResourceLoadHelper = loading_resources[path]
			loading_resources.erase(path)
			helper.emit_signal("finished")


func clear_cache():
	Console.print_warning("正在清理缓存目录，请稍候.....")
	clear_dir_files(cache_path,false)
	var file = File.new()
	if !file.file_exists(cache_path+".gdignore"):
		file.open(cache_path+".gdignore",File.WRITE)
		file.close()
	Console.print_success("缓存目录清理完毕!")


func restart():
	restarting = true
	Console.print_warning("正在重新启动RainyBot.....")
	notification(NOTIFICATION_WM_CLOSE_REQUEST)


func check_error():
	var _f = File.new()
	_f.open("user://logs/rainybot.log",File.READ)
	var curr_text = _f.get_as_text()
	_f.close()
	if last_log_text == "":
		last_log_text = curr_text
	elif last_log_text != curr_text:
		last_errors.resize(0)
		var _err = curr_text.replacen(last_log_text,"").split("\n")
		for _l in _err:
			if _l.findn("built-in")!=-1:
				var _sl = _l.split(" - ")
				var _text = "第%s行 - %s"%[abs(_sl[0].to_int()),_sl[1]]
				last_errors.append("脚本运行时错误: "+_text)
				Console.print_error("检测到脚本运行时错误: "+_text)
		last_log_text = curr_text
		get_tree().call_group("Plugin","_on_error")


func reimport():
	Console.print_warning("正在准备重新导入资源.....")
	await get_tree().create_timer(0.5).timeout
	await PluginManager.unload_plugins()
	BotAdapter.mirai_client.disconnect_to_mirai()
	clear_cache()
	_add_import_helper()
	await get_tree().create_timer(0.5).timeout
	Console.print_warning("正在重新导入资源，在此过程中RainyBot将会停止响应，请耐心等待.....")
	await get_tree().create_timer(0.5).timeout
	OS.execute(OS.get_executable_path(),["--editor","--headless","--clear-import"])
	OS.execute(OS.get_executable_path(),["--editor","--headless","--wait-import"])
	_remove_import_helper()
	Console.print_success("资源重新导入完毕！正在准备重新启动RainyBot...")
	await get_tree().create_timer(0.5).timeout
	restart()


func clear_dir_files(dir_path,remove_dir:bool=true):
	var dir = Directory.new()
	if dir.dir_exists(dir_path):
		dir.open(dir_path)
		for _file in dir.get_files():
			dir.remove(dir_path+_file)
		for _dir in dir.get_directories():
			clear_dir_files(dir_path+_dir+"/")
		if remove_dir:
			dir.remove(dir_path)


func load_threaded(path:String,type_hint:String="",use_sub_threads:bool=false)->Resource:
	Console.print_warning("正在请求异步加载以下路径的资源: "+path)
	var err = ResourceLoader.load_threaded_request(path,type_hint,use_sub_threads)
	if err == OK:
		var helper = ResourceLoadHelper.new()
		loading_resources[path]=helper
		Console.print_warning("资源异步加载请求成功，开始等待以下路径的资源加载完成: "+path)
		await helper.finished
		if ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_LOADED:
			Console.print_success("成功异步加载以下路径的资源: "+path)
			return ResourceLoader.load_threaded_get(path)
		else:
			Console.print_error("异步加载以下路径的资源时出现错误，请检查文件路径或状态是否有误: "+path)
			return null
	else:
		Console.print_error("异步加载以下路径的资源时出现错误，请检查文件路径或状态是否有误: "+path)
		return null


func running_from_editor()->bool:
	for arg in OS.get_cmdline_args():
		if arg == "--from-editor":
			return true
	return false


func _add_import_helper():
	var c_file = ConfigFile.new()
	var dir = Directory.new()
	var err:int = c_file.load(project_file_path)
	var arr:Array = ["res://addons/import_helper/plugin.cfg"]
	if !dir.dir_exists(import_helper_target_path):
		dir.make_dir_recursive(import_helper_target_path)
	dir.open(import_helper_path)
	for f in dir.get_files():
		dir.copy(import_helper_path+f,import_helper_target_path+f)
	c_file.set_value("editor_plugins","enabled",PackedStringArray(arr))
	c_file.save(project_file_path)
	
	
func _remove_import_helper():
	clear_dir_files(root_path+"addons/")
	var c_file = ConfigFile.new()
	var err:int = c_file.load(project_file_path)
	if c_file.has_section("editor_plugins"):
		c_file.erase_section("editor_plugins")
	c_file.save(project_file_path)


class ResourceLoadHelper:
	extends RefCounted
	signal finished
