@tool
extends EditorPlugin


var godot_path:String = OS.get_executable_path().get_base_dir()+"/.godot/"


func _enter_tree():
	for arg in OS.get_cmdline_args():
		if arg == "--clear-import":
			clear_dir_files(godot_path)
			get_tree().quit()
		elif arg == "--wait-import":
			await get_editor_interface().get_resource_filesystem().resources_reimported
			get_tree().quit()


func clear_dir_files(dir_path):
	var dir = Directory.new()
	if dir.dir_exists(dir_path):
		dir.open(dir_path)
		for _file in dir.get_files():
			dir.remove(dir_path+_file)
		for _dir in dir.get_directories():
			clear_dir_files(dir_path+_dir+"/")
		dir.remove(dir_path)
