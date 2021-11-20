extends Node


var plugin_path = OS.get_executable_path().get_base_dir() + "/plugins/"
var plugin_config_path = OS.get_executable_path().get_base_dir() + "/config/" 
var plugin_data_path = OS.get_executable_path().get_base_dir() + "/data/"

var loaded_scripts:Dictionary = {}


var default_plugin_info = {
	"id":"",
	"name":"",
	"author":"",
	"version":"",
	"description":""
}


func _ready():
	add_to_group("console_command_plugins")
	var usages = [
		"plugins list - 查看所有已加载的插件列表",
		"plugins load <文件名> - 加载一个指定的插件",
		"plugins unload <插件id> - 卸载一个指定的插件",
		"plugins reload <插件id> - 重新加载一个指定的插件",
		"plugins areload - 重新加载所有插件",
		"plugins create <文件名> - 新建一个插件",
		"plugins edit <文件名> - 编辑一个插件",
		"plugins delete <文件名> - 删除一个插件"
	]
	CommandManager.register_console_command("plugins",true,usages,"RainyBot-Core")


func _call_console_command(cmd:String,args:Array):
	match args[0]:
		"list":
			GuiManager.console_print_text("-----插件列表-----")
			for child in get_children():
				GuiManager.console_print_text(str(child.get_plugin_info()))
			GuiManager.console_print_text("-----插件列表-----")
		"load":
			if args.size() > 1:
				load_plugin(args[1])
			else:
				GuiManager.console_print_error("错误的命令用法!输入help plugins来查看帮助")
		"unload":
			if args.size() > 1:
				var plugin = get_node_or_null(args[1])
				if is_instance_valid(plugin):
					unload_plugin(plugin)
				else:
					GuiManager.console_print_error("插件id不存在!")
			else:
				GuiManager.console_print_error("错误的命令用法!输入help plugins来查看帮助")
					
		"reload":
			if args.size() > 1:
				var plugin = get_node_or_null(args[1])
				if is_instance_valid(plugin):
					reload_plugin(plugin)
				else:
					GuiManager.console_print_error("插件id不存在!")
			else:
				GuiManager.console_print_error("错误的命令用法!输入help plugins来查看帮助")
		"areload":
			reload_plugins()
		"edit":
			if args.size() > 1:
				var file_name:String = args[1]
				if File.new().file_exists(plugin_path+file_name) && file_name.ends_with(".gd"):
					GuiManager.console_print_warning("正在启动插件编辑器...")
					GuiManager.open_plugin_editor(plugin_path+file_name)
				else:
					GuiManager.console_print_error("插件文件不存在或格式错误!")
			else:
				GuiManager.console_print_error("错误的命令用法!输入help plugins来查看帮助")
		"create":
			if args.size() > 1:
				var file_name:String = args[1]
				if File.new().file_exists(plugin_path+file_name):
					GuiManager.console_print_error("此插件文件已存在!")
				elif file_name.ends_with(".gd"):
					var scr:GDScript = load("res://Core/Templates/PluginTemplate.gd")
					if ResourceSaver.save(plugin_path+file_name,scr) == OK:
						GuiManager.console_print_success("插件文件创建成功! 路径: "+plugin_path+file_name)
						GuiManager.console_print_success("您可以使用以下指令来开始编辑插件: plugins edit "+file_name)
					else:
						GuiManager.console_print_error("插件文件创建失败，请检查文件权限是否正确!")
				else:
					GuiManager.console_print_error("插件文件名格式错误，正确格式: <文件名>.gd")
		"delete":
			if args.size() > 1:
				var file_name:String = args[1]
				if File.new().file_exists(plugin_path+file_name) && file_name.ends_with(".gd"):
					var dir = Directory.new()
					if dir.open(plugin_path)==OK && dir.remove(plugin_path+file_name)==OK:
						var plug = get_plugin_with_filename(file_name)
						if is_instance_valid(plug):
							unload_plugin(plug)
						GuiManager.console_print_success("插件文件删除成功!")
					else:
						GuiManager.console_print_error("插件文件删除失败，请检查文件权限是否正确!")
				else:
					GuiManager.console_print_error("插件文件不存在或格式错误!")	
		_:
			GuiManager.console_print_error("错误的命令用法!输入help plugins来查看帮助")


func load_plugin_script(path:String)->GDScript:
	var _file = File.new()
	var _err = _file.open(path,File.READ)
	if _err == OK:
		var _str = _file.get_as_text()
		_file.close()
		var _script:GDScript
		if !loaded_scripts.has(path):
			_script = GDScript.new()
			_script.resource_path = path
			_script.resource_name = path.get_file()
			loaded_scripts[path]=_script
		else:
			_script = loaded_scripts[path]
		_script.source_code = _str
		return _script
	else:
		_file.close()
		return		


func load_plugin(file:String):
	var plugin_res = load_plugin_script(plugin_path + file)
	if !is_instance_valid(plugin_res) || plugin_res.reload() != OK:
		GuiManager.console_print_error("无法加载插件文件: " + file)
		GuiManager.console_print_error("此文件不存在，不是插件文件或已损坏...")
		return
	var plugin_ins:Plugin = plugin_res.new()
	GuiManager.console_print_warning("正在尝试加载插件文件: " + file)
	if is_instance_valid(plugin_ins):
		var _plugin_info = plugin_ins.get_plugin_info()
		if _plugin_info.has_all(default_plugin_info.keys()):
			var err_arr = []
			for key in _plugin_info:
				if _plugin_info[key] == "":
					err_arr.append(key)
			if !err_arr.is_empty():
				GuiManager.console_print_error("无法加载插件文件: " + file)
				GuiManager.console_print_error("此插件的以下插件信息参数不正确: "+str(err_arr))
				plugin_ins.queue_free()
				return
			for child in get_children():
				if child.name == _plugin_info["id"]:
					GuiManager.console_print_error("无法加载插件文件: " + file)
					GuiManager.console_print_error("已经存在相同ID的插件被加载: "+str(_plugin_info["id"]))
					plugin_ins.queue_free()
					return
			plugin_ins.name = _plugin_info["id"]
			plugin_ins.plugin_path = plugin_path + file
			plugin_ins.plugin_file = file
			add_child(plugin_ins,true)
			GuiManager.console_print_success("成功加载插件 " + _plugin_info["name"] + " "+str(_plugin_info))
		else:
			plugin_ins.queue_free()
			GuiManager.console_print_error("无法加载插件文件: " + file)
			GuiManager.console_print_error("此插件的插件信息存在缺失")
	else:
		GuiManager.console_print_error("无法加载插件文件: " + file)
		GuiManager.console_print_error("此文件不是插件文件或已损坏...")
		
		
func unload_plugin(plugin:Plugin):
	var _plugin_info = plugin.get_plugin_info()
	GuiManager.console_print_warning("正在卸载插件: " + _plugin_info["name"])
	plugin.queue_free()
	await plugin.tree_exited
	plugin.set_script(null)
	GuiManager.console_print_success("成功卸载插件 " + _plugin_info["name"] + " "+str(_plugin_info))


func reload_plugin(plugin:Plugin):
	var _plugin_info = plugin.get_plugin_info()
	GuiManager.console_print_warning("正在重载插件: " + _plugin_info["name"])
	var file = plugin.get_plugin_filename()
	await unload_plugin(plugin)
	load_plugin(file)

		
func reload_plugins():
	GuiManager.console_print_warning("正在重载所有插件.....插件目录: "+plugin_path)
	for child in get_children():
		await unload_plugin(child)
	var files:Array = _list_files_in_directory(plugin_path)
	if files.size() == 0:
		GuiManager.console_print_warning("插件目录下未找到任何插件...")
		return
	for path in files:
		await get_tree().process_frame
		load_plugin(path)


func unload_plugins():
	for child in get_children():
		await unload_plugin(child)


func get_plugin_instance(plugin_id):
	return get_node_or_null(plugin_id)


func get_plugin_with_filename(f_name:String)->Plugin:
	var arr = PluginManager.get_children()
	for child in arr:
		var plug:Plugin = child
		var file = plug.plugin_file
		if file == f_name:
			return plug
	return null


func _list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	if !dir.dir_exists(path):
		dir.make_dir(path)
		GuiManager.console_print_warning("插件目录不存在，已创建新的插件目录!")
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.get_extension() == "gd":
			files.append(file)

	dir.list_dir_end()

	return files
