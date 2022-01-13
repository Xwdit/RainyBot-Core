extends Node


var _editor = load("res://Gui/Interfaces/PluginEditor/Modules/EditorWindow/PluginEditorWindow.tscn")

	
func open_plugin_editor(path:String):
	if !File.new().file_exists(path) or !path.get_file().ends_with(".gd"):
		console_print_error("插件文件不存在或文件格式错误!")
		return
	for child in get_children():
		if str(child.name).begins_with("PluginEditorWindow"):
			var l_name = child.get_plugin_editor().loaded_name
			if path.get_file().to_lower() == l_name.to_lower():
				console_print_error("此文件当前正在编辑中，请勿重复打开相同的文件! | 文件:"+path.get_file())
				return
	console_print_warning("正在启动插件编辑器，请稍候..... | 文件:"+path.get_file())
	await get_tree().physics_frame
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
