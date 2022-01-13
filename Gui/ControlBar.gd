extends HBoxContainer


enum MainMenuOptions {
	CHECK_UPDATE,
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
	CONFIG_MANAGER,
	RESTART_ADAPTER,
	ADAPTER_STATUS,
	OPEN_ADAPTER_DIR
}


enum HelpMenuOptions {
	ONLINE_DOC,
	PLUGIN_API,
	QUESTIONS,
	ISSUES,
	FEATURES,
	DOC_FEEDBACK,
	COMMUNITY_GROUP,
	WEBSITE,
	ABOUT
}


func _ready():
	$MainMenu.get_popup().connect("id_pressed",_on_main_menu_pressed)
	$ConsoleMenu.get_popup().connect("id_pressed",_on_console_menu_pressed)
	$PluginMenu.get_popup().connect("id_pressed",_on_plugin_menu_pressed)
	$AdapterMenu.get_popup().connect("id_pressed",_on_adapter_menu_pressed)
	$HelpMenu.get_popup().connect("id_pressed",_on_help_menu_pressed)
	
	
func _on_main_menu_pressed(id:int):
	match id:
		MainMenuOptions.EXIT:
			CommandManager.parse_console_command("stop")
			
			
func _on_console_menu_pressed(id:int):
	match id:
		ConsoleMenuOptions.CLEAR_CONSOLE:
			get_tree().call_group("Console","clear")
			Console.print_success("已成功清空控制台的所有内容！")
		ConsoleMenuOptions.OPEN_LOG_DIR:
			OS.shell_open(OS.get_executable_path().get_base_dir() + "/logs/")
			
			
func _on_plugin_menu_pressed(id:int):
	match id:
		PluginMenuOptions.RELOAD_PLUGIN:
			CommandManager.parse_console_command("plugins areload")
		PluginMenuOptions.OPEN_PLUGIN_DIR:
			OS.shell_open(OS.get_executable_path().get_base_dir() + "/plugins/")
			
			
func _on_adapter_menu_pressed(id:int):
	match id:
		AdapterMenuOptions.RESTART_ADAPTER:
			CommandManager.parse_console_command("mirai restart")
		AdapterMenuOptions.ADAPTER_STATUS:
			CommandManager.parse_console_command("mirai status")
		AdapterMenuOptions.OPEN_ADAPTER_DIR:
			OS.shell_open(OS.get_executable_path().get_base_dir() + "/adapters/mirai")
			
			
func _on_help_menu_pressed(id:int):
	match id:
		HelpMenuOptions.PLUGIN_API:
			OS.shell_open("https://github.com/Xwdit/RainyBot-API")
		HelpMenuOptions.ISSUES:
			OS.shell_open("https://github.com/Xwdit/RainyBot-Core/issues")
		HelpMenuOptions.FEATURES:
			OS.shell_open("https://github.com/Xwdit/RainyBot-Core/issues")
		HelpMenuOptions.DOC_FEEDBACK:
			OS.shell_open("https://github.com/Xwdit/RainyBot-Api/issues")
		HelpMenuOptions.COMMUNITY_GROUP:
			OS.shell_open("https://qm.qq.com/cgi-bin/qm/qr?k=1nKmcY2qdc-q2Q8BYkn1MyhHrfc3oZ58&jump_from=webapi")
		HelpMenuOptions.WEBSITE:
			OS.shell_open("https://rainy.love/rainybot")
