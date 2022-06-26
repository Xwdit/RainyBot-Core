extends Window


func _on_plugin_manager_gui_window_close_requested()->void:
	hide()


func _on_plugin_manager_gui_window_about_to_popup()->void:
	$PluginManagerGui.update_plugin_list(true)
