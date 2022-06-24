extends Node


class_name MiraiLoader


var mirai_path = GlobalManager.adapter_path + "mirai/"
var mirai_http_path = mirai_path + "config/net.mamoe.mirai-api-http/"
var mirai_login_path = mirai_path + "config/Console/"
var mirai_http_file = mirai_http_path + "setting.yml"
var mirai_login_file = mirai_login_path + "AutoLogin.yml"

var mirai_http_config = """
adapters: 
  - ws
debug: false
enableVerify: {mirai_verify_key_enabled}
verifyKey: {mirai_verify_key}
singleMode: false
cacheSize: 4096
adapterSettings:
  ws:
	host: {mirai_address}
	port: {mirai_port}
	reservedSyncId: -1
"""

var mirai_login_config = """
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

var mirai_start_cmd = """
@echo off
title Mirai Console
cd {mirai_path}
java -cp "./libs/*" net.mamoe.mirai.console.terminal.MiraiConsoleTerminalLoader %*
pause
"""

var mirai_start_cmd_unix = """
#!/usr/bin/env sh
cd {mirai_path}
java -cp "./libs/*" net.mamoe.mirai.console.terminal.MiraiConsoleTerminalLoader
"""


func _exit_tree():
	var dir = Directory.new()
	dir.open(mirai_path)
	dir.remove(mirai_path+"start.cmd")


func check_java_version():
	var output = []
	var _exit_code = OS.execute("java", ["--version"], output)
	if output.size() > 0:
		var ver_str:String = output[0]
		var ver_arr:Array = ver_str.split("\n")
		ver_str = ver_arr[0]
		ver_arr = ver_str.split(" ")
		ver_str = ver_arr[1]
		if ver_str.to_int() >= 11:
			return true
	return false


func init_mirai_config():
	var dir = Directory.new()
	var file = File.new()
	
	dir.open(mirai_path)
	
	if !dir.dir_exists(mirai_http_path):
		dir.make_dir_recursive(mirai_http_path)
	else:
		if dir.file_exists(mirai_http_file):
			dir.remove(mirai_http_file)
	file.open(mirai_http_file,File.WRITE)
	var _str = mirai_http_config.format(BotAdapter.mirai_config_manager.loaded_config).replace("	","    ")
	file.store_string(_str)
	file.close()
	
	if !dir.dir_exists(mirai_login_path):
		dir.make_dir_recursive(mirai_login_path)
	else:
		if dir.file_exists(mirai_login_file):
			dir.remove(mirai_login_file)
	file.open(mirai_login_file,File.WRITE)
	_str = mirai_login_config.format(BotAdapter.mirai_config_manager.loaded_config).replace("	","    ")
	file.store_string(_str)
	file.close()


func init_mirai_cmd():
	var dir = Directory.new()
	var file = File.new()
	
	dir.open(mirai_path)
	
	var _str:String
	if OS.get_name() == "Windows":
		if dir.file_exists(mirai_path+"start.cmd"):
			dir.remove(mirai_path+"start.cmd")
		file.open(mirai_path+"start.cmd",File.WRITE)
		_str = mirai_start_cmd.format({"mirai_path":mirai_path})
	elif OS.get_name() == "macOS":
		if dir.file_exists(mirai_path+"start.command"):
			dir.remove(mirai_path+"start.command")
		file.open(mirai_path+"start.command",File.WRITE)
		_str = mirai_start_cmd_unix.format({"mirai_path":mirai_path})
	else:
		if dir.file_exists(mirai_path+"start.sh"):
			dir.remove(mirai_path+"start.sh")
		file.open(mirai_path+"start.sh",File.WRITE)
		_str = mirai_start_cmd_unix.format({"mirai_path":mirai_path})
	file.store_string(_str)
	file.close()


func load_mirai():
	Console.print_warning("正在检查Java运行时版本")
	if check_java_version():
		Console.print_success("Java环境检测通过，正在启动Mirai进程...")
		init_mirai_cmd()
		var file = File.new()
		if file.file_exists(mirai_path+"start.cmd") or file.file_exists(mirai_path+"start.command") or file.file_exists(mirai_path+"start.sh"):
			Console.print_success("Mirai启动脚本初始化完毕!")
			init_mirai_config()
			Console.print_success("Mirai配置文件生成完毕!")
			if OS.get_name() == "Windows":
				if OS.shell_open(mirai_path+"start.cmd") != OK:
					Console.print_error("无法启动Mirai,请检查以下目录中文件是否丢失或损坏:"+mirai_path)
					return ERR_CANT_OPEN
			if OS.get_name() == "macOS":
				OS.execute("chmod",["+x",mirai_path+"start.command"])
				OS.execute("open",[mirai_path+"start.command"])
			else:
				OS.execute("chmod",["+x",mirai_path+"start.sh"])
				OS.create_process(mirai_path+"start.sh",[],true)
			return OK
		else:
			Console.print_error("无法初始化Mirai启动脚本，请检查以下目录文件权限是否正确:"+mirai_path)
			return ERR_FILE_NOT_FOUND
	else:
		Console.print_error("检测到您还未安装启动Mirai所需的Java运行时(版本 >= Java 11),请访问 https://www.oracle.com/java/technologies/downloads/#jdk17-windows 进行下载并安装")
		Console.print_error("安装完毕后请重新启动RainyBot")
		return ERR_FILE_NOT_FOUND
