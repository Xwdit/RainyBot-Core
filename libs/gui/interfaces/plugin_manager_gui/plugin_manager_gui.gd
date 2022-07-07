extends Control


@onready var plugin_list_ins:ItemList = $HSplitContainer/PluginListContainer/PluginList

var plugin_list_dic:Dictionary = {}
var current_events:Array = []
var current_keywords:Array = []
var current_console_commands:Array = []
var current_selected:int = -1


func _ready():
	$HSplitContainer/TabContainer.set_tab_title(0,"插件信息")
	$HSplitContainer/TabContainer.set_tab_title(1,"插件注册列表")


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
	set_panel_visible(false)


func set_lock_panel(locked:bool)->void:
	$HSplitContainer/PluginListContainer/RefreshButton.disabled = locked
	$HSplitContainer/PluginListContainer/CreatePlugin/CreatePluginButton.disabled = locked
	$HSplitContainer/PluginListContainer/ReloadAllButton.disabled = locked
	$HSplitContainer/PluginListContainer/UnloadAllButton.disabled = locked
	$HSplitContainer/PluginListContainer/CreatePlugin/CreatePluginButton.disabled = locked
	if locked:
		set_panel_visible(false)


func set_panel_visible(p_visible:bool)->void:
	$HSplitContainer/NoSelectLabel.visible = !p_visible
	$HSplitContainer/TabContainer.visible = p_visible


func _on_plugin_list_item_selected(index:int)->void:
	if plugin_list_dic.is_empty():
		current_selected = -1
		return
	current_selected = index
	_update_info_panel()
	_update_register_panel()
	set_panel_visible(true)


func _update_info_panel()->void:
	var plug:Dictionary = plugin_list_dic[current_selected]
	var file:String = plug["file"]
	if plug.has("info"):
		var info:Dictionary = plug["info"]
		if plug.has("loaded") and plug["loaded"]:
			$HSplitContainer/TabContainer/PluginInfoPanel/PluginName.text = info["name"] + " (已加载)"
		else:
			$HSplitContainer/TabContainer/PluginInfoPanel/PluginName.text = info["name"] + " (未加载)"
		$HSplitContainer/TabContainer/PluginInfoPanel/PluginID.text = "插件ID: "+info["id"]
		$HSplitContainer/TabContainer/PluginInfoPanel/PluginAuthor.text = "作者: "+info["author"]
		$HSplitContainer/TabContainer/PluginInfoPanel/PluginVersion.text = "版本号: "+info["version"]
		if info["dependency"] != []:
			$HSplitContainer/TabContainer/PluginInfoPanel/PluginDependency.text = "依赖的插件: "+str(info["dependency"])
		else:
			$HSplitContainer/TabContainer/PluginInfoPanel/PluginDependency.text = "依赖的插件: 无"
		$HSplitContainer/TabContainer/PluginInfoPanel/PluginDescription.text = "描述: "+info["description"]
	else:
		
		$HSplitContainer/TabContainer/PluginInfoPanel/PluginName.text = file + " (读取错误或信息缺失)"
		$HSplitContainer/TabContainer/PluginInfoPanel/PluginID.text = "插件ID: 未知"
		$HSplitContainer/TabContainer/PluginInfoPanel/PluginAuthor.text = "作者: 未知"
		$HSplitContainer/TabContainer/PluginInfoPanel/PluginVersion.text = "版本号: 未知"
		$HSplitContainer/TabContainer/PluginInfoPanel/PluginDependency.text = "依赖的插件: 未知"
		$HSplitContainer/TabContainer/PluginInfoPanel/PluginDescription.text = "描述: 未知"
	if plug.has("loaded") and plug["loaded"]:
		$HSplitContainer/TabContainer/PluginInfoPanel/HBoxContainer/UnloadButton.show()
	else:
		$HSplitContainer/TabContainer/PluginInfoPanel/HBoxContainer/UnloadButton.hide()
	$HSplitContainer/TabContainer/PluginInfoPanel/PluginManagerPreview.load_script(file)


func _update_register_panel()->void:
	var plug:Dictionary = plugin_list_dic[current_selected]
	current_events.clear()
	current_keywords.clear()
	current_console_commands.clear()
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text = "请选择任意项目来查看其详情..."
	$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/EventList/ItemList.clear()
	$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/KeywordList/ItemList.clear()
	$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/CommandList/ItemList.clear()
	if plug.has("info"):
		var info:Dictionary = plug["info"]
		var id:String = info["id"]
		var ins:Plugin = PluginManager.get_node_or_null(id)
		if is_instance_valid(ins):
			$HSplitContainer/TabContainer.set_tab_hidden(1,false)
			var events:Dictionary = ins.plugin_event_dic
			var keywords:Dictionary = ins.plugin_keyword_dic
			var commands:Dictionary = ins.plugin_console_command_dic
			for ev in events:
				var ev_name:String = ev.resource_path.get_file().replacen(".gd","")
				$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/EventList/ItemList.add_item(ev_name)
				current_events.append(events[ev])
			for kw in keywords:
				$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/KeywordList/ItemList.add_item(kw)
				current_keywords.append(keywords[kw])
			for cmd in commands:
				$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/CommandList/ItemList.add_item(cmd)
				current_console_commands.append(commands[cmd])
		else:
			$HSplitContainer/TabContainer.set_tab_hidden(1,true)
	else:
		$HSplitContainer/TabContainer.set_tab_hidden(1,true)


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


func _on_event_list_item_selected(index):
	await get_tree().process_frame
	var datas:Dictionary = current_events[index]
	var priority:int = datas["priority"]
	var funcs:Array = datas["function"]
	var block_mode:int = datas["block_mode"]
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text = "事件优先级: %s"% priority
	var func_names:Array = []
	for f in funcs:
		func_names.append(str(f.get_method()))
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n绑定的函数: %s" % str(func_names)
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n事件阻断模式: %s" % Plugin.block_mode_dic[block_mode]


func _on_event_list_focus_exited():
	$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/EventList/ItemList.deselect_all()
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text = "请选择任意项目来查看其详情..."


func _on_keyword_list_item_selected(index):
	await get_tree().process_frame
	var datas:Dictionary = current_keywords[index]
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text = "绑定的函数: %s" % str(datas["function"].get_method())
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n动态变量字典: %s" % str(datas["var_dic"])
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n匹配模式: %s" % Plugin.match_mode_dic[datas["match_mode"]]
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n匹配后阻断事件传递: %s" % ("是" if datas["block"] else "否")


func _on_keyword_list_focus_exited():
	$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/KeywordList/ItemList.deselect_all()
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text = "请选择任意项目来查看其详情..."


func _on_reg_refresh_button_button_down():
	_update_register_panel()
	GuiManager.popup_notification("插件注册列表刷新完毕!")


func _on_command_list_item_selected(index):
	await get_tree().process_frame
	var datas:Dictionary = current_console_commands[index]
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text = "绑定的函数: %s" % str(datas["function"].get_method())
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n需要参数: %s" % ("是" if datas["need_arg"] else "否")
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n需要连接到后端: %s" % ("是" if datas["need_connect"] else "否")
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n命令用法: %s" % str(datas["usages"])


func _on_command_list_focus_exited():
	$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/CommandList/ItemList.deselect_all()
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text = "请选择任意项目来查看其详情..."
