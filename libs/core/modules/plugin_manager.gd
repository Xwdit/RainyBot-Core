extends Node


signal plugin_list_changed()


var plugin_path:String = GlobalManager.plugin_path
var plugin_config_path:String = GlobalManager.config_path 
var plugin_data_path:String = GlobalManager.data_path
var plugin_cache_path:String = GlobalManager.cache_path

var loaded_scripts:Dictionary = {}
var file_load_status:Dictionary = {}
var plugin_event_dic:Dictionary = {}
var plugin_files_dic:Dictionary = {}


var default_plugin_info:Dictionary = {
	"id":"",
	"name":"",
	"author":"",
	"version":"",
	"description":""
}


func _ready()->void:
	add_to_group("console_command_plugins")
	add_to_group("console_command_plugin")
	var usages:Array = [
		"plugins list - 查看所有已加载的插件列表",
		"plugins load <文件名> - 加载一个指定的插件",
		"plugins unload <插件ID> - 卸载一个指定的插件",
		"plugins reload <插件ID> - 重新加载一个指定的插件",
		"plugins areload - 重新加载所有插件",
		"plugins reimport - 重新导入所有资源并重新启动",
		"plugins create <文件名> - 新建一个插件",
		"plugins edit <文件名> - 编辑一个插件",
		"plugins delete <文件名> - 删除一个插件",
		"plugins cdata <插件ID> - 清除指定插件的数据库中的所有数据",
		"plugins cdata <插件ID> <数据项名称> - 清除指定插件数据库中指定数据项的值",
		"plugins pdata <插件ID> - 列出指定插件数据库中的所有数据项的列表",
		"plugins pdata <插件ID> <数据项名称> - 打印指定插件数据库中指定数据项的值"
	]
	CommandManager.register_console_command("plugins",true,usages,"RainyBot-Core",false)


func call_event(event:Event)->void:
	if plugin_event_dic.has(event.get_script()):
		var arr:Array = plugin_event_dic[event.get_script()]
		for c in arr.duplicate():
			var _func:Array = c["function"]
			var _block_mode:int = c["block_mode"]
			var _stop:bool = false
			for _callable in _func:
				if _callable is Callable and _callable.is_valid():
					var _block = _callable.call(event)
					if _block is bool && _block == true:
						match _block_mode:
							int(Plugin.BlockMode.ALL):
								return
							int(Plugin.BlockMode.FUNCTION):
								break
							int(Plugin.BlockMode.EVENT):
								_stop = true
			if _stop:
				return


func _call_console_command(_cmd:String,args:Array)->void:
	match args[0]:
		"list":
			GuiManager.console_print_text("-----插件列表-----")
			for child in get_children():
				GuiManager.console_print_text(get_beautify_plugin_info(child.get_plugin_info()))
			GuiManager.console_print_text("-----插件列表-----")
		"cdata":
			if args.size() > 2:
				var plugin:Plugin = get_node_or_null(args[1])
				if is_instance_valid(plugin):
					if plugin.has_plugin_data(args[2]):
						plugin.remove_plugin_data(args[2])
					else:
						GuiManager.console_print_error("指定的插件数据项不存在!")
				else:
					GuiManager.console_print_error("插件ID不存在!")
			elif args.size() > 1:
				var plugin:Plugin = get_node_or_null(args[1])
				if is_instance_valid(plugin):
					plugin.clear_plugin_data()
				else:
					GuiManager.console_print_error("插件ID不存在!")
			else:
				GuiManager.console_print_error("错误的命令用法! 请输入help plugins来查看帮助!")
		"pdata":
			if args.size() > 2:
				var plugin:Plugin = get_node_or_null(args[1])
				if is_instance_valid(plugin):
					if plugin.has_plugin_data(args[2]):
						GuiManager.console_print_text("插件数据项%s的值为: %s"%[args[2],str(plugin.get_plugin_data(args[2]))])
					else:
						GuiManager.console_print_error("指定的插件数据项不存在!")
				else:
					GuiManager.console_print_error("插件ID不存在!")
			elif args.size() > 1:
				var plugin:Plugin = get_node_or_null(args[1])
				if is_instance_valid(plugin):
					if plugin.plugin_data_loaded:
						GuiManager.console_print_text("插件数据库中当前存在的数据项列表为: %s"% str(plugin.get_plugin_data_metadata().keys()))
						GuiManager.console_print_text("您可以使用命令 plugins pdata <插件ID> <数据项名称> 来查看指定数据项的值")
					else:
						GuiManager.console_print_error("此插件暂未初始化插件数据库，因此无法获取其数据项列表!")
			else:
				GuiManager.console_print_error("错误的命令用法! 请输入help plugins来查看帮助!")
		"load":
			if args.size() > 1:
				load_plugin(args[1])
			else:
				GuiManager.console_print_error("错误的命令用法! 请输入help plugins来查看帮助!")
		"unload":
			if args.size() > 1:
				var plugin:Plugin = get_node_or_null(args[1])
				if is_instance_valid(plugin):
					unload_plugin(plugin)
				else:
					GuiManager.console_print_error("插件ID不存在!")
			else:
				GuiManager.console_print_error("错误的命令用法! 请输入help plugins来查看帮助!")
		"reload":
			if args.size() > 1:
				var plugin:Plugin = get_node_or_null(args[1])
				if is_instance_valid(plugin):
					reload_plugin(plugin)
				else:
					GuiManager.console_print_error("插件ID不存在!")
			else:
				GuiManager.console_print_error("错误的命令用法! 请输入help plugins来查看帮助!")
		"areload":
			reload_plugins()
		"reimport":
			GlobalManager.reimport()
		"edit":
			if args.size() > 1:
				var file_name:String = args[1]
				GuiManager.open_plugin_editor(plugin_path+file_name)
			else:
				GuiManager.console_print_error("错误的命令用法! 请输入help plugins来查看帮助!")
		"create":
			if args.size() > 1:
				create_plugin(args[1])
			else:
				GuiManager.console_print_error("错误的命令用法! 请输入help plugins来查看帮助!")
		"delete":
			if args.size() > 1:
				delete_plugin(args[1])
			else:
				GuiManager.console_print_error("错误的命令用法! 请输入help plugins来查看帮助!")	
		_:
			GuiManager.console_print_error("错误的命令用法! 请输入help plugins来查看帮助!")


func load_plugin_script(path:String)->GDScript:
	var _file:FileAccess = FileAccess.open(path,FileAccess.READ)
	if _file:
		var _str:String = _file.get_as_text()
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
		return		


func load_plugin(file:String,files_dic:Dictionary={},source:String="")->int:
	file_load_status[file] = false
	GuiManager.console_print_warning("正在尝试加载插件文件: " + file)
	var _f_dic:Dictionary
	if !files_dic.is_empty():
		_f_dic = files_dic
	else:
		_f_dic = get_plugin_files_dic()
	for _id in _f_dic:
		var _f:Dictionary = _f_dic[_id]
		if _f.file == file:
			var _info:Dictionary = _f.info
			var _dependency:Array = _info.dependency
			var _inst_dic:Dictionary = get_plugin_instance_dic()
			if _inst_dic.has(_info.id.to_lower()):
				GuiManager.console_print_error("无法加载插件文件: " + file)
				GuiManager.console_print_error("已经存在相同ID的插件被加载: "+str(_id))
				return ERR_ALREADY_EXISTS
			for _dep in _dependency:
				if !_inst_dic.has(_dep.to_lower()):
					if _id.to_lower() == _dep.to_lower():
						GuiManager.console_print_error("无法加载插件文件: " + file)
						GuiManager.console_print_error("此插件将其自身设置为了所需的依赖插件！")
						return ERR_CYCLIC_LINK
					if source.to_lower() == _dep.to_lower():
						GuiManager.console_print_error("无法加载插件文件: " + file)
						GuiManager.console_print_error("此插件与以下插件出现了循环依赖: "+str(source))
						return ERR_CYCLIC_LINK
					if _f_dic.has(_dep.to_lower()):
						if (!file_load_status.has(_f_dic[_dep.to_lower()].file)) || (file_load_status[_f_dic[_dep.to_lower()].file] != false):
							GuiManager.console_print_warning("正在尝试加载此插件所需的依赖插件: " + _dep)
							await load_plugin(_f_dic[_dep.to_lower()].file,_f_dic,_id)
							await get_tree().process_frame
							if (!file_load_status.has(_f_dic[_dep.to_lower()].file)) || (file_load_status[_f_dic[_dep.to_lower()].file] == false):
								GuiManager.console_print_error("无法加载插件文件: " + file)
								GuiManager.console_print_error("此插件所需的依赖插件加载失败: "+_dep)
								return ERR_LINK_FAILED
						else:
							GuiManager.console_print_error("无法加载插件文件: " + file)
							GuiManager.console_print_error("此插件所需的依赖插件加载失败: "+_dep)
							return ERR_LINK_FAILED
					else:
						GuiManager.console_print_error("无法加载插件文件: " + file)
						GuiManager.console_print_error("未找到此插件所需的依赖插件: "+_dep)
						return ERR_LINK_FAILED
			var plugin_res:GDScript = load_plugin_script(plugin_path + file)
			var plugin_ins:Plugin = plugin_res.new()
			var _plugin_info:Dictionary = plugin_ins.get_plugin_info()
			plugin_ins.name = _plugin_info["id"].to_lower()
			plugin_ins.plugin_path = plugin_path + file
			plugin_ins.plugin_file = file
			plugin_ins.add_to_group("Plugin")
			add_child(plugin_ins,true)
			file_load_status[file] = true
			plugin_list_changed.emit()
			GuiManager.console_print_success("成功加载插件: " +get_beautify_plugin_info(_plugin_info))
			return OK
	GuiManager.console_print_error("无法加载插件文件: " + file)
	GuiManager.console_print_error("此插件文件不存在，或无法被加载！")
	return ERR_BUG


func unload_plugin(plugin:Plugin)->int:
	var _plugin_info:Dictionary = plugin.get_plugin_info()
	var _file:String = plugin.get_plugin_filename()
	GuiManager.console_print_warning("正在卸载插件: "+get_beautify_plugin_info(_plugin_info))
	var _dep_arr:Array = []
	for child in get_children():
		if  child.get_plugin_info().dependency.has(_plugin_info.id):
			_dep_arr.append(child.get_plugin_info().id)
	if _dep_arr.size() != 0:
		GuiManager.console_print_error("无法卸载插件，因为此插件被以下插件所依赖: " + str(_dep_arr))
		GuiManager.console_print_error("请先卸载所有被依赖的插件，然后再试一次！")
		return ERR_LOCKED
	plugin.queue_free()
	await plugin.tree_exited
	plugin.set_script(null)
	file_load_status.erase(_file)
	plugin_list_changed.emit()
	GuiManager.console_print_success("成功卸载插件: " +get_beautify_plugin_info(_plugin_info))
	return OK


func create_plugin(file_name:String)->int:
	if FileAccess.file_exists(plugin_path+file_name):
		GuiManager.console_print_error("此插件文件已存在!")
		return ERR_ALREADY_EXISTS
	if !file_name.ends_with(".gd"):
		file_name = file_name + ".gd"
	var scr:GDScript = load("res://libs/core/templates/plugin_template.gd")
	if ResourceSaver.save(scr,plugin_path+file_name) == OK:
		plugin_list_changed.emit()
		GuiManager.console_print_success("插件文件创建成功! 路径: "+plugin_path+file_name)
		GuiManager.console_print_success("您可以使用以下指令来开始编辑插件: plugins edit "+file_name)
		return OK
	else:
		GuiManager.console_print_error("插件文件创建失败，请检查文件权限是否正确!")
		return ERR_CANT_CREATE


func delete_plugin(file_name:String)->int:
	if FileAccess.file_exists(plugin_path+file_name) && file_name.ends_with(".gd"):
		var dir:DirAccess = DirAccess.open(plugin_path)
		if dir && dir.remove(plugin_path+file_name)==OK:
			var plug:Plugin = get_plugin_with_filename(file_name)
			if is_instance_valid(plug):
				await unload_plugin(plug)
			plugin_list_changed.emit()
			GuiManager.console_print_success("插件文件删除成功!")
			return OK
		else:
			GuiManager.console_print_error("插件文件删除失败，请检查文件权限是否正确!")
			return ERR_CANT_OPEN
	else:
		GuiManager.console_print_error("插件文件不存在或格式错误!")
		return ERR_DOES_NOT_EXIST	


func reload_plugin(plugin:Plugin)->int:
	var _plugin_info:Dictionary = plugin.get_plugin_info()
	var file:String = plugin.get_plugin_filename()
	GuiManager.console_print_warning("正在重载插件: " + get_beautify_plugin_info(_plugin_info))
	var _dep_arr:Array = []
	for child in get_children():
		if  child.get_plugin_info().dependency.has(_plugin_info.id):
			_dep_arr.append(child.get_plugin_info().id)
	if _dep_arr.size() != 0:
		GuiManager.console_print_error("无法重载插件，因为此插件被以下插件所依赖: " + str(_dep_arr))
		GuiManager.console_print_error("请先卸载所有被依赖的插件，然后再试一次！")
		return ERR_LOCKED
	await unload_plugin(plugin)
	return await load_plugin(file)


func get_plugin_file_info(file:String)->Dictionary:
	var plugin_res:GDScript = load_plugin_script(plugin_path + file)
	for child in get_children():
		if child.get_script() == plugin_res:
			return child.get_plugin_info()
	if !is_instance_valid(plugin_res) || plugin_res.reload() != OK:
		GuiManager.console_print_error("无法读取插件文件: " + file)
		GuiManager.console_print_error("此文件不存在，不是插件文件或已损坏...")
		GuiManager.console_print_error("若文件确认无误，请检查插件脚本中是否存在错误！")
		GuiManager.console_print_error("您可以使用指令 plugins edit %s 打开内置编辑器来进行错误检查！"%[file])
		return {}
	var plugin_ins:Plugin = plugin_res.new()
	if is_instance_valid(plugin_ins):
		var _plugin_info:Dictionary = plugin_ins.get_plugin_info()
		plugin_ins.queue_free()
		if _plugin_info.has_all(default_plugin_info.keys()):
			var err_arr:Array = []
			for key in _plugin_info:
				if (_plugin_info[key] is String) and (_plugin_info[key] == ""):
					err_arr.append(key)
			if !err_arr.is_empty():
				GuiManager.console_print_error("无法读取插件文件: " + file)
				GuiManager.console_print_error("此文件的以下插件信息不能为空: "+str(err_arr))
				return {}
			return _plugin_info
		else:
			GuiManager.console_print_error("无法读取插件文件: " + file)
			GuiManager.console_print_error("此文件的插件信息存在缺失")
			return {}
	else:
		GuiManager.console_print_error("无法读取插件文件: " + file)
		GuiManager.console_print_error("此文件不存在，不是插件文件或已损坏...")
		GuiManager.console_print_error("若文件确认无误，请检查插件脚本中是否存在错误！")
		GuiManager.console_print_error("您可以使用指令 plugins edit %s 打开内置编辑器来进行错误检查！"%[file])
		return {}


func get_plugin_files_dic()->Dictionary:
	GuiManager.console_print_warning("开始扫描插件目录.....")
	var _file_dic:Dictionary = {}
	var _files:Array = _list_files_in_directory(plugin_path)
	file_load_status.clear()
	if _files.size() == 0:
		GuiManager.console_print_warning("插件目录下未找到任何插件...")
		return {}
	for _file in _files:
		var _plugin_info:Dictionary = get_plugin_file_info(_file)
		if _plugin_info.is_empty():
			file_load_status[_file] = false
			continue
		var _id:String = _plugin_info.id.to_lower()
		if _file_dic.has(_id):
			file_load_status[_file] = false
			GuiManager.console_print_error("无法读取插件文件: " + _file)
			GuiManager.console_print_error("已经存在ID为"+str(_id)+"的插件文件: "+str(_file_dic[_id].file))
			continue
		_file_dic[_id] = {"file":_file,"info":_plugin_info}
	plugin_files_dic = _file_dic
	GuiManager.console_print_success("插件目录扫描完毕！")
	return _file_dic
	
	
func get_plugin_instance_dic()->Dictionary:
	var _plugin_dic:Dictionary = {}
	for child in get_children():
		_plugin_dic[str(child.name).to_lower()]=child
	return _plugin_dic
		

func load_plugins()->int:
	var _files_dic:Dictionary = get_plugin_files_dic()
	var err_count:int = 0
	for _id in _files_dic:
		if file_load_status.has(_files_dic[_id].file):
			continue
		if get_plugin_instance_dic().has(_id.to_lower()):
			continue
		await get_tree().process_frame
		if await load_plugin(_files_dic[_id].file,_files_dic) != OK:
			err_count += 1
	get_tree().call_group("Plugin","_on_ready")
	return err_count


func unload_plugins()->int:
	var err_count:int = 0
	file_load_status.clear()
	var _childs:Array = get_children()
	_childs.reverse()
	for _child in _childs:
		if await unload_plugin(_child) != OK:
			err_count += 1
	return err_count
		
		
func reload_plugins()->int:
	var err_count:int = 0
	GuiManager.console_print_warning("正在重载所有插件.....插件目录: "+plugin_path)
	err_count += await unload_plugins()
	err_count += await load_plugins()
	GuiManager.console_print_success("所有插件重载完毕!")
	GuiManager.console_print_success("输入指令help可查看当前可用的指令列表!")
	return err_count


func get_plugin_instance(plugin_id:String)->Plugin:
	return get_node_or_null(plugin_id)


func get_plugin_with_filename(f_name:String)->Plugin:
	var arr:Array = get_children()
	for child in arr:
		var plug:Plugin = child
		var file:String = plug.plugin_file
		if file.to_lower() == f_name.to_lower():
			return plug
	return null


func _list_files_in_directory(path:String)->Array:
	var files:Array = []
	if !DirAccess.dir_exists_absolute(path):
		DirAccess.make_dir_recursive_absolute(path)
		GuiManager.console_print_warning("插件目录不存在，已创建新的插件目录!")
	var dir:DirAccess = DirAccess.open(path)
	dir.list_dir_begin()

	while true:
		var file:String = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.get_extension() == "gd":
			files.append(file)

	dir.list_dir_end()

	return files


func get_beautify_plugin_info(_info:Dictionary)->String:
	var _str:String = "{name} | ID:{id} | 作者:{author} | 版本:{version} | 描述:{description} | 依赖插件:{dependency}".format(_info)
	return _str
