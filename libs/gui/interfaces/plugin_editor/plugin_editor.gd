extends Control


class_name PluginEditor


signal file_changed(file_name:String,is_unsaved:bool)


@onready var func_list_node:ItemList = $HSplitContainer/VSplitContainer/FuncList/ItemList
@onready var file_list_node:ItemList = $HSplitContainer/VSplitContainer/FileList/ItemList
@onready var code_edit_node:CodeEdit = $HSplitContainer/VBoxContainer/CodeEdit


var loaded_path:String = ""
var loaded_name:String = ""
var loaded_ins:Plugin = null
var loaded_has_file:bool = false
var unsaved_dic:Dictionary = {}
var file_caret_dic:Dictionary = {}


func _ready():
	PluginManager.connect("plugin_list_changed",update_file_list)
	code_edit_node.plugin_editor = self
	update_file_list()


func load_script(path:String)->int:
	var is_valid:bool = false
	if unsaved_dic.has(path):
		code_edit_node.text = unsaved_dic[path]
		is_valid=true
	else:
		var scr:GDScript = PluginManager.load_plugin_script(path)
		if is_instance_valid(scr):
			code_edit_node.text = scr.source_code
			is_valid = true
	if is_valid:
		code_edit_node.clear_undo_history()
		loaded_path = path
		loaded_name = path.get_file()
		loaded_ins = PluginManager.get_plugin_with_filename(loaded_name)
		loaded_has_file = true
		if unsaved_dic.has(path):
			set_unsaved(true)
		else:
			code_edit_node.tag_saved_version()
			set_unsaved(false)
		if file_caret_dic.has(path):
			code_edit_node.set_caret_line(file_caret_dic[path].y)
			code_edit_node.set_caret_column(file_caret_dic[path].x)
			code_edit_node.center_viewport_to_caret()
		return OK
	else:
		GuiManager.console_print_error("插件文件加载时出现错误，请检查文件权限是否正确")
		return ERR_CANT_OPEN
	

func update_file_list():
	var files:Array[String] = []
	var filter:String = $HSplitContainer/VSplitContainer/FileList/FileSearch.text
	loaded_has_file = false
	for s in PluginManager.file_load_status:
		if PluginManager.file_load_status[s] == false:
			files.append(s)
			if s == loaded_name:
				loaded_has_file = true
	for id in PluginManager.plugin_files_dic:
		files.append(PluginManager.plugin_files_dic[id].file)
		if PluginManager.plugin_files_dic[id].file == loaded_name:
			loaded_has_file = true
	if !loaded_has_file:
		files.append(loaded_name)
		if !is_unsaved():
			set_unsaved(true,false)
	files.sort()
	file_list_node.clear()
	for f in files:
		if !filter.is_empty() and f.findn(filter) == -1:
			continue
		var f_name:String = f
		var f_path:String = GlobalManager.plugin_path + f_name
		var f_status:String = " (未保存)" if unsaved_dic.has(f_path) else ""
		var idx:int = file_list_node.add_item(f_name+f_status)
		file_list_node.set_item_metadata(idx,f_path)
	for i in file_list_node.item_count:
		var _path:String = file_list_node.get_item_metadata(i)
		if _path == loaded_path:
			file_list_node.select(i)
			if unsaved_dic.has(_path):
				$HSplitContainer/VSplitContainer/FileList/EditButton.hide()
			else:
				$HSplitContainer/VSplitContainer/FileList/EditButton.show()
	file_list_node.queue_redraw()


func update_func_list():
	var func_dic:Dictionary = code_edit_node.func_line_dic
	var filter:String = $HSplitContainer/VSplitContainer/FuncList/FuncSearch.text
	var case_order:bool = $HSplitContainer/VSplitContainer/FuncList/HBoxContainer/CaseSortButton.button_pressed
	func_list_node.clear()
	if !func_dic.is_empty():
		for f in func_dic:
			if !filter.is_empty() and f.findn(filter) == -1:
				continue
			var _line:int = func_dic[f]
			var idx:int = func_list_node.add_item(f)
			func_list_node.set_item_metadata(idx,_line)
			func_list_node.set_item_tooltip(idx,"第"+str(_line+1)+"行: "+f)
	if case_order:
		func_list_node.sort_items_by_text()
	func_list_node.queue_redraw()


func save_script(reload:bool=false)->int:
	var scr:GDScript = GDScript.new()
	scr.source_code = code_edit_node.text
	var err_code:int = ResourceSaver.save(scr,loaded_path)
	if !err_code:
		code_edit_node.tag_saved_version()
		set_unsaved(false,loaded_has_file)
		if !loaded_has_file:
			PluginManager.get_plugin_files_dic()
		GuiManager.console_print_success("插件保存成功！")
		if reload:
			var plug:Plugin = PluginManager.get_plugin_with_filename(loaded_name)
			if is_instance_valid(plug):
				var err:int = await PluginManager.reload_plugin(plug)
				if err:
					GuiManager.popup_notification("无法重载此插件，请查看控制台来了解更多信息")
				else:
					GuiManager.popup_notification("插件已保存并重载成功!")
				return err_code
			var err:int = await PluginManager.load_plugin(loaded_name)
			if err:
				GuiManager.popup_notification("无法加载此插件，请查看控制台来了解更多信息")
			else:
				GuiManager.popup_notification("插件已保存并加载成功!")
		else:
			GuiManager.console_print_success("请不要忘记重载插件以使更改生效!")	
	else:
		GuiManager.console_print_error("插件文件保存时出现错误，请检查文件权限是否正确")
		GuiManager.popup_notification("插件文件保存时出现错误，请检查文件权限是否正确!")
	return err_code


func set_unsaved(enabled:bool=true,update_list:bool=true)->void:
	if enabled:
		unsaved_dic[loaded_path]=code_edit_node.text
	else:
		if unsaved_dic.has(loaded_path):
			unsaved_dic.erase(loaded_path)
	if update_list:
		update_file_list()
	file_changed.emit(loaded_name,enabled)
	
	
func is_unsaved()->bool:
	return unsaved_dic.has(loaded_path)


func _on_CodeEdit_text_changed()->void:
	if code_edit_node.get_version() != code_edit_node.get_saved_version():
		set_unsaved()
	else:
		set_unsaved(false)


func _on_CodeEdit_caret_changed()->void:
	$EditorPanel/Edit/EditStatus.text = str(code_edit_node.get_caret_line()+1)+" : "+str(code_edit_node.get_caret_column()+1)
	$HSplitContainer/VBoxContainer/StatusPanel/LineEdit.max_value = code_edit_node.get_line_count()
	$HSplitContainer/VBoxContainer/StatusPanel/LineEdit.value = code_edit_node.get_caret_line()+1
	file_caret_dic[loaded_path] = Vector2i(code_edit_node.get_caret_column(),code_edit_node.get_caret_line())


func _on_SaveButton_button_down()->void:
	save_script(false)


func _on_SaveReloadButton_button_down()->void:
	save_script(true)


func _on_HelpButton_button_down()->void:
	GuiManager.open_doc_viewer("")


func _input(event:InputEvent)->void:
	if event.is_action_pressed("save_reload"):
		save_script(true)
	elif event.is_action_pressed("save"):
		save_script(false)


func _on_CodeEdit_update_finished()->void:
	var _err_dic:Dictionary = code_edit_node.error_lines
	var _l_num:int = code_edit_node.get_caret_line()
	if _err_dic.has(_l_num):
		$HSplitContainer/VBoxContainer/StatusPanel/CodeStatus.text = "错误: "+_err_dic[_l_num]
	elif !_err_dic.is_empty():
		var _ln:Array[int] = []
		for _l in _err_dic:
			_ln.append(_l+1)
		$HSplitContainer/VBoxContainer/StatusPanel/CodeStatus.text = "在以下行检测到错误，请移动到对应行查看详情: "+str(_ln)
	else:
		$HSplitContainer/VBoxContainer/StatusPanel/CodeStatus.text = "当前文件中未发现任何错误"
	update_func_list()


func _on_func_list_item_selected(index:int):
	var line:int = func_list_node.get_item_metadata(index)
	code_edit_node.set_caret_line(line)
	code_edit_node.center_viewport_to_caret()


func _on_file_list_item_selected(index:int):
	var path:String = file_list_node.get_item_metadata(index)
	var text:String = ""
	load_script(path)
	if unsaved_dic.has(path):
		$HSplitContainer/VSplitContainer/FileList/EditButton.hide()
	else:
		$HSplitContainer/VSplitContainer/FileList/EditButton.show()
	

func _on_hide_dock_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		$HSplitContainer/VBoxContainer/StatusPanel/HideDockButton.text = ">"
		$HSplitContainer/VBoxContainer/StatusPanel/HideDockButton.tooltip_text = "显示左侧栏"
		$HSplitContainer/VSplitContainer.hide()
	else:
		$HSplitContainer/VBoxContainer/StatusPanel/HideDockButton.text = "<"
		$HSplitContainer/VBoxContainer/StatusPanel/HideDockButton.tooltip_text = "隐藏左侧栏"
		$HSplitContainer/VSplitContainer.show()


func _on_file_search_text_changed(new_text: String) -> void:
	update_file_list()


func _on_func_search_text_changed(new_text: String) -> void:
	update_func_list()


func _on_edit_button_button_down() -> void:
	if file_list_node.is_anything_selected():
		for i in file_list_node.get_selected_items():
			var path:String = file_list_node.get_item_metadata(i)
			var err:int = await GuiManager.open_plugin_editor(path)
			if err:
				GuiManager.popup_notification("尝试编辑插件文件%s时出现错误，请查看控制台来了解更多信息"% path.get_file())


func _on_case_sort_button_toggled(button_pressed: bool) -> void:
	update_func_list()


func _on_search_input_text_changed(new_text: String) -> void:
	code_edit_node.set_search_text(new_text)
	code_edit_node.queue_redraw()


func _on_line_edit_value_changed(value: float) -> void:
	if code_edit_node.get_caret_line() != value-1:
		code_edit_node.set_caret_line(value-1)
		code_edit_node.center_viewport_to_caret()
