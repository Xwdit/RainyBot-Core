extends Control


enum SelectType{
	EVENT,
	KEYWORD,
	COMMAND,
	DATA,
	CACHE,
	CONFIG
}


@onready var plugin_list_ins:ItemList = $HSplitContainer/PluginListContainer/PluginList

var plugin_list_dic:Dictionary = {}
var current_events:Dictionary = {}
var current_keywords:Dictionary = {}
var current_console_commands:Dictionary = {}
var current_datas:Dictionary = {}
var current_caches:Dictionary = {}
var current_configs:Dictionary = {}
var current_selected:int = -1
var current_selected_item:int = -1
var current_selected_item_type:int = -1


func _ready():
	$HSplitContainer/TabContainer.set_tab_title(0,"插件信息")
	$HSplitContainer/TabContainer.set_tab_title(1,"插件注册列表")
	$HSplitContainer/TabContainer.set_tab_title(2,"插件数据列表")


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
	_update_data_panel()
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
	current_events = {}
	current_keywords = {}
	current_console_commands = {}
	$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/EventList/ItemList.clear()
	$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/KeywordList/ItemList.clear()
	$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/CommandList/ItemList.clear()
	if plug.has("info"):
		var info:Dictionary = plug["info"]
		var id:String = info["id"]
		var ins:Plugin = PluginManager.get_node_or_null(id)
		if is_instance_valid(ins):
			$HSplitContainer/TabContainer.set_tab_hidden(1,false)
			current_events = ins.plugin_event_dic
			current_keywords = ins.plugin_keyword_dic
			current_console_commands = ins.plugin_console_command_dic
			_reset_register_info()
			for ev in current_events:
				var ev_name:String = ev.resource_path.get_file().replacen(".gd","")
				var idx:int = $HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/EventList/ItemList.add_item(ev_name)
				$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/EventList/ItemList.set_item_metadata(idx,ev)
			for kw in current_keywords:
				var idx:int = $HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/KeywordList/ItemList.add_item(kw)
				$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/KeywordList/ItemList.set_item_metadata(idx,kw)
			for cmd in current_console_commands:
				var idx:int = $HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/CommandList/ItemList.add_item(cmd)
				$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/CommandList/ItemList.set_item_metadata(idx,cmd)
			$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/EventList/ItemList.sort_items_by_text()
			$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/KeywordList/ItemList.sort_items_by_text()
			$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/CommandList/ItemList.sort_items_by_text()
		else:
			$HSplitContainer/TabContainer.set_tab_hidden(1,true)
	else:
		$HSplitContainer/TabContainer.set_tab_hidden(1,true)


func _reset_register_info()->void:
	if current_events.size() > 0 or current_keywords.size() > 0 or current_console_commands.size() > 0:
		$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text = "请选择任意项目来查看其详情..."
	else:
		$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text = "此插件还未注册任何事件/关键词/命令..."
		
		
func _update_data_panel()->void:
	var plug:Dictionary = plugin_list_dic[current_selected]
	current_datas = {}
	current_caches = {}
	current_configs = {}
	$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/DataList/AllClearButton.hide()
	$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/CacheList/AllClearButton.hide()
	$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/ConfigList/AllClearButton.hide()
	$HSplitContainer/TabContainer/PluginDataPanel/DeleteButton.hide()
	$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/DataList/ItemList.clear()
	$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/CacheList/ItemList.clear()
	$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/ConfigList/ItemList.clear()
	if plug.has("info"):
		var info:Dictionary = plug["info"]
		var id:String = info["id"]
		var ins:Plugin = PluginManager.get_node_or_null(id)
		if is_instance_valid(ins):
			$HSplitContainer/TabContainer.set_tab_hidden(2,false)
			current_datas = ins.plugin_data
			current_caches = ins.plugin_cache
			current_configs = ins.plugin_config
			_reset_data_info()
			if current_datas.size() > 0:
				$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/DataList/AllClearButton.show()
			if current_caches.size() > 0:
				$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/CacheList/AllClearButton.show()
			if current_configs.size() > 0:
				$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/ConfigList/AllClearButton.show()
			for d in current_datas:
				var idx:int = $HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/DataList/ItemList.add_item(str(d))
				$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/DataList/ItemList.set_item_metadata(idx,d)
			for ca in current_caches:
				var idx:int = $HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/CacheList/ItemList.add_item(str(ca))
				$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/CacheList/ItemList.set_item_metadata(idx,ca)
			for co in current_configs:
				var idx:int = $HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/ConfigList/ItemList.add_item(str(co))
				$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/ConfigList/ItemList.set_item_metadata(idx,co)
			$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/DataList/ItemList.sort_items_by_text()
			$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/CacheList/ItemList.sort_items_by_text()
			$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/ConfigList/ItemList.sort_items_by_text()
		else:
			$HSplitContainer/TabContainer.set_tab_hidden(2,true)
	else:
		$HSplitContainer/TabContainer.set_tab_hidden(2,true)


func _reset_data_info()->void:
	if current_datas.size() > 0 or current_caches.size() > 0 or current_configs.size() > 0:
		$HSplitContainer/TabContainer/PluginDataPanel/Infos.text = "请选择任意项目来查看其内容..."
	else:
		$HSplitContainer/TabContainer/PluginDataPanel/Infos.text = "此插件还未拥有任何数据项/缓存项/配置项..."


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


func _on_event_list_item_selected(index:int)->void:
	await get_tree().process_frame
	current_selected_item = index
	current_selected_item_type = SelectType.EVENT
	var key = $HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/EventList/ItemList.get_item_metadata(index)
	var datas:Dictionary = current_events[key]
	var priority:int = datas["priority"]
	var funcs:Array = datas["function"]
	var block_mode:int = datas["block_mode"]
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text = "事件优先级: %s"% priority
	var func_names:Array = []
	for f in funcs:
		func_names.append(str(f.get_method()))
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n绑定的函数: %s" % str(func_names)
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n事件阻断模式: %s" % Plugin.block_mode_dic[block_mode]


func _on_event_list_focus_exited()->void:
	$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/EventList/ItemList.deselect_all()
	_reset_register_info()
	current_selected_item = -1
	current_selected_item_type = -1


func _on_keyword_list_item_selected(index:int)->void:
	await get_tree().process_frame
	current_selected_item = index
	current_selected_item_type = SelectType.KEYWORD
	var key = $HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/KeywordList/ItemList.get_item_metadata(index)
	var datas:Dictionary = current_keywords[key]
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text = "绑定的函数: %s" % str(datas["function"].get_method())
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n动态变量字典: %s" % str(datas["var_dic"])
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n匹配模式: %s" % Plugin.match_mode_dic[datas["match_mode"]]
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n匹配后阻断事件传递: %s" % ("是" if datas["block"] else "否")


func _on_keyword_list_focus_exited()->void:
	$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/KeywordList/ItemList.deselect_all()
	_reset_register_info()
	current_selected_item = -1
	current_selected_item_type = -1


func _on_reg_refresh_button_button_down()->void:
	_update_register_panel()
	GuiManager.popup_notification("插件注册列表刷新完毕!")


func _on_command_list_item_selected(index:int)->void:
	await get_tree().process_frame
	current_selected_item = index
	current_selected_item_type = SelectType.COMMAND
	var key = $HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/CommandList/ItemList.get_item_metadata(index)
	var datas:Dictionary = current_console_commands[key]
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text = "绑定的函数: %s" % str(datas["function"].get_method())
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n需要参数: %s" % ("是" if datas["need_arg"] else "否")
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n需要连接到后端: %s" % ("是" if datas["need_connect"] else "否")
	$HSplitContainer/TabContainer/PluginRegisterPanel/Infos.text += "\n命令用法: %s" % str(datas["usages"])


func _on_command_list_focus_exited()->void:
	$HSplitContainer/TabContainer/PluginRegisterPanel/HBoxContainer/CommandList/ItemList.deselect_all()
	_reset_register_info()
	current_selected_item = -1
	current_selected_item_type = -1


func _on_data_list_item_selected(index:int)->void:
	await get_tree().process_frame
	current_selected_item = index
	current_selected_item_type = SelectType.DATA
	var key = $HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/DataList/ItemList.get_item_metadata(index)
	var content = current_datas[key]
	$HSplitContainer/TabContainer/PluginDataPanel/Infos.text = "此数据项的内容: %s" % str(content)
	$HSplitContainer/TabContainer/PluginDataPanel/DeleteButton.show()


func _on_data_list_focus_exited()->void:
	$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/DataList/ItemList.deselect_all()
	_reset_data_info()
	await get_tree().process_frame
	$HSplitContainer/TabContainer/PluginDataPanel/DeleteButton.hide()
	current_selected_item = -1
	current_selected_item_type = -1


func _on_cache_list_item_selected(index:int)->void:
	await get_tree().process_frame
	current_selected_item = index
	current_selected_item_type = SelectType.CACHE
	var key = $HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/CacheList/ItemList.get_item_metadata(index)
	var content = current_caches[key]
	$HSplitContainer/TabContainer/PluginDataPanel/Infos.text = "此缓存项的内容: %s" % str(content)
	$HSplitContainer/TabContainer/PluginDataPanel/DeleteButton.show()


func _on_cache_list_focus_exited()->void:
	$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/CacheList/ItemList.deselect_all()
	_reset_data_info()
	await get_tree().process_frame
	$HSplitContainer/TabContainer/PluginDataPanel/DeleteButton.hide()
	current_selected_item = -1
	current_selected_item_type = -1


func _on_config_list_item_selected(index:int)->void:
	await get_tree().process_frame
	current_selected_item = index
	current_selected_item_type = SelectType.CONFIG
	var key = $HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/ConfigList/ItemList.get_item_metadata(index)
	var content = current_configs[key]
	$HSplitContainer/TabContainer/PluginDataPanel/Infos.text = "此配置项的内容: %s" % str(content)


func _on_config_list_focus_exited()->void:
	$HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/ConfigList/ItemList.deselect_all()
	_reset_data_info()
	await get_tree().process_frame
	$HSplitContainer/TabContainer/PluginDataPanel/DeleteButton.hide()
	current_selected_item = -1
	current_selected_item_type = -1


func _on_data_refresh_button_button_down()->void:
	_update_data_panel()
	GuiManager.popup_notification("插件数据列表刷新完毕!")


func _on_data_all_clear_button_button_down()->void:
	var confirmed:bool = await GuiManager.popup_confirm("确定要清空所有数据库项目吗?")
	if confirmed:
		var id:String = plugin_list_dic[current_selected].info.id
		var plugin:Plugin = PluginManager.get_node_or_null(id)
		if is_instance_valid(plugin):
			var err:int = plugin.clear_plugin_data()
			if err==OK:
				_update_data_panel()
				GuiManager.popup_notification("插件数据库清空完毕!")
			else:
				GuiManager.popup_notification("无法清空插件数据库，请查看控制台来了解更多信息!")
		else:
			Console.print_error("插件实例无效，因此无法清空插件数据库!")
			GuiManager.popup_notification("无法清空插件数据库，请查看控制台来了解更多信息!")


func _on_cache_all_clear_button_button_down()->void:
	var confirmed:bool = await GuiManager.popup_confirm("确定要清空所有缓存项目吗?")
	if confirmed:
		var id:String = plugin_list_dic[current_selected].info.id
		var plugin:Plugin = PluginManager.get_node_or_null(id)
		if is_instance_valid(plugin):
			var err:int = plugin.clear_plugin_cache()
			if err==OK:
				_update_data_panel()
				GuiManager.popup_notification("插件缓存清空完毕!")
			else:
				GuiManager.popup_notification("无法清空插件缓存，请查看控制台来了解更多信息!")
		else:
			Console.print_error("插件实例无效，因此无法清空插件缓存!")
			GuiManager.popup_notification("无法清空插件缓存，请查看控制台来了解更多信息!")


func _on_config_all_clear_button_button_down()->void:
	var confirmed:bool = await GuiManager.popup_confirm("确定要还原所有配置项目吗?")
	if confirmed:
		var id:String = plugin_list_dic[current_selected].info.id
		var plugin:Plugin = PluginManager.get_node_or_null(id)
		if is_instance_valid(plugin):
			var err:int = plugin.reset_all_plugin_data()
			if err==OK:
				_update_data_panel()
				GuiManager.popup_notification("插件配置还原完毕!")
			else:
				GuiManager.popup_notification("无法还原插件配置，请查看控制台来了解更多信息!")
		else:
			Console.print_error("插件实例无效，因此无法还原插件配置!")
			GuiManager.popup_notification("无法还原插件配置，请查看控制台来了解更多信息!")


func _on_data_open_dir_button_button_down()->void:
	if OS.get_name() != "macOS":
		OS.shell_open(PluginManager.plugin_data_path)
	else:
		OS.execute("open",[PluginManager.plugin_data_path])


func _on_cache_open_dir_button_button_down()->void:
	if OS.get_name() != "macOS":
		OS.shell_open(PluginManager.plugin_cache_path)
	else:
		OS.execute("open",[PluginManager.plugin_cache_path])


func _on_config_open_dir_button_button_down()->void:
	if OS.get_name() != "macOS":
		OS.shell_open(PluginManager.plugin_config_path)
	else:
		OS.execute("open",[PluginManager.plugin_config_path])


func _on_datas_delete_button_button_down()->void:
	match current_selected_item_type:
		SelectType.DATA:
			var id:String = plugin_list_dic[current_selected].info.id
			var plugin:Plugin = PluginManager.get_node_or_null(id)
			if is_instance_valid(plugin):
				var key = $HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/DataList/ItemList.get_item_metadata(current_selected_item)
				var confirmed:bool = await GuiManager.popup_confirm("确定要删除数据库项目%s吗?"% str(key))
				if confirmed:
					var err:int = plugin.remove_plugin_data(key)
					if err==OK:
						_update_data_panel()
						GuiManager.popup_notification("成功删除数据库项目%s!"% str(key))
					else:
						GuiManager.popup_notification("无法删除数据库项目%s，请查看控制台来了解更多信息!"% str(key))
			else:
				Console.print_error("插件实例无效，因此无法删除选定的数据库项目!")
				GuiManager.popup_notification("无法删除选定的数据库项目，请查看控制台来了解更多信息!")
		SelectType.CACHE:
			var id:String = plugin_list_dic[current_selected].info.id
			var plugin:Plugin = PluginManager.get_node_or_null(id)
			if is_instance_valid(plugin):
				var key = $HSplitContainer/TabContainer/PluginDataPanel/HBoxContainer/CacheList/ItemList.get_item_metadata(current_selected_item)
				var confirmed:bool = await GuiManager.popup_confirm("确定要删除缓存项目%s吗?"% str(key))
				if confirmed:
					var err:int = plugin.remove_plugin_cache(key)
					if err==OK:
						_update_data_panel()
						GuiManager.popup_notification("成功删除缓存项目%s!"% str(key))
					else:
						GuiManager.popup_notification("无法删除缓存项目%s，请查看控制台来了解更多信息!"% str(key))
			else:
				Console.print_error("插件实例无效，因此无法删除选定的缓存项目!")
				GuiManager.popup_notification("无法删除选定的缓存项目，请查看控制台来了解更多信息!")
