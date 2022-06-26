@tool
extends EditorPlugin


func _enter_tree()->void:
	for arg in OS.get_cmdline_args():
		if arg == "--wait-import":
			get_editor_interface().get_resource_filesystem().connect("resources_reimported",_on_resources_reimported)


func _on_resources_reimported(_arr:PackedStringArray)->void:
	get_tree().quit()
