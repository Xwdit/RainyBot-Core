extends Window


var force_close = false


func _ready():
	hide()


func _on_EditorWindow_close_requested():
	if get_plugin_editor().save_script() != OK:
		if !force_close:
			GuiManager.console_print_error("插件文件保存时出现错误，因此中断了编辑器窗口的关闭")
			GuiManager.console_print_error("若要强制关闭编辑器窗口，请再次点击关闭按钮即可")
			force_close = true
			return
	force_close = false
	hide()


func get_plugin_editor()->PluginEditor:
	return get_node("PluginEditor")


func load_script(path:String):
	if get_plugin_editor().load_script(path) != OK:
		return
	show()
