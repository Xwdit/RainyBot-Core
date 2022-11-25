extends Control


class_name PluginEditor


@onready var func_list:ItemList = $HSplitContainer/VSplitContainer/FuncList/ItemList
@onready var file_list:ItemList = $HSplitContainer/VSplitContainer/FileList/ItemList


var loaded_path:String = ""
var loaded_name:String = ""
var unsaved_dic:Dictionary = {}


func _ready():
	PluginManager.connect("plugin_list_changed",update_file_list)
	update_file_list()


func load_script(path:String)->int:
	var is_valid:bool = false
	if unsaved_dic.has(path):
		get_code_edit().text = unsaved_dic[path]
		is_valid=true
	else:
		var scr:GDScript = PluginManager.load_plugin_script(path)
		if is_instance_valid(scr):
			get_code_edit().text = scr.source_code
			is_valid = true
	if is_valid:
		get_code_edit().clear_undo_history()
		$EditorPanel/File/FileName.text = path.get_file()
		loaded_path = path
		loaded_name = path.get_file()
		if unsaved_dic.has(path):
			set_unsaved(true)
		else:
			get_code_edit().tag_saved_version()
			set_unsaved(false)
		return OK
	else:
		GuiManager.console_print_error("插件文件加载时出现错误，请检查文件权限是否正确")
		return ERR_CANT_OPEN
	

func update_file_list():
	var f_dic:Dictionary = PluginManager.file_load_status
	file_list.clear()
	for f in f_dic:
		var f_name:String = f
		var f_path:String = GlobalManager.plugin_path + f_name
		var f_status:String = " (未保存)" if unsaved_dic.has(f_path) else ""
		var idx:int = file_list.add_item(f_name+f_status)
		file_list.set_item_metadata(idx,f_path)
	for i in file_list.item_count:
		if file_list.get_item_metadata(i) == loaded_path:
			file_list.select(i)


func get_code_edit()->CodeEdit:
	return $HSplitContainer/CodeEdit


func save_script(reload:bool=false)->int:
	var scr:GDScript = GDScript.new()
	scr.source_code = get_code_edit().text
	var err_code:int = ResourceSaver.save(scr,loaded_path)
	if !err_code:
		get_code_edit().tag_saved_version()
		set_unsaved(false)
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


func set_unsaved(enabled:bool=true)->void:
	if enabled:
		unsaved_dic[loaded_path]=get_code_edit().text
		$EditorPanel/File/FileStatus.text = "(未保存)"
	else:
		if unsaved_dic.has(loaded_path):
			unsaved_dic.erase(loaded_path)
		$EditorPanel/File/FileStatus.text = ""
	update_file_list()


func _on_CodeEdit_text_changed()->void:
	if get_code_edit().get_version() != get_code_edit().get_saved_version():
		set_unsaved()
	else:
		set_unsaved(false)


func _on_CodeEdit_caret_changed()->void:
	$EditorPanel/Edit/EditStatus.text = str(get_code_edit().get_caret_line()+1)+" : "+str(get_code_edit().get_caret_column()+1)


func _on_SaveButton_button_down()->void:
	save_script(false)


func _on_SaveReloadButton_button_down()->void:
	save_script(true)


func _on_HelpButton_button_down()->void:
	OS.shell_open("https://docs.rainybot.dev/api")


func _input(event:InputEvent)->void:
	if event.is_action_pressed("save_reload"):
		save_script(true)
	elif event.is_action_pressed("save"):
		save_script(false)


func _on_CodeEdit_update_finished()->void:
	var _err_dic:Dictionary = get_code_edit().error_lines
	var _l_num:int = get_code_edit().get_caret_line()
	if _err_dic.has(_l_num):
		$StatusPanel/CodeStatus.text = "错误: "+_err_dic[_l_num]
	elif !_err_dic.is_empty():
		var _ln:Array[int] = []
		for _l in _err_dic:
			_ln.append(_l+1)
		$StatusPanel/CodeStatus.text = "在以下行检测到错误，请移动到对应行查看详情: "+str(_ln)
	elif GlobalManager.is_running_from_editor():
		$StatusPanel/CodeStatus.text = "错误检查在通过Godot编辑器运行时不可用"
	else:
		$StatusPanel/CodeStatus.text = "当前文件中未发现任何错误"
		
	var func_dic:Dictionary = get_code_edit().func_line_dic
	func_list.clear()
	if !func_dic.is_empty():
		for f in func_dic:
			var _line:int = func_dic[f]
			var idx:int = func_list.add_item(f)
			func_list.set_item_metadata(idx,_line)
			func_list.set_item_tooltip(idx,"第"+str(_line+1)+"行: "+f)


func _on_func_list_item_selected(index:int):
	var line:int = func_list.get_item_metadata(index)
	get_code_edit().set_caret_line(line)
	get_code_edit().center_viewport_to_caret()


func _on_file_list_item_selected(index:int):
	var path:String = file_list.get_item_metadata(index)
	var text:String = ""
	load_script(path)
	
