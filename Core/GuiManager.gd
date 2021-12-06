extends Node


var plugin_editor = load("res://Gui/PluginEditor/EditorWindow/PluginEditorWindow.tscn").instantiate()


func _ready():
	plugin_editor.name = "PluginEditorWindow"
	add_child(plugin_editor,true)
	
	
func open_plugin_editor(path:String):
	plugin_editor.load_script(path)


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
