extends Node


var paths_to_check:Array = [
	"adapters/mirai/libs/",
	"adapters/mirai/plugin-libraries/",
	"adapters/mirai/plugins/",
	"libs/"
]

var files_to_check:Array = [
	"project.godot"
]

var update_sources:Dictionary = {
	"GitHub":"https://raw.githubusercontent.com/Xwdit/RainyBot-Core/main/",
	"Gitee":"https://gitee.com/xwdit/RainyBot-Core/raw/main/"
}
var full_update_url:String = "https://github.com/Xwdit/RainyBot-Core/releases/"
var updating:bool = false


func _ready():
	add_to_group("console_command_build-update-json")
	CommandManager.register_console_command("build-update-json",false,["build-update-json - 生成升级统计数据Json文件"],"RainyBot-Core",false)


func _call_console_command(_cmd:String,args:Array)->void:
	match _cmd:
		"build-update-json":
			build_update_json("res://update.json")


func check_update()->bool:
	GuiManager.console_print_warning("正在检查您的RainyBot是否为最新版本，请稍候...(下载源: %s)"% ConfigManager.get_update_source())
	Console.disable_sysout(true)
	var result:HttpRequestResult = await Utils.send_http_get_request(get_update_url()+"update.json",[],20)
	var dic:Dictionary = result.get_as_dic()
	Console.disable_sysout(false)
	if !dic.is_empty():
		var version:String = dic["version"]
		if RainyBotCore.VERSION.to_lower() != version.to_lower():
			GuiManager.console_print_warning("发现RainyBot新版本! 最新版本为: %s, 您的当前版本为: %s。更新日志请访问: %s"%[version,RainyBotCore.VERSION,full_update_url])
			if dic["godot_version"] != Engine.get_version_info()["hash"]:
				var confirmed:bool = await Console.popup_confirm("发现RainyBot新版本! 最新版本为: %s, 您的当前版本为: %s\n此版本需要下载完整更新包，您想要更新吗?"%[version,RainyBotCore.VERSION])
				if confirmed:
					OS.shell_open(full_update_url)
				return true
			else:
				var confirmed:bool = await Console.popup_confirm("发现RainyBot新版本! 最新版本为: %s, 您的当前版本为: %s\n您想要进行自动增量热更新吗?"%[version,RainyBotCore.VERSION])
				if confirmed:
					await update_files(dic)
					return false
				return true
		GuiManager.console_print_success("版本检查完毕，您的RainyBot已为最新版本！")
		return true
	GuiManager.console_print_error("检查更新时出现错误，请检查网络连接是否正常！ (某些下载源可能需要特殊上网方式)")
	return false
	

func build_update_json(path:String)->void:
	GuiManager.console_print_warning("正在生成升级统计文件，请稍候...")
	var dict:Dictionary = {"total_size":0}
	var root:String = GlobalManager.root_path
	for _path in paths_to_check:
		parse_path_dict(root+_path,dict)
	for _file in files_to_check:
		build_file_dict(root+_file,dict)
	dict["version"]=RainyBotCore.VERSION
	dict["godot_version"]=Engine.get_version_info()["hash"]
	var json:JSON = JSON.new()
	var _text:String = json.stringify(dict)
	var file_ins:FileAccess = FileAccess.open(path,FileAccess.WRITE)
	file_ins.store_line(_text)
	GuiManager.console_print_success("成功生成升级统计文件: %s" % path)


func update_files(dict:Dictionary={},action:String="更新")->void:
	var status:Dictionary = {"removed":[],"updated":[],"added":[],"remove_failed":[],"update_failed":[],"add_failed":[]}
	GuiManager.console_print_warning("正在统计需要{action}的文件，请稍候...(下载源: %s)".format({"action":action})% ConfigManager.get_update_source())
	if dict.is_empty():
		Console.disable_sysout(true)
		var result:HttpRequestResult = await Utils.send_http_get_request(get_update_url()+"update.json",[],20)
		dict = result.get_as_dic()
		Console.disable_sysout(false)
	var root:String = GlobalManager.root_path
	if !dict.is_empty():
		var result_dict:Dictionary = {"total_size":0,"removes":[],"adds":[],"updates":[]}
		for _path in paths_to_check:
			parse_path_dict(root+_path,dict,result_dict)
		for _file in files_to_check:
			check_file_update(root+_file,dict,result_dict)
		check_new_files(dict,result_dict)
		if result_dict["updates"].is_empty() and result_dict["adds"].is_empty() and result_dict["removes"].is_empty():
			Console.popup_notification("未找到需要{action}的文件！".format({"action":action}))
			return
		var args:Array = [format_bytes(result_dict["total_size"]),result_dict["updates"].size(),result_dict["adds"].size(),result_dict["removes"].size()]
		var confirm:bool = await Console.popup_confirm("本次{action}需要下载 %s，将更改%s个文件，新增%s个文件，删除%s个文件\n确定要进行{action}吗？".format({"action":action})% args) 
		if confirm:
			updating = true
			GuiManager.console_print_warning("{action}已开始，RainyBot可能会暂时停止响应，在此期间请勿执行任何操作...".format({"action":action}))
			await get_tree().create_timer(1).timeout
			Console.disable_sysout(true)
			for f in result_dict["removes"]:
				_remove(status,f)
			var r_progress:int = status.remove_failed.size()+status.removed.size()
			while !r_progress == result_dict["removes"].size():
				await get_tree().process_frame
				r_progress = status.remove_failed.size()+status.removed.size()
				DisplayServer.window_set_title("RainyBot - 自动更新 - 移除文件中(%s/%s)"%[r_progress,result_dict["removes"].size()])
			Console.disable_sysout(false)
			if !status.remove_failed.is_empty():
				updating = false
				var r_confirm:bool = await Console.popup_confirm("%s个文件删除失败\n您想要重试{action}RainyBot吗?".format({"action":action})% status.update_failed.size()) 
				if r_confirm:
					update_files(dict,action)
					return
				var d_confirm:bool = await Console.popup_confirm("增量{action}时出现问题，建议下载完整包进行覆盖安装，是否打开下载页面？".format({"action":action}))
				if d_confirm:
					OS.shell_open(full_update_url)
				notification(NOTIFICATION_WM_CLOSE_REQUEST)
				return
			Console.disable_sysout(true)
			for f in result_dict["updates"]:
				_update(status,f,dict)
			var u_progress:int = status.update_failed.size()+status.updated.size()
			while !u_progress == result_dict["updates"].size():
				await get_tree().process_frame
				u_progress = status.update_failed.size()+status.updated.size()
				DisplayServer.window_set_title("RainyBot - 自动更新 - 更改文件中(%s/%s)"%[u_progress,result_dict["updates"].size()])
			Console.disable_sysout(false)
			if !status.update_failed.is_empty():
				updating = false
				var r_confirm:bool = await Console.popup_confirm("%s个文件更新失败\n您想要重试{action}RainyBot吗?".format({"action":action})% status.update_failed.size()) 
				if r_confirm:
					update_files(dict,action)
					return
				var d_confirm:bool = await Console.popup_confirm("增量{action}时出现问题，建议下载完整包进行覆盖安装，是否打开下载页面？".format({"action":action}))
				if d_confirm:
					OS.shell_open(full_update_url)
				notification(NOTIFICATION_WM_CLOSE_REQUEST)
				return
			Console.disable_sysout(true)
			for f in result_dict["adds"]:
				_add(status,f,dict)
			var a_progress:int = status.add_failed.size()+status.added.size()
			while !a_progress == result_dict["adds"].size():
				await get_tree().process_frame
				a_progress = status.add_failed.size()+status.added.size()
				DisplayServer.window_set_title("RainyBot - 自动更新 - 添加文件中(%s/%s)"%[a_progress,result_dict["adds"].size()])
			Console.disable_sysout(false)
			if !status.add_failed.is_empty():
				updating = false
				var r_confirm:bool = await Console.popup_confirm("%s个文件添加失败\n您想要重试{action}RainyBot吗?".format({"action":action})% status.add_failed.size()) 
				if r_confirm:
					update_files(dict,action)
					return
				var d_confirm:bool = await Console.popup_confirm("增量{action}时出现问题，建议下载完整包进行覆盖安装，是否打开下载页面？".format({"action":action}))
				if d_confirm:
					OS.shell_open(full_update_url)
				notification(NOTIFICATION_WM_CLOSE_REQUEST)
				return
			updating = false
			await GuiManager.popup_notification("增量{action}成功! 请点击确定来重新导入资源并重新启动RainyBot".format({"action":action})) 
			GlobalManager.reimport()
	else:
		GuiManager.console_print_error("进行{action}时出现错误，请检查网络连接是否正常！ (某些下载源可能需要特殊上网方式)".format({"action":action}))


func _remove(status:Dictionary,file:String):
	if FileAccess.file_exists(file):
		var dir:DirAccess = DirAccess.open(file.get_base_dir())
		var err:int = dir.remove(file)
		if !err:
			status.removed.append(file)
			return
	status.remove_failed.append(file)


func _update(status:Dictionary,file:String,dict:Dictionary):
	var err:int = await download_file(file,dict)
	if err:
		status.update_failed.append(file)
	else:
		status.updated.append(file)


func _add(status:Dictionary,file:String,dict:Dictionary):
	var err:int = await download_file(file,dict)
	if err:
		status.add_failed.append(file)
	else:
		status.added.append(file)


func format_bytes(bytes:int, decimals:int = 2)->String:
	if bytes == 0:
		return "0 B"
	var k:int = 1024
	var dm:int = 0 if decimals < 0 else decimals
	var sizes:Array = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]

	var i:int = floor(log(bytes) / log(k))

	return (("%."+str(decimals)+"f") % (bytes / pow(k, i))) + " " + sizes[i]


func parse_path_dict(path:String,dict:Dictionary,update_dict:Dictionary={})->void:
	var dir:DirAccess = DirAccess.open(path)
	if !dir:
		print(path)
		return
		
	dir.list_dir_begin()

	while true:
		var file:String = dir.get_next()
		if file == "":
			break
		if dir.current_is_dir():
			parse_path_dict(path+file+"/",dict,update_dict)
			continue
		else:
			if update_dict.is_empty():
				build_file_dict(path+file,dict)
			else:
				check_file_update(path+file,dict,update_dict)
	dir.list_dir_end()


func build_file_dict(_f_path:String,dict:Dictionary)->void:
	var _unique_path:String = _f_path.replace(GlobalManager.root_path,"")
	dict[_unique_path] = {}
	dict[_unique_path]["md5"] = FileAccess.get_md5(_f_path)
	var _file:FileAccess = FileAccess.open(_f_path,FileAccess.READ)
	dict[_unique_path]["size"] = _file.get_length()
	dict["total_size"] += _file.get_length()


func check_file_update(_f_path:String,dict:Dictionary,result_dict:Dictionary)->void:
	var _unique_path:String = _f_path.replace(GlobalManager.root_path,"")
	if dict.has(_unique_path):
		if FileAccess.get_md5(_f_path) != dict[_unique_path]["md5"]:
			result_dict["updates"].append(_f_path)
			result_dict["total_size"]+=dict[_unique_path]["size"]
	else:
		result_dict["removes"].append(_f_path)


func check_new_files(dict:Dictionary,result_dict:Dictionary)->void:
	var root_path:String = GlobalManager.root_path
	for f in dict:
		var _value = dict[f]
		if !(_value is Dictionary) or !_value.has("size"):
			continue
		if !FileAccess.file_exists(root_path+f):
			result_dict["adds"].append(root_path+f)
			result_dict["total_size"]+=_value["size"]


func download_file(path:String,dict:Dictionary)->int:
	var _unique_path:String = path.replace(GlobalManager.root_path,"")
	var result:HttpRequestResult = await Utils.send_http_get_request(get_update_url()+_unique_path.uri_encode(),[],600)
	var dir_path:String = (path).get_base_dir()+"/"
	if !DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_recursive_absolute(dir_path)
	var err:int = result.save_to_file(path)
	var md5:String = FileAccess.get_md5(path)
	if !err and dict[_unique_path]["md5"]==md5:
		return OK
	return ERR_INVALID_DATA


func get_update_url()->String:
	var source:String = ConfigManager.get_update_source()
	if update_sources.has(source):
		return update_sources[source]
	else:
		Console.print_error("配置文件中指定的下载源不存在，已选择GitHub作为默认下载源！")
		return update_sources["GitHub"]
