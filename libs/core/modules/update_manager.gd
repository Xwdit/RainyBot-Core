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

var update_url:String = "https://raw.githubusercontent.com/Xwdit/RainyBot-Core/main/"
var full_update_url:String = "https://github.com/Xwdit/RainyBot-Core/releases/"


func _ready():
	add_to_group("console_command_build-update-json")
	CommandManager.register_console_command("build-update-json",false,["build-update-json - 生成升级统计数据Json文件"],"RainyBot-Core",false)


func _call_console_command(_cmd:String,args:Array)->void:
	match _cmd:
		"build-update-json":
			build_update_json("res://update.json")


func check_update()->bool:
	GuiManager.console_print_warning("正在检查您的RainyBot是否为最新版本，请稍候...")
	Console.disable_sysout(true)
	var result:HttpRequestResult = await Utils.send_http_get_request(update_url+"update.json")
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
	GuiManager.console_print_error("检查更新时出现错误，请检查到Github的网络连接是否正常！ (可能需要科学上网)")
	return false
	

func build_update_json(path:String)->void:
	GuiManager.console_print_warning("正在生成升级统计文件，请稍候...")
	var file_ins:File = File.new()
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
	file_ins.open(path,File.WRITE)
	file_ins.store_line(_text)
	file_ins.close()
	GuiManager.console_print_success("成功生成升级统计文件: %s" % path)


func update_files(dict:Dictionary={})->void:
	GuiManager.console_print_warning("正在统计需要更新或修复的文件，请稍候...")
	if dict.is_empty():
		Console.disable_sysout(true)
		var result:HttpRequestResult = await Utils.send_http_get_request(update_url+"update.json")
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
			Console.popup_notification("未找到需要更新或修复的文件！")
			return
		var args:Array = [format_bytes(result_dict["total_size"]),result_dict["updates"].size(),result_dict["adds"].size(),result_dict["removes"].size()]
		var confirm:bool = await Console.popup_confirm("本次更新需要下载 %s，将更新%s个文件，新增%s个文件，删除%s个文件\n确定要进行更新吗？"% args) 
		if confirm:
			var removed:int = 0
			var updated:int = 0
			var added:int = 0
			GuiManager.console_print_warning("更新已开始，在此期间请勿操作RainyBot...")
			for f in result_dict["removes"]:
				removed += 1
				GuiManager.console_print_warning("正在移除旧文件%s (%s/%s)"% [f,removed,result_dict["removes"].size()])
				var dir:Directory = Directory.new()
				if dir.file_exists(f):
					var err:int = dir.remove(f)
					if err==OK:
						GuiManager.console_print_success("成功移除旧文件%s (%s/%s)"% [f,removed,result_dict["removes"].size()])
						continue
				var r_confirm:bool = await Console.popup_confirm("无法移除旧文件%s\n您想要重试更新RainyBot吗?"% f) 
				if r_confirm:
					update_files(dict)
					return
				var d_confirm:bool = await Console.popup_confirm("增量更新时出现问题，建议下载完整包进行覆盖更新，是否打开下载页面？")
				if d_confirm:
					OS.shell_open(full_update_url)
				notification(NOTIFICATION_WM_CLOSE_REQUEST)
				return
			for f in result_dict["updates"]:
				updated += 1
				GuiManager.console_print_warning("正在更新文件%s (%s/%s)"% [f,updated,result_dict["updates"].size()])
				var err:int = await download_file(f,dict)
				if err!=OK:
					var r_confirm:bool = await Console.popup_confirm("无法更新文件%s\n您想要重试更新RainyBot吗?"% f) 
					if r_confirm:
						update_files(dict)
						return
					var d_confirm:bool = await Console.popup_confirm("增量更新时出现问题，建议下载完整包进行覆盖更新，是否打开下载页面？")
					if d_confirm:
						OS.shell_open(full_update_url)
					notification(NOTIFICATION_WM_CLOSE_REQUEST)
					return
				GuiManager.console_print_success("成功更新文件%s (%s/%s)"% [f,updated,result_dict["updates"].size()])
			for f in result_dict["adds"]:
				added += 1
				GuiManager.console_print_warning("正在添加文件%s (%s/%s)"% [f,added,result_dict["adds"].size()])
				var err:int = await download_file(f,dict)
				if err!=OK:
					var r_confirm:bool = await Console.popup_confirm("无法添加文件%s\n您想要重试更新RainyBot吗?"% f) 
					if r_confirm:
						update_files(dict)
						return
					var d_confirm:bool = await Console.popup_confirm("增量更新时出现问题，建议下载完整包进行覆盖更新，是否打开下载页面？")
					if d_confirm:
						OS.shell_open(full_update_url)
					notification(NOTIFICATION_WM_CLOSE_REQUEST)
					return
				GuiManager.console_print_success("成功添加文件%s (%s/%s)"% [f,added,result_dict["adds"].size()])
			await GuiManager.popup_notification("增量更新成功! 即将重新导入资源并重新启动RainyBot...") 
			GlobalManager.reimport()
	else:
		GuiManager.console_print_error("进行更新时出现错误，请检查到Github的网络连接是否正常！ (可能需要科学上网)")


func format_bytes(bytes:int, decimals:int = 2)->String:
	if bytes == 0:
		return "0 B"
	var k:int = 1024
	var dm:int = 0 if decimals < 0 else decimals
	var sizes:Array = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]

	var i:int = floor(log(bytes) / log(k))

	return (("%."+str(decimals)+"f") % (bytes / pow(k, i))) + " " + sizes[i]


func parse_path_dict(path:String,dict:Dictionary,update_dict:Dictionary={})->void:
	var dir:Directory = Directory.new()
	var error:int = dir.open(path)
	if error!=OK:
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
	var _file:File = File.new()
	var _unique_path:String = _f_path.replace(GlobalManager.root_path,"")
	dict[_unique_path] = {}
	dict[_unique_path]["md5"] = _file.get_md5(_f_path)
	_file.open(_f_path,File.READ)
	dict[_unique_path]["size"] = _file.get_length()
	dict["total_size"] += _file.get_length()
	_file.close()


func check_file_update(_f_path:String,dict:Dictionary,result_dict:Dictionary)->void:
	var _file:File = File.new()
	var _unique_path:String = _f_path.replace(GlobalManager.root_path,"")
	if dict.has(_unique_path):
		if _file.get_md5(_f_path) != dict[_unique_path]["md5"]:
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
		var _dir:Directory = Directory.new()
		if !_dir.file_exists(root_path+f):
			result_dict["adds"].append(root_path+f)
			result_dict["total_size"]+=_value["size"]


func download_file(path:String,dict:Dictionary)->int:
	var _unique_path:String = path.replace(GlobalManager.root_path,"")
	Console.disable_sysout(true)
	var result:HttpRequestResult = await Utils.send_http_get_request("https://raw.githubusercontent.com/Xwdit/RainyBot-Core/main/"+_unique_path)
	var dir_path:String = (path).get_base_dir()+"/"
	var _dir:Directory = Directory.new()
	if !_dir.dir_exists(dir_path):
		_dir.make_dir_recursive(dir_path)
	var err:int = result.save_to_file(path)
	Console.disable_sysout(false)
	var file:File = File.new()
	if err==OK and dict[_unique_path]["md5"]==file.get_md5(path):
		return OK
	return ERR_INVALID_DATA
