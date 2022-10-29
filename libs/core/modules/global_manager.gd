extends Node


const INIT_PATH:Array = [
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

var godot_dir_path:String = root_path + ".godot/"
var project_file_path:String = root_path+"project.godot"
var import_helper_path:String = "res://libs/resources/addons/import_helper/"
var import_helper_target_path:String = root_path+"addons/import_helper/"

var global_timer:Timer = Timer.new()
var global_run_time:int = 0

var restarting:bool = false

var last_log_text:String = ""
var last_errors:PackedStringArray = []

var loading_resources:Dictionary = {}




func _init()->void:
	var icon:Image = Image.new()
	icon.load("res://libs/resources/logo.png")
	DisplayServer.set_icon(icon)
	randomize()
	_init_dir()


func _ready()->void:
	get_tree().set_auto_accept_quit(false)
	add_to_group("console_command_stop")
	add_to_group("console_command_restart")
	CommandManager.register_console_command("stop",false,["stop - 卸载所有插件并安全退出RainyBot进程"],"RainyBot-Core",false)
	CommandManager.register_console_command("restart",false,["restart - 卸载所有插件并重新启动RainyBot进程"],"RainyBot-Core",false)
	
	global_timer.connect("timeout",_on_global_timer_timeout)
	add_child(global_timer)
	global_timer.start(1.0)


func _physics_process(_delta:float)->void:
	_check_load_status()
	check_error()


func _init_dir()->void:
	for p in INIT_PATH:
		var path:String = OS.get_executable_path().get_base_dir() + p
		if !DirAccess.dir_exists_absolute(path):
			DirAccess.make_dir_absolute(path)
		if p != "/plugins/":
			if !FileAccess.file_exists(path+".gdignore"):
				FileAccess.open(path+".gdignore",FileAccess.WRITE)
			
			
func _notification(what:int)->void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		GuiManager.console_print_warning("正在安全退出RainyBot核心进程.....")
		await PluginManager.unload_plugins()
		BotAdapter.mirai_client.disconnect_to_mirai()
		await get_tree().create_timer(0.5).timeout
		GuiManager.console_print_success("RainyBot核心进程已被安全退出!")
		await get_tree().create_timer(0.5).timeout
		clear_cache()
		Console.save_log(true)
		if restarting:
			OS.create_instance([])
		get_tree().quit()


func _call_console_command(_cmd:String,_args:Array)->void:
	if _cmd == "stop":
		notification(NOTIFICATION_WM_CLOSE_REQUEST)
	elif _cmd == "restart":
		restart()


func _on_global_timer_timeout()->void:
	global_run_time += 1


func _check_load_status()->void:
	for path in loading_resources:
		if ResourceLoader.load_threaded_get_status(path) != ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var helper:ResourceLoadHelper = loading_resources[path]
			loading_resources.erase(path)
			helper.emit_signal("finished")


func clear_cache()->void:
	GuiManager.console_print_warning("正在清理缓存目录，请稍候.....")
	clear_dir_files(cache_path,false)
	if !FileAccess.file_exists(cache_path+".gdignore"):
		FileAccess.open(cache_path+".gdignore",FileAccess.WRITE)
	GuiManager.console_print_success("缓存目录清理完毕!")


func restart()->void:
	restarting = true
	GuiManager.console_print_warning("正在重新启动RainyBot.....")
	notification(NOTIFICATION_WM_CLOSE_REQUEST)


func check_error()->void:
	var _f:FileAccess = FileAccess.open("user://logs/rainybot.log",FileAccess.READ)
	var curr_text:String = _f.get_as_text()
	if last_log_text == "":
		last_log_text = curr_text
	elif last_log_text != curr_text:
		last_errors.resize(0)
		var _err:PackedStringArray = curr_text.replacen(last_log_text,"").split("\n")
		for i in _err.size():
			var _l:String = _err[i]
			if _l.findn("USER SCRIPT ERROR: ")!=-1:
				var _err_t:String = _l.replacen("USER SCRIPT ERROR: ","")
				if i < _err.size()-1:
					var _sl:PackedStringArray = _err[i+1].split(":")
					var _line:int = abs(_sl[_sl.size()-1].to_int())
					var _text:String = "第%s行 - %s"%[_line,_err_t]
					last_errors.append("脚本运行时错误: "+_text)
					GuiManager.console_print_error("检测到脚本运行时错误: "+_text)
		last_log_text = curr_text
		if !last_errors.is_empty():
			get_tree().call_group("Plugin","_on_error")


func reimport()->void:
	GuiManager.console_print_warning("正在准备重新导入资源.....")
	await get_tree().create_timer(0.5).timeout
	await PluginManager.unload_plugins()
	BotAdapter.mirai_client.disconnect_to_mirai()
	clear_cache()
	_add_import_helper()
	await get_tree().create_timer(0.5).timeout
	GuiManager.console_print_warning("正在重新导入资源，在此过程中RainyBot将会停止响应，请耐心等待.....")
	await get_tree().create_timer(0.5).timeout
	clear_dir_files(godot_dir_path)
	await get_tree().create_timer(0.5).timeout
	OS.execute(OS.get_executable_path(),["--editor","--headless","--wait-import"])
	_remove_import_helper()
	GuiManager.console_print_success("资源重新导入完毕！正在准备重新启动RainyBot...")
	await get_tree().create_timer(0.5).timeout
	restart()


func clear_dir_files(dir_path:String,remove_dir:bool=true)->void:
	if DirAccess.dir_exists_absolute(dir_path):
		var dir:DirAccess = DirAccess.open(dir_path)
		dir.include_hidden = true
		for _file in dir.get_files():
			dir.remove(dir_path+_file)
		for _dir in dir.get_directories():
			clear_dir_files(dir_path+_dir+"/")
		if remove_dir:
			dir.remove(dir_path)


func load_threaded(path:String,type_hint:String="",use_sub_threads:bool=false)->Resource:
	if ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_LOADED:
		GuiManager.console_print_success("此资源此前已被加载，正在返回已加载的资源: "+path)
		return ResourceLoader.load_threaded_get(path)
	else:
		GuiManager.console_print_warning("正在请求异步加载以下路径的资源: "+path)
		var err:int = ResourceLoader.load_threaded_request(path,type_hint,use_sub_threads)
		if !err:
			var helper:ResourceLoadHelper = ResourceLoadHelper.new()
			loading_resources[path]=helper
			GuiManager.console_print_warning("资源异步加载请求成功，开始等待以下路径的资源加载完成: "+path)
			await helper.finished
			if ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_LOADED:
				GuiManager.console_print_success("成功异步加载以下路径的资源: "+path)
				return ResourceLoader.load_threaded_get(path)
			else:
				GuiManager.console_print_error("异步加载以下路径的资源时出现错误，请检查文件路径或状态是否有误: "+path)
				return null
		else:
			GuiManager.console_print_error("异步加载以下路径的资源时出现错误，请检查文件路径或状态是否有误: "+path)
			return null


func is_running_from_editor()->bool:
	for arg in OS.get_cmdline_args():
		if arg == "--from-editor":
			return true
	return false


func _add_import_helper()->void:
	var c_file:ConfigFile = ConfigFile.new()
	var err:int = c_file.load(project_file_path)
	var arr:Array = ["res://addons/import_helper/plugin.cfg"]
	if !DirAccess.dir_exists_absolute(import_helper_target_path):
		DirAccess.make_dir_recursive_absolute(import_helper_target_path)
	var dir:DirAccess = DirAccess.open(import_helper_path)
	dir.include_hidden = true
	for f in dir.get_files():
		dir.copy(import_helper_path+f,import_helper_target_path+f)
	dir.copy(project_file_path,"res://project.godot.bak")
	c_file.set_value("editor_plugins","enabled",PackedStringArray(arr))
	c_file.save(project_file_path)


func _remove_import_helper()->void:
	clear_dir_files(root_path+"addons/")
	DirAccess.copy_absolute("res://project.godot.bak",project_file_path)
	DirAccess.remove_absolute("res://project.godot.bak")


class ResourceLoadHelper:
	extends RefCounted
	signal finished
