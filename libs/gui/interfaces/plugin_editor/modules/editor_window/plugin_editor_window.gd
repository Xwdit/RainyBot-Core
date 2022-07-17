extends Window


func _on_EditorWindow_close_requested()->void:
	exit()


func get_plugin_editor()->PluginEditor:
	return get_node("PluginEditor")


func load_script(path:String)->int:
	if visible:
		GuiManager.console_print_error("当前已存在编辑中的插件文件，请关闭编辑器后重试!")
		return ERR_ALREADY_IN_USE
	var err:int = get_plugin_editor().load_script(path)
	if err:
		return err
	popup_centered(Vector2i(1280,720))
	await get_tree().process_frame
	get_plugin_editor().get_code_edit().set_caret_line(0)
	get_plugin_editor().get_code_edit().set_caret_column(0)
	get_plugin_editor().get_code_edit().scroll_vertical = 0
	get_plugin_editor().get_code_edit().scroll_horizontal = 0
	return OK
	

func exit()->void:
	if get_plugin_editor().unsaved:
		$ExitConfirmWindow.popup_centered(Vector2(430,130))
	else:
		GuiManager.console_print_success("插件编辑器已被成功关闭! | 文件:"+get_plugin_editor().loaded_name)
		queue_free()


func _on_ExitConfirmWindow_confirm_pressed()->void:
	GuiManager.console_print_success("插件编辑器已被成功关闭! | 文件:"+get_plugin_editor().loaded_name)
	queue_free()
