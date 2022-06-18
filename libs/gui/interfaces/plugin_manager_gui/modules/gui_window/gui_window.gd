extends Window


func _on_plugin_manager_gui_window_close_requested():
	hide()


func _on_plugin_manager_gui_window_about_to_popup():
	$PluginManagerGui.update_plugin_list()
