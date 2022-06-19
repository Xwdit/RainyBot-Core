extends HBoxContainer


enum MainMenuOptions {
	CHECK_UPDATE,
	OPEN_INTERNAL_LOG_DIR,
	EXIT
}


enum ConsoleMenuOptions {
	CLEAR_CONSOLE,
	OPEN_LOG_DIR
}


enum PluginMenuOptions {
	PLUGIN_STORE,
	PLUGIN_MANAGER,
	RELOAD_PLUGIN,
	OPEN_PLUGIN_DIR
}


enum AdapterMenuOptions {
	OPEN_CONFIG_FILE,
	RESTART_ADAPTER,
	ADAPTER_STATUS,
	OPEN_ADAPTER_DIR
}


enum HelpMenuOptions {
	ONLINE_TUTORIAL,
	PLUGIN_API,
	QUESTIONS,
	ISSUES,
	DOC_FEEDBACK,
	COMMUNITY_GROUP,
	COMMUNITY_WEB,
	SOURCE_REPO
}


func _ready():
	$MainMenu.get_popup().connect("id_pressed",_on_main_menu_pressed)
	$ConsoleMenu.get_popup().connect("id_pressed",_on_console_menu_pressed)
	$PluginMenu.get_popup().connect("id_pressed",_on_plugin_menu_pressed)
	$AdapterMenu.get_popup().connect("id_pressed",_on_adapter_menu_pressed)
	$HelpMenu.get_popup().connect("id_pressed",_on_help_menu_pressed)
	
	
func _on_main_menu_pressed(id:int):
	match id:
		MainMenuOptions.CHECK_UPDATE:
			get_parent().check_update()
		MainMenuOptions.OPEN_INTERNAL_LOG_DIR:
			OS.shell_open(OS.get_user_data_dir()+"/logs/")
		MainMenuOptions.EXIT:
			CommandManager.parse_console_command("stop")
			
			
func _on_console_menu_pressed(id:int):
	match id:
		ConsoleMenuOptions.CLEAR_CONSOLE:
			get_tree().call_group("Console","clear")
			Console.print_success("已成功清空控制台的所有内容！")
		ConsoleMenuOptions.OPEN_LOG_DIR:
			OS.shell_open(GlobalManager.log_path)
			
			
func _on_plugin_menu_pressed(id:int):
	match id:
		PluginMenuOptions.PLUGIN_STORE:
			OS.shell_open("https://godoter.cn/t/rainybot-plugins")
		PluginMenuOptions.RELOAD_PLUGIN:
			CommandManager.parse_console_command("plugins areload")
		PluginMenuOptions.OPEN_PLUGIN_DIR:
			OS.shell_open(PluginManager.plugin_path)
		PluginMenuOptions.PLUGIN_MANAGER:
			GuiManager.open_plugin_manager()
			
			
func _on_adapter_menu_pressed(id:int):
	match id:
		AdapterMenuOptions.OPEN_CONFIG_FILE:
			OS.shell_open(GlobalManager.config_path + "mirai_adapter.json")
			Console.print_warning("已为您使用系统默认方式打开协议后端配置文件!")
			Console.print_text("配置选项说明:")
			for key in MiraiConfigManager.config_description:
				Console.print_text(key+":"+MiraiConfigManager.config_description[key])
			Console.print_warning("修改配置后请重启RainyBot")
		AdapterMenuOptions.RESTART_ADAPTER:
			CommandManager.parse_console_command("mirai restart")
		AdapterMenuOptions.ADAPTER_STATUS:
			CommandManager.parse_console_command("mirai status")
		AdapterMenuOptions.OPEN_ADAPTER_DIR:
			OS.shell_open(GlobalManager.adapter_path+"mirai")
			
			
func _on_help_menu_pressed(id:int):
	match id:
		HelpMenuOptions.ONLINE_TUTORIAL:
			OS.shell_open("https://godoter.cn/t/rainybot-tutorials")
		HelpMenuOptions.PLUGIN_API:
			OS.shell_open("https://github.com/Xwdit/RainyBot-API")
		HelpMenuOptions.QUESTIONS:
			OS.shell_open("https://godoter.cn/t/rainybot-qa")
		HelpMenuOptions.ISSUES:
			OS.shell_open("https://github.com/Xwdit/RainyBot-Core/issues")
		HelpMenuOptions.DOC_FEEDBACK:
			OS.shell_open("https://github.com/Xwdit/RainyBot-Api/issues")
		HelpMenuOptions.COMMUNITY_GROUP:
			OS.shell_open("https://qm.qq.com/cgi-bin/qm/qr?k=1nKmcY2qdc-q2Q8BYkn1MyhHrfc3oZ58&jump_from=webapi")
		HelpMenuOptions.COMMUNITY_WEB:
			OS.shell_open("https://godoter.cn/t/rainybot")
		HelpMenuOptions.SOURCE_REPO:
			OS.shell_open("https://github.com/Xwdit/RainyBot-Core/")
