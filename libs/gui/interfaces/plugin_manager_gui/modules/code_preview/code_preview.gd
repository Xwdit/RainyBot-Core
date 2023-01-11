extends CodeEdit


func _ready()->void:
	set_caret_line(0)
	set_caret_column(0)
	GuiManager.init_delimiters(self,true)
	syntax_highlighter = GuiManager.syntax_highlighter


func load_script(path:String)->int:
	var scr:GDScript = PluginManager.load_plugin_script(PluginManager.plugin_path+path)
	if is_instance_valid(scr):
		text = scr.source_code
		return OK
	else:
		GuiManager.console_print_error("插件文件加载时出现错误，请检查文件权限是否正确")
		return ERR_CANT_OPEN
