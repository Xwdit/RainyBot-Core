extends Window


func _ready():
	hide()


func _on_EditorWindow_close_requested():
	if get_plugin_editor().save_script() != OK:
		GuiManager.console_print_error("插件文件保存时出现错误，请检查文件权限是否正确")
	else:
		GuiManager.console_print_success("插件保存成功！")
		GuiManager.console_print_success("请不要忘记重载插件以使更改生效!")
	hide()


func get_plugin_editor()->PluginEditor:
	return get_node("PluginEditor")


func load_script(path:String):
	if get_plugin_editor().load_script(path) != OK:
		GuiManager.console_print_error("插件文件加载时出现错误，请检查文件权限是否正确")
		return
	show()
