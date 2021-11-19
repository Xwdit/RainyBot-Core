extends Window


var force_close = false


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
	

func exit():
	if get_plugin_editor().unsaved:
		$ExitConfirmation.popup_centered()
	else:
		hide()


func _on_ExitConfirmation_confirmed():
	hide()
