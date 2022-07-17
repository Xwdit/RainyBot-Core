extends Control


class_name PluginEditor


var loaded_path:String = ""
var loaded_name:String = ""
var unsaved:bool = false


func load_script(path:String)->int:
	var scr:GDScript = PluginManager.load_plugin_script(path)
	if is_instance_valid(scr):
		get_code_edit().text = scr.source_code
		get_code_edit().clear_undo_history()
		$EditorPanel/File/FileName.text = path.get_file()
		loaded_path = path
		loaded_name = path.get_file()
		return OK
	else:
		GuiManager.console_print_error("插件文件加载时出现错误，请检查文件权限是否正确")
		return ERR_CANT_OPEN
	

func get_code_edit()->CodeEdit:
	return get_node("CodeEdit")


func save_script(reload:bool=false)->int:
	var scr:GDScript = GDScript.new()
	scr.source_code = get_code_edit().text
	var err_code:int = ResourceSaver.save(loaded_path,scr)
	if err_code == OK:
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
	unsaved = enabled
	if unsaved:
		$EditorPanel/File/FileStatus.text = "(未保存)"
	else:
		$EditorPanel/File/FileStatus.text = ""


func _on_CodeEdit_text_changed()->void:
	set_unsaved()


func _on_CodeEdit_caret_changed()->void:
	$EditorPanel/Edit/EditStatus.text = str(get_code_edit().get_caret_line()+1)+" : "+str(get_code_edit().get_caret_column()+1)


func _on_SaveButton_button_down()->void:
	save_script(false)


func _on_SaveReloadButton_button_down()->void:
	save_script(true)


func _on_HelpButton_button_down()->void:
	OS.shell_open("https://docs.rainybot.dev")


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
