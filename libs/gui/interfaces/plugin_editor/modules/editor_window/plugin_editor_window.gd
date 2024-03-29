extends Window


@onready var plugin_editor_node:PluginEditor = $PluginEditor


func _on_EditorWindow_close_requested()->void:
	exit()
	

func load_script(path:String)->int:
	if visible:
		GuiManager.console_print_error("当前已存在编辑中的插件文件，请关闭编辑器后重试!")
		return ERR_ALREADY_IN_USE
	var err:int = plugin_editor_node.load_script(path)
	if err:
		return err
	var width:int = ProjectSettings.get_setting("display/window/size/viewport_width")
	var height:int = ProjectSettings.get_setting("display/window/size/viewport_height")
	popup_centered(Vector2i(width,height))
	await get_tree().process_frame
	plugin_editor_node.code_edit_node.set_caret_line(0)
	plugin_editor_node.code_edit_node.set_caret_column(0)
	plugin_editor_node.code_edit_node.scroll_vertical = 0
	plugin_editor_node.code_edit_node.scroll_horizontal = 0
	return OK
	

func exit()->void:
	if !plugin_editor_node.unsaved_dic.is_empty():
		$ExitConfirmWindow.popup_centered(Vector2(430,130))
	else:
		GuiManager.console_print_success("插件编辑器已被成功关闭! | 文件:"+plugin_editor_node.loaded_name)
		queue_free()


func _on_ExitConfirmWindow_confirm_pressed()->void:
	GuiManager.console_print_success("插件编辑器已被成功关闭! | 文件:"+plugin_editor_node.loaded_name)
	queue_free()


func _on_plugin_editor_file_changed(file_name:String,is_unsaved:bool) -> void:
	var _status:String = " (未保存)" if is_unsaved else ""
	title = "RainyBot插件编辑器 - "+file_name+_status
