extends Node


var plugin_path = OS.get_executable_path().get_base_dir() + "/plugins/" 


var default_plugin_info = {
	"id":"",
	"name":"",
	"author":"",
	"version":"",
	"description":""
}


func _ready():
	add_to_group("command")
	var usages = [
		"plugins list - 查看所有已加载的插件列表",
		"plugins load <文件名> - 加载一个指定的插件",
		"plugins unload <插件id> - 卸载一个指定的插件",
		"plugins reload <插件id> - 重新加载一个指定的插件",
		"plugins areload - 重新加载所有插件"
	]
	CommandManager.register_command("plugins",true,usages,"RainyBot-Core")


func _command_plugins(args:Array):
	match args[0]:
		"list":
			print("-----插件列表-----")
			for child in get_children():
				print(child.get_plugin_info())
			print("-----插件列表-----")
		"load":
			if args.size() > 1:
				load_plugin(args[1])
			else:
				printerr("错误的命令用法!输入help plugins来查看帮助")
		"unload":
			if args.size() > 1:
				var plugin = get_node_or_null(args[1])
				if is_instance_valid(plugin):
					unload_plugin(plugin)
				else:
					printerr("插件id不存在!")
			else:
				printerr("错误的命令用法!输入help plugins来查看帮助")
					
		"reload":
			if args.size() > 1:
				var plugin = get_node_or_null(args[1])
				if is_instance_valid(plugin):
					reload_plugin(plugin)
				else:
					printerr("插件id不存在!")
			else:
				printerr("错误的命令用法!输入help plugins来查看帮助")
		"areload":
			reload_plugins()
		_:
			printerr("错误的命令用法!输入help plugins来查看帮助")


func load_plugin(file:String):
	var plugin_res = load(plugin_path + file)
	if !plugin_res is GDScript:
		printerr("无法加载插件文件: " + file)
		printerr("此文件不存在，不是插件文件或已损坏...")
		return
	var plugin_ins:Plugin = plugin_res.new()
	print("正在尝试加载插件文件: " + file)
	if is_instance_valid(plugin_ins):
		var _plugin_info = plugin_ins.get_plugin_info()
		if _plugin_info.has_all(default_plugin_info.keys()):
			var err_arr = []
			for key in _plugin_info:
				if _plugin_info[key] == "":
					err_arr.append(key)
			if !err_arr.empty():
				printerr("无法加载插件文件: " + file)
				printerr("此插件的以下插件信息参数不正确: ",err_arr)
				plugin_ins.queue_free()
				return
			if get_children().has(_plugin_info["id"]):
				printerr("无法加载插件文件: " + file)
				printerr("已经存在相同ID的插件被加载: ", _plugin_info["id"])
				plugin_ins.queue_free()
				return
			plugin_ins.name = _plugin_info["id"]
			plugin_ins.plugin_path = plugin_path + file
			plugin_ins.plugin_file = file
			add_child(plugin_ins,true)
			print("成功加载插件 " + _plugin_info["name"] + " ",_plugin_info)
		else:
			plugin_ins.queue_free()
			printerr("无法加载插件文件: " + file)
			printerr("此插件的插件信息存在缺失")
	else:
		printerr("无法加载插件文件: " + file)
		printerr("此文件不是插件文件或已损坏...")
		
		
func unload_plugin(plugin:Plugin):
	var _plugin_info = plugin.get_plugin_info()
	print("正在卸载插件: " + _plugin_info["name"])
	plugin.queue_free()


func reload_plugin(plugin:Plugin):
	var _plugin_info = plugin.get_plugin_info()
	print("正在重载插件: " + _plugin_info["name"])
	var file = plugin.get_plugin_file()
	unload_plugin(plugin)
	yield(get_tree(),"idle_frame")
	load_plugin(file)

		
func reload_plugins():
	print("正在重载所有插件.....插件目录: ",plugin_path)
	for child in get_children():
		yield(get_tree(),"idle_frame")
		unload_plugin(child)
	var files:Array = _list_files_in_directory(plugin_path)
	if files.size() == 0:
		print("插件目录下未找到任何插件...")
		return
	for path in files:
		yield(get_tree(),"idle_frame")
		load_plugin(path)


func get_plugin_instance(plugin_id):
	return get_node_or_null(plugin_id)


func _list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	if !dir.dir_exists(path):
		dir.make_dir(path)
		print("插件目录不存在，已创建新的插件目录���")
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
