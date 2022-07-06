extends Control


@onready var plugin_list_ins:ItemList = $HSplitContainer/PluginListContainer/PluginList

var plugin_list_dic:Dictionary = {}
var current_selected:int = -1


func update_plugin_list(reload_dic:bool=false)->void:
	var _file_dic:Dictionary = PluginManager.plugin_files_dic
	if reload_dic:
		_file_dic = PluginManager.get_plugin_files_dic()
	var _file_state_dic:Dictionary = PluginManager.file_load_status
	plugin_list_ins.clear()
	plugin_list_dic.clear()
	for _id in _file_dic:
		var loaded:bool = PluginManager.get_node_or_null(_id.to_lower())!=null
		var _file:String = _file_dic[_id].file
		if loaded:
			_file += " (已加载)"
		else:
			_file += " (未加载)"
		var idx:int = plugin_list_ins.add_item(_file)
		plugin_list_dic[idx]=_file_dic[_id]
		plugin_list_dic[idx]["loaded"]=loaded
	for _file in _file_state_dic:
		if !_file_state_dic[_file]:
			var idx:int = plugin_list_ins.add_item(_file+" (读取错误或信息缺失)")
			plugin_list_dic[idx]={"file":_file,"loaded":false}
	if plugin_list_dic.is_empty():
		plugin_list_ins.add_item("插件目录下未找到任何插件文件...")
	$HSplitContainer/PluginInfoPanel.hide()
	$HSplitContainer/NoSelectLabel.show()


func set_lock_panel(locked:bool)->void:
	$HSplitContainer/PluginListContainer/RefreshButton.disabled = locked
	$HSplitContainer/PluginListContainer/CreatePlugin/CreatePluginButton.disabled = locked
	$HSplitContainer/PluginListContainer/ReloadAllButton.disabled = locked
	$HSplitContainer/PluginListContainer/UnloadAllButton.disabled = locked
	$HSplitContainer/PluginListContainer/CreatePlugin/CreatePluginButton.disabled = locked
	if locked:
		$HSplitContainer/PluginInfoPanel.hide()
		$HSplitContainer/NoSelectLabel.show()


func _on_plugin_list_item_selected(index:int)->void:
	if plugin_list_dic.is_empty():
		current_selected = -1
		return
	current_selected = index
	var plug:Dictionary = plugin_list_dic[index]
	var file:String = plug["file"]
	if plug.has("info"):
		var info:Dictionary = plug["info"]
		if plug.has("loaded") and plug["loaded"]:
			$HSplitContainer/PluginInfoPanel/PluginName.text = info["name"] + " (已加载)"
		else:
			$HSplitContainer/PluginInfoPanel/PluginName.text = info["name"] + " (未加载)"
		$HSplitContainer/PluginInfoPanel/PluginID.text = "插件ID: "+info["id"]
		$HSplitContainer/PluginInfoPanel/PluginAuthor.text = "作者: "+info["author"]
		$HSplitContainer/PluginInfoPanel/PluginVersion.text = "版本号: "+info["version"]
		if info["dependency"] != []:
			$HSplitContainer/PluginInfoPanel/PluginDependency.text = "依赖的插件: "+str(info["dependency"])
		else:
			$HSplitContainer/PluginInfoPanel/PluginDependency.text = "依赖的插件: 无"
		$HSplitContainer/PluginInfoPanel/PluginDescription.text = "描述: "+info["description"]
	else:
		$HSplitContainer/PluginInfoPanel/PluginName.text = file + " (读取错误或信息缺失)"
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


func _on_edit_button_button_down()->void:
	var file:String = plugin_list_dic[current_selected].file
	var err:int = await GuiManager.open_plugin_editor(PluginManager.plugin_path+file)
	if err != OK:
		GuiManager.popup_notification("尝试编辑插件文件%s时出现错误，请查看控制台来了解更多信息"% file)


func _on_reload_button_button_down()->void:
	var loaded:bool = plugin_list_dic[current_selected].loaded
	if loaded:
		var id:String = plugin_list_dic[current_selected].info.id
		var plugin:Plugin = PluginManager.get_node_or_null(id)
		if is_instance_valid(plugin):
			set_lock_panel(true)
			var err:int = await PluginManager.reload_plugin(plugin)
			if err == OK:
				GuiManager.popup_notification("成功重载插件%s!"% id)
			else:
				GuiManager.popup_notification("无法重载插件%s，请查看控制台来了解更多信息"% id)
			update_plugin_list()
			set_lock_panel(false)
		else:
			Console.print_error("插件ID不存在!")
			GuiManager.popup_notification("无法重载插件%s，请查看控制台来了解更多信息"% id)
	else:
		var file:String = plugin_list_dic[current_selected].file
		set_lock_panel(true)
		var err:int = await PluginManager.load_plugin(file)
		if err == OK:
			GuiManager.popup_notification("成功加载插件文件%s!"% file)
		else:
			GuiManager.popup_notification("无法加载插件文件%s，请查看控制台来了解更多信息"% file)
		update_plugin_list()
		set_lock_panel(false)


func _on_unload_button_button_down()->void:
	var loaded:bool = plugin_list_dic[current_selected].loaded
	if loaded:
		var id:String = plugin_list_dic[current_selected].info.id
		var plugin:Plugin = PluginManager.get_node_or_null(id)
		if is_instance_valid(plugin):
			set_lock_panel(true)
			var err:int = await PluginManager.unload_plugin(plugin)
			if err == OK:
				GuiManager.popup_notification("成功卸载插件%s!"% id)
			else:
				GuiManager.popup_notification("无法卸载插件%s，请查看控制台来了解更多信息"% id)
			update_plugin_list()
			set_lock_panel(false)
		else:
			Console.print_error("插件ID不存在!")
			GuiManager.popup_notification("无法卸载插件%s，请查看控制台来了解更多信息"% id)


func _on_delete_button_button_down()->void:
	var file:String = plugin_list_dic[current_selected].file
	var confirmed:bool = await GuiManager.popup_confirm("确定要删除插件文件%s吗?"% file)
	if confirmed:
		set_lock_panel(true)
		var err:int = await PluginManager.delete_plugin(file)
		if err == OK:
			GuiManager.popup_notification("成功删除插件文件%s!"% file)
		else:
			GuiManager.popup_notification("无法删除插件文件%s，请查看控制台来了解更多信息"% file)
		update_plugin_list(true)
		set_lock_panel(false)


func _on_refresh_button_button_down()->void:
	set_lock_panel(true)
	update_plugin_list(true)
	set_lock_panel(false)
	GuiManager.popup_notification("插件列表刷新完毕!")


func _on_folder_button_button_down()->void:
	if OS.get_name() != "macOS":
		OS.shell_open(PluginManager.plugin_path)
	else:
		OS.execute("open",[PluginManager.plugin_path])


func _on_reload_all_button_button_down()->void:
	set_lock_panel(true)
	if await PluginManager.reload_plugins() == 0:
		GuiManager.popup_notification("已成功重载所有插件!")
	else:
		GuiManager.popup_notification("尝试重载所有插件时出现问题，请查看控制台来了解更多信息!")
	update_plugin_list()
	set_lock_panel(false)


func _on_unload_all_button_button_down()->void:
	set_lock_panel(true)
	if await PluginManager.unload_plugins() == 0:
		GuiManager.popup_notification("已成功卸载所有插件!")
	else:
		GuiManager.popup_notification("尝试卸载所有插件时出现问题，请查看控制台来了解更多信息!")
	update_plugin_list()
	set_lock_panel(false)


func _on_create_plugin_file_text_changed(new_text:String)->void:
	if new_text != "":
		$HSplitContainer/PluginListContainer/CreatePlugin/CreatePluginButton.disabled = false
	else:
		$HSplitContainer/PluginListContainer/CreatePlugin/CreatePluginButton.disabled = true


func _on_create_plugin_button_button_down()->void:
	var text:String = $HSplitContainer/PluginListContainer/CreatePlugin/CreatePluginFile.text
	if text != "":
		set_lock_panel(true)
		if !text.ends_with(".gd"):
			text += ".gd"
		if await PluginManager.create_plugin(text) == OK:
			$HSplitContainer/PluginListContainer/CreatePlugin/CreatePluginFile.text = ""
			update_plugin_list(true)
			GuiManager.popup_notification("插件%s创建成功，请填写必要信息以确保插件可被加载"% text)
		else:
			GuiManager.popup_notification("插件%s创建失败，请查看控制台来了解更多信息"% text)
		set_lock_panel(false)
