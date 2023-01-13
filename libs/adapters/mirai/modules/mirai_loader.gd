extends Node


class_name MiraiLoader


signal mirai_started
signal mirai_closed


var mirai_path:String = GlobalManager.adapter_path + "mirai/"
var mirai_http_path:String = mirai_path + "config/net.mamoe.mirai-api-http/"
var mirai_login_path:String = mirai_path + "config/Console/"
var mirai_http_file:String = mirai_http_path + "setting.yml"
var mirai_login_file:String = mirai_login_path + "AutoLogin.yml"

var mirai_http_config:String = """adapters: 
  - ws
debug: false
enableVerify: {mirai_verify_key_enabled}
verifyKey: '{mirai_verify_key}'
singleMode: false
cacheSize: 4096
persistenceFactory: 'built-in'
adapterSettings:
  ws:
	host: {mirai_address}
	port: {mirai_port}
	reservedSyncId: -1
"""

var mirai_login_config:String = """accounts: 
  - 
	account: {mirai_qq}
	password: 
	  kind: PLAIN
	  value: {mirai_qq_password}
	configuration: 
	  protocol: {mirai_protocol}
	  device: device.json
	  enable: true
	  heartbeatStrategy: STAT_HB
"""

var mirai_process:Process = null


func _process(delta: float) -> void:
	if is_instance_valid(mirai_process):
		var out_count:int = mirai_process.get_available_stdout_lines()
		var err_count:int = mirai_process.get_available_stderr_lines()
		for i in out_count:
			var _lines:PackedStringArray = mirai_process.get_stdout_line().replacen("\n","").split(": ",false,1)
			if _lines.size() == 2:
				GuiManager.mirai_console_print_warning(_lines[1],true)
		for i in err_count:
			var _lines:PackedStringArray = mirai_process.get_stderr_line().replacen("\n","").split(": ",false,1)
			if _lines.size() == 2:
				GuiManager.mirai_console_print_error(_lines[1],true)
		if mirai_process.get_exit_status() != -1:
			GuiManager.console_print_warning("Mirai进程已退出，退出状态为: %s"%mirai_process.get_exit_status())
			GuiManager.mirai_console_print_warning("Mirai进程已退出，退出状态为: %s"%mirai_process.get_exit_status())
			mirai_process = null
			mirai_closed.emit()


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
	file = null


func load_mirai()->int:
	GuiManager.console_print_warning("正在检查Java运行时版本")
	if check_java_version():
		GuiManager.console_print_success("Java环境检测通过，正在生成Mirai配置文件...")
		init_mirai_config()
		GuiManager.console_print_success("Mirai配置文件生成完毕!正在启动Mirai进程...")
		await kill_mirai()
		mirai_process = Process.create("java",["-cp",'./libs/*',"net.mamoe.mirai.console.terminal.MiraiConsoleTerminalLoader","--no-console","--safe-reading","--dont-setup-terminal-ansi","--no-ansi","--no-logging"],mirai_path)
		if !is_instance_valid(mirai_process):
			return ERR_CANT_CREATE
		mirai_started.emit()
		GuiManager.console_print_success("Mirai进程启动成功，正在等待与其建立连接...")
		GuiManager.mirai_console_print_success("Mirai进程启动成功，正在等待与RainyBot建立连接...")
		return OK
	else:
		GuiManager.console_print_error("检测到您还未安装启动Mirai所需的Java运行时(版本 >= Java 11),请访问 https://www.oracle.com/java/technologies/downloads/#jdk17-windows 进行下载并安装")
		GuiManager.console_print_error("安装完毕后请重新启动RainyBot")
		return ERR_FILE_NOT_FOUND
		
		
func kill_mirai()->int:
	if mirai_process != null and mirai_process.get_exit_status() == -1:
		mirai_process.kill(true)
		await mirai_closed
		return OK
	else:
		return ERR_DOES_NOT_EXIST
