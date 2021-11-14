extends Node


func open_gui_module(m_name):
	get_tree().call_group("GuiModule","open_module",m_name)


func console_print_text(text):
	get_tree().call_group("Console","add_newline_with_time",text)
	
	
func console_print_error(text):
	get_tree().call_group("Console","add_error",text)
	
	
func console_print_warning(text):
	get_tree().call_group("Console","add_warning",text)
	

func console_print_success(text):
	get_tree().call_group("Console","add_success",text)
