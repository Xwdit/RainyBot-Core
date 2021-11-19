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
		GuiManager.console_print_error("插件文件加载时出现错误，请检查文件权限是否正确")
		return ERR_CANT_OPEN
	

func get_code_edit()->CodeEdit:
	return get_node("CodeEdit")


func save_script()->int:
	var scr:GDScript = GDScript.new()
	scr.source_code = get_code_edit().text
	var err_code = ResourceSaver.save(loaded_path,scr)
	if err_code == OK:
		GuiManager.console_print_success("插件保存成功！")
		GuiManager.console_print_success("请不要忘记重载插件以使更改生效!")
	else:
		GuiManager.console_print_error("插件文件保存时出现错误，请检查文件权限是否正确")
	return err_code
