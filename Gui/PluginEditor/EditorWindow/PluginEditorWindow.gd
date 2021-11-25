extends Window


func _ready():
	hide()


func _on_EditorWindow_close_requested():
	exit()


func get_plugin_editor()->PluginEditor:
	return get_node("PluginEditor")


func load_script(path:String):
	if visible:
		GuiManager.console_print_error("当前已存在编辑中的插件文件，请关闭编辑器后重试!")
		return
	if get_plugin_editor().load_script(path) != OK:
		return
	popup_centered(Vector2i(1280,720))
	await get_tree().process_frame
	get_plugin_editor().get_code_edit().set_caret_line(0)
	get_plugin_editor().get_code_edit().set_caret_column(0)
	get_plugin_editor().get_code_edit().scroll_vertical = 0
	get_plugin_editor().get_code_edit().scroll_horizontal = 0
	

func exit():
	if get_plugin_editor().unsaved:
		$ExitConfirmation.popup_centered()
	else:
		hide()
		GuiManager.console_print_success("插件编辑器已被成功关闭!")


func _on_ExitConfirmation_confirmed():
	hide()
	GuiManager.console_print_success("插件编辑器已被成功关闭!")
