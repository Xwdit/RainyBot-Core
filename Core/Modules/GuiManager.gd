extends Node
	
	
func open_plugin_editor(path:String):
	if !File.new().file_exists(path) or !path.get_file().ends_with(".gd"):
		GuiManager.console_print_error("插件文件不存在或文件格式错误!")
		return
	for c in get_children():
		if str(c.name).begins_with("PluginEditorWindow"):
			if c.get_plugin_editor().loaded_path.to_lower() == path.to_lower():
				GuiManager.console_print_error("此文件已在某个编辑器实例中被打开，请不要同时编辑同一个插件文件!")
				return
	GuiManager.console_print_warning("正在启动插件编辑器，请稍候..... | 文件:"+path.get_file())
	await get_tree().physics_frame
	var _editor = load("res://Gui/Modules/PluginEditor/Modules/EditorWindow/PluginEditorWindow.tscn")
	var _ins = _editor.instantiate()
	_ins.name = "PluginEditorWindow"
	add_child(_ins,true)
	_ins.load_script(path)


func console_print_text(text):
	get_tree().call_group("Console","add_newline_with_time",text)
	
	
func console_print_error(text):
	get_tree().call_group("Console","add_error",text)
	
	
func console_print_warning(text):
	get_tree().call_group("Console","add_warning",text)
	

func console_print_success(text):
	get_tree().call_group("Console","add_success",text)
	
	
func console_save_log(close:bool = false):
	get_tree().call_group("Console","save_log",close)
