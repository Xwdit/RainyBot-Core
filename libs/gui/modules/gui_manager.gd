extends Node


var _confirm_popup:PackedScene = load("res://libs/gui/modules/popups/confirm_popup/confirm_popup.tscn")
var _accept_popup:PackedScene = load("res://libs/gui/modules/popups/accept_popup/accept_popup.tscn")
var _editor:PackedScene = load("res://libs/gui/interfaces/plugin_editor/modules/editor_window/plugin_editor_window.tscn")

var scene_editor_pid:int = -1

var sysout_disabled:bool = false

	
func open_plugin_editor(path:String)->int:
	if !File.new().file_exists(path) or !path.get_file().ends_with(".gd"):
		console_print_error("插件文件不存在或文件格式错误!")
		return ERR_CANT_OPEN
	for child in get_children():
		if str(child.name).begins_with("PluginEditorWindow"):
			var l_name:String = child.get_plugin_editor().loaded_name
			if path.get_file().to_lower() == l_name.to_lower():
				console_print_error("此文件当前正在编辑中，请勿重复打开相同的文件! | 文件:"+path.get_file())
				return ERR_ALREADY_IN_USE
	console_print_warning("正在启动插件编辑器，请稍候..... | 文件:"+path.get_file())
	await get_tree().physics_frame
	var _ins:Window = _editor.instantiate()
	_ins.name = "PluginEditorWindow"
	add_child(_ins,true)
	_ins.load_script(path)
	return OK
	
	
func open_scene_editor()->void:
	if scene_editor_pid != -1 and OS.is_process_running(scene_editor_pid):
		console_print_error("场景编辑器当前正在运行中，请不要同时启动多个场景编辑器进程!")
	else:
		console_print_warning("正在启动场景编辑器，请稍候..... | 版本: Godot-%s"% Engine.get_version_info().string)
		scene_editor_pid = OS.create_instance(["--editor"])
	

func console_print_text(text,sysout:bool=true)->void:
	if sysout_disabled and sysout:
		return
	get_tree().call_group("Console","add_newline_with_time",text)
	
	
func console_print_error(text,sysout:bool=true)->void:
	if sysout_disabled and sysout:
		return
	get_tree().call_group("Console","add_error",text)
	
	
func console_print_warning(text,sysout:bool=true)->void:
	if sysout_disabled and sysout:
		return
	get_tree().call_group("Console","add_warning",text)
	

func console_print_success(text,sysout:bool=true)->void:
	if sysout_disabled and sysout:
		return
	get_tree().call_group("Console","add_success",text)
	
	
func console_save_log(close:bool=false)->void:
	get_tree().call_group("Console","save_log",close)


func popup_notification(text:String,title:String="提示")->bool:
	var _popup:AcceptDialog = _accept_popup.instantiate()
	add_child(_popup)
	_popup.title = title
	_popup.dialog_text = text
	_popup.get_label().horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_popup.get_label().vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_popup.popup_centered()
	return await _popup.closed
	
	
func popup_confirm(text:String,title:String="请确认")->bool:
	var _popup:ConfirmationDialog = _confirm_popup.instantiate()
	add_child(_popup)
	_popup.title = title
	_popup.dialog_text = text
	_popup.get_label().horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_popup.get_label().vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_popup.popup_centered()
	return await _popup.closed
