extends Node


class_name MiraiLoader


var mirai_path:String = GlobalManager.adapter_path + "mirai/"
var mirai_http_path:String = mirai_path + "config/net.mamoe.mirai-api-http/"
var mirai_login_path:String = mirai_path + "config/Console/"
var mirai_http_file:String = mirai_http_path + "setting.yml"
var mirai_login_file:String = mirai_login_path + "AutoLogin.yml"

var mirai_http_config:String = """adapters: 
  - ws
debug: false
enableVerify: {mirai_verify_key_enabled}
verifyKey: {mirai_verify_key}
singleMode: false
cacheSize: 4096
persistenceFactory: 'built-in'
adapterSettings:
  ws:
    host: {mirai_address}
    port: {mirai_port}
    reservedSyncId: -1
"""

var mirai_login_config:String = """
accounts:
  -  
	account: {mirai_qq}
	password: 
	  kind: PLAIN
	  value: {mirai_qq_password}
	configuration: 
	  protocol: {mirai_protocol}
	  device: device.json
"""

var mirai_start_cmd:String = """
@echo off
title Mirai Console
cd {mirai_path}
java -cp "./libs/*" net.mamoe.mirai.console.terminal.MiraiConsoleTerminalLoader %*
pause
"""

var mirai_start_cmd_unix:String = """
#!/usr/bin/env sh
cd {mirai_path}
java -cp "./libs/*" net.mamoe.mirai.console.terminal.MiraiConsoleTerminalLoader
"""


func _exit_tree()->void:
	var dir:DirAccess = DirAccess.open(mirai_path)
	if !is_instance_valid(dir):
		return
	if OS.get_name() == "Windows":
		if dir.file_exists(mirai_path+"start.cmd"):
			dir.remove(mirai_path+"start.cmd")
	elif OS.get_name() == "macOS":
		if dir.file_exists(mirai_path+"start.command"):
			dir.remove(mirai_path+"start.command")
	else:
		if dir.file_exists(mirai_path+"start.sh"):
			dir.remove(mirai_path+"start.sh")


func check_java_version()->bool:
	var output:Array[String] = []
	OS.execute("java", ["--version"], output)
	if output.size() > 0 and output[0] != "":
		var ver_str:String = output[0]
		var ver_arr:PackedStringArray = ver_str.split("\n")
		ver_str = ver_arr[0]
		ver_arr = ver_str.split(" ")
		ver_str = ver_arr[1]
		if ver_str.to_int() >= 11:
			return true
	return false


func init_mirai_config()->void:
	var dir:DirAccess = DirAccess.open(mirai_path)
	
	if !dir.dir_exists(mirai_http_path):
		dir.make_dir_recursive(mirai_http_path)
	else:
		if dir.file_exists(mirai_http_file):
			dir.remove(mirai_http_file)
	var file:FileAccess = FileAccess.open(mirai_http_file,FileAccess.WRITE)
	var _str:String = mirai_http_config.format(BotAdapter.mirai_config_manager.loaded_config).replace("	","    ")
	file.store_string(_str)
	
	if !dir.dir_exists(mirai_login_path):
		dir.make_dir_recursive(mirai_login_path)
	else:
		if dir.file_exists(mirai_login_file):
			dir.remove(mirai_login_file)
	file = FileAccess.open(mirai_login_file,FileAccess.WRITE)
	_str = mirai_login_config.format(BotAdapter.mirai_config_manager.loaded_config).replace("	","    ")
	file.store_string(_str)


func init_mirai_cmd()->void:
	var file:FileAccess
	var dir:DirAccess = DirAccess.open(mirai_path)
	
	var _str:String
	if OS.get_name() == "Windows":
		if dir.file_exists(mirai_path+"start.cmd"):
			dir.remove(mirai_path+"start.cmd")
		file = FileAccess.open(mirai_path+"start.cmd",FileAccess.WRITE)
		_str = mirai_start_cmd.format({"mirai_path":mirai_path})
	elif OS.get_name() == "macOS":
		if dir.file_exists(mirai_path+"start.command"):
			dir.remove(mirai_path+"start.command")
		file = FileAccess.open(mirai_path+"start.command",FileAccess.WRITE)
		_str = mirai_start_cmd_unix.format({"mirai_path":mirai_path})
	else:
		if dir.file_exists(mirai_path+"start.sh"):
			dir.remove(mirai_path+"start.sh")
		file = FileAccess.open(mirai_path+"start.sh",FileAccess.WRITE)
		_str = mirai_start_cmd_unix.format({"mirai_path":mirai_path})
	file.store_string(_str)


func load_mirai()->int:
	GuiManager.console_print_warning("正在检查Java运行时版本")
	if check_java_version():
		GuiManager.console_print_success("Java环境检测通过，正在启动Mirai进程...")
		init_mirai_cmd()
		if FileAccess.file_exists(mirai_path+"start.cmd") or FileAccess.file_exists(mirai_path+"start.command") or FileAccess.file_exists(mirai_path+"start.sh"):
			GuiManager.console_print_success("Mirai启动脚本初始化完毕!")
			init_mirai_config()
			GuiManager.console_print_success("Mirai配置文件生成完毕!")
			if OS.get_name() == "Windows":
				if OS.shell_open(mirai_path+"start.cmd") != OK:
					GuiManager.console_print_error("无法启动Mirai,请检查以下目录中文件是否丢失或损坏:"+mirai_path)
					return ERR_CANT_OPEN
			elif OS.get_name() == "macOS":
				OS.execute("chmod",["+x",mirai_path+"start.command"])
				OS.execute("open",[mirai_path+"start.command"])
			else:
				OS.execute("chmod",["+x",mirai_path+"start.sh"])
				OS.create_process(mirai_path+"start.sh",[],true)
			return OK
		else:
			GuiManager.console_print_error("无法初始化Mirai启动脚本，请检查以下目录文件权限是否正确:"+mirai_path)
			return ERR_FILE_NOT_FOUND
	else:
		GuiManager.console_print_error("检测到您还未安装启动Mirai所需的Java运行时(版本 >= Java 11),请访问 https://www.oracle.com/java/technologies/downloads/#jdk17-windows 进行下载并安装")
		GuiManager.console_print_error("安装完毕后请重新启动RainyBot")
		return ERR_FILE_NOT_FOUND
