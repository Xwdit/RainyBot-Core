extends Control


@onready var plugin_list_ins:ItemList = $HSplitContainer/PluginListContainer/PluginList

var plugin_list_dic:Dictionary = {}
var current_selected:int = -1


func update_plugin_list():
	var _file_dic = PluginManager.get_plugin_files_dic()
	var _file_state_dic = PluginManager.file_load_status
	plugin_list_ins.clear()
	plugin_list_dic.clear()
	for _id in _file_dic:
		var loaded = PluginManager.get_node_or_null(_id.to_lower())!=null
		var _file:String = _file_dic[_id].file
		if loaded:
			_file += " (已加载)"
		else:
			_file += " (未加载)"
		var idx = plugin_list_ins.add_item(_file)
		plugin_list_dic[idx]=_file_dic[_id]
		plugin_list_dic[idx]["loaded"]=loaded
	for _file in _file_state_dic:
		if !_file_state_dic[_file]:
			var idx = plugin_list_ins.add_item(_file+" (读取错误)")
			plugin_list_dic[idx]={"file":_file,"loaded":false}
	if plugin_list_dic.is_empty():
		plugin_list_ins.add_item("插件目录下未找到任何插件文件...")
	$HSplitContainer/PluginInfoPanel.hide()
	$HSplitContainer/NoSelectLabel.show()


func set_lock_panel(locked):
	$HSplitContainer/PluginListContainer/RefreshButton.disabled = locked
	$HSplitContainer/PluginListContainer/CreatePlugin/CreatePluginButton.disabled = locked
	$HSplitContainer/PluginListContainer/ReloadAllButton.disabled = locked
	$HSplitContainer/PluginListContainer/UnloadAllButton.disabled = locked
	$HSplitContainer/PluginListContainer/CreatePlugin/CreatePluginButton.disabled = locked


func _on_plugin_list_item_selected(index):
	if plugin_list_dic.is_empty():
		current_selected = -1
		return
	current_selected = index
	var plug:Dictionary = plugin_list_dic[index]
	var file = plug["file"]
	if plug.has("info"):
		var info = plug["info"]
		$HSplitContainer/PluginInfoPanel/PluginName.text = info["name"]
		$HSplitContainer/PluginInfoPanel/PluginID.text = "插件ID: "+info["id"]
		$HSplitContainer/PluginInfoPanel/PluginAuthor.text = "作者: "+info["author"]
		$HSplitContainer/PluginInfoPanel/PluginVersion.text = "版本号: "+info["version"]
		if info["dependency"] != []:
			$HSplitContainer/PluginInfoPanel/PluginDependency.text = "依赖的插件: "+str(info["dependency"])
		else:
			$HSplitContainer/PluginInfoPanel/PluginDependency.text = "依赖的插件: 无"
		$HSplitContainer/PluginInfoPanel/PluginDescription.text = "描述: "+info["description"]
	else:
		$HSplitContainer/PluginInfoPanel/PluginName.text = file + " (读取错误)"
		$HSplitContainer/PluginInfoPanel/PluginID.text = "插件ID: 未知"
		$HSplitContainer/PluginInfoPanel/PluginAuthor.text = "作者: 未知"
		$HSplitContainer/PluginInfoPanel/PluginVersion.text = "版本号: 未知"
		$HSplitContainer/PluginInfoPanel/PluginDependency.text = "依赖的插件: 未知"
		$HSplitContainer/PluginInfoPanel/PluginDescription.text = "描述: 未知"
	if plug.has("loaded") and plug["loaded"]:
		$HSplitContainer/PluginInfoPanel/HBoxContainer/UnloadButton.show()
	else:
		$HSplitContainer/PluginInfoPanel/HBoxContainer/UnloadButton.hide()
	$HSplitContainer/PluginInfoPanel/PluginManagerPreview.load_script(file)
	$HSplitContainer/NoSelectLabel.hide()
	$HSplitContainer/PluginInfoPanel.show()


func _on_edit_button_button_down():
	var file = plugin_list_dic[current_selected].file
	GuiManager.open_plugin_editor(PluginManager.plugin_path+file)


func _on_reload_button_button_down():
	var loaded = plugin_list_dic[current_selected].loaded
	if loaded:
		var id = plugin_list_dic[current_selected].info.id
		var plugin = PluginManager.get_node_or_null(id)
		if is_instance_valid(plugin):
			set_lock_panel(true)
			await PluginManager.reload_plugin(plugin)
			update_plugin_list()
			set_lock_panel(false)
		else:
			Console.print_error("插件ID不存在!")
	else:
		var file = plugin_list_dic[current_selected].file
		set_lock_panel(true)
		await PluginManager.load_plugin(file)
		set_lock_panel(false)


func _on_unload_button_button_down():
	var loaded = plugin_list_dic[current_selected].loaded
	if loaded:
		var id = plugin_list_dic[current_selected].info.id
		var plugin = PluginManager.get_node_or_null(id)
		if is_instance_valid(plugin):
			set_lock_panel(true)
			await PluginManager.unload_plugin(plugin)
			update_plugin_list()
			set_lock_panel(false)
		else:
			Console.print_error("插件ID不存在!")


func _on_delete_button_button_down():
	var file = plugin_list_dic[current_selected].file
	set_lock_panel(true)
	await PluginManager.delete_plugin(file)
	update_plugin_list()
	set_lock_panel(false)


func _on_refresh_button_button_down():
	set_lock_panel(true)
	update_plugin_list()
	set_lock_panel(false)


func _on_folder_button_button_down():
	OS.shell_open(PluginManager.plugin_path)


func _on_reload_all_button_button_down():
	set_lock_panel(true)
	await PluginManager.reload_plugins()
	set_lock_panel(false)


func _on_unload_all_button_button_down():
	set_lock_panel(true)
	await PluginManager.unload_plugins()
	set_lock_panel(false)


func _on_create_plugin_file_text_changed(new_text):
	if new_text != "":
		$HSplitContainer/PluginListContainer/CreatePlugin/CreatePluginButton.disabled = false
	else:
		$HSplitContainer/PluginListContainer/CreatePlugin/CreatePluginButton.disabled = true


func _on_create_plugin_button_button_down():
	var text = $HSplitContainer/PluginListContainer/CreatePlugin/CreatePluginFile.text
	if text != "":
		set_lock_panel(true)
		if await PluginManager.create_plugin(text) == OK:
			$HSplitContainer/PluginListContainer/CreatePlugin/CreatePluginFile.text = ""
			update_plugin_list()
		set_lock_panel(false)
