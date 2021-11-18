extends Control


class_name PluginEditor


var loaded_path:String = ""


func load_script(path:String)->int:
	var scr:GDScript = load(path)
	if is_instance_valid(scr):
		get_code_edit().text = scr.source_code
		$StatusBar.text = "正在编辑: "+path+" (关闭此窗口即可保存文件)"
		loaded_path = path
		return OK
	else:
		return ERR_CANT_OPEN
	

func get_code_edit()->CodeEdit:
	return get_node("CodeEdit")


func save_script()->int:
	var scr:GDScript = GDScript.new()
	scr.source_code = get_code_edit().text
	return ResourceSaver.save(loaded_path,scr)
