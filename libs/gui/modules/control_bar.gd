extends HBoxContainer


enum MainMenuOptions {
	CHECK_UPDATE,
	FIX_FILES,
	SCENE_EDITOR,
	OPEN_INTERNAL_LOG_DIR,
	RESTART,
	EXIT
}


enum ConsoleMenuOptions {
	OPEN_CONFIG_FILE,
	CLEAR_CONSOLE,
	OPEN_LOG_DIR
}


enum PluginMenuOptions {
	PLUGIN_STORE,
	RELOAD_PLUGIN,
	REIMPORT_RES,
	OPEN_PLUGIN_DIR,
}


enum AdapterMenuOptions {
	OPEN_CONFIG_FILE,
	RESTART_ADAPTER,
	ADAPTER_STATUS,
	OPEN_ADAPTER_DIR
}


enum HelpMenuOptions {
	DOCUMENT,
	QUESTIONS,
	ISSUES,
	DOC_FEEDBACK,
	COMMUNITY_GROUP,
	COMMUNITY_WEB,
	SOURCE_REPO
}


func _ready()->void:
	$MainMenu.get_popup().connect("id_pressed",_on_main_menu_pressed)
	$ConsoleMenu.get_popup().connect("id_pressed",_on_console_menu_pressed)
	$PluginMenu.get_popup().connect("id_pressed",_on_plugin_menu_pressed)
	$AdapterMenu.get_popup().connect("id_pressed",_on_adapter_menu_pressed)
	$HelpMenu.get_popup().connect("id_pressed",_on_help_menu_pressed)
	
	
func _on_main_menu_pressed(id:int)->void:
	match id:
		MainMenuOptions.CHECK_UPDATE:
			UpdateManager.check_update()
		MainMenuOptions.FIX_FILES:
			UpdateManager.update_files({},"修复")
		MainMenuOptions.SCENE_EDITOR:
			GuiManager.open_scene_editor()
		MainMenuOptions.OPEN_INTERNAL_LOG_DIR:
			if OS.get_name() != "macOS":
				OS.shell_open(OS.get_user_data_dir()+"/logs/")
			else:
				OS.execute("open",[OS.get_user_data_dir()+"/logs/"])
		MainMenuOptions.RESTART:
			GlobalManager.restart()
		MainMenuOptions.EXIT:
			CommandManager.parse_console_command("stop")
			
			
func _on_console_menu_pressed(id:int)->void:
	match id:
		ConsoleMenuOptions.OPEN_CONFIG_FILE:
			if OS.get_name() != "macOS":
				OS.shell_open(ConfigManager.config_path)
			else:
				OS.execute("open",[ConfigManager.config_path])
			GuiManager.console_print_warning("已为您使用系统默认方式打开控制台配置文件!")
			GuiManager.console_print_text("配置选项说明:")
			for key in ConfigManager.config_description:
				GuiManager.console_print_text(key+":"+ConfigManager.config_description[key])
			GuiManager.console_print_warning("修改配置后请重启RainyBot")
		ConsoleMenuOptions.CLEAR_CONSOLE:
			get_tree().call_group("ConsoleBase","clear")
		ConsoleMenuOptions.OPEN_LOG_DIR:
			if OS.get_name() != "macOS":
				OS.shell_open(GlobalManager.log_path)
			else:
				OS.execute("open",[GlobalManager.log_path])
			
			
func _on_plugin_menu_pressed(id:int)->void:
	match id:
		PluginMenuOptions.PLUGIN_STORE:
			OS.shell_open("https://godoter.cn/t/rainybot-plugins")
		PluginMenuOptions.RELOAD_PLUGIN:
			CommandManager.parse_console_command("plugins areload")
		PluginMenuOptions.OPEN_PLUGIN_DIR:
			if OS.get_name() != "macOS":
				OS.shell_open(PluginManager.plugin_path)
			else:
				OS.execute("open",[PluginManager.plugin_path])
		PluginMenuOptions.REIMPORT_RES:
			GlobalManager.reimport()
			
			
func _on_adapter_menu_pressed(id:int)->void:
	match id:
		AdapterMenuOptions.OPEN_CONFIG_FILE:
			if OS.get_name() != "macOS":
				OS.shell_open(GlobalManager.config_path + "mirai_adapter.json")
			else:
				OS.execute("open",[GlobalManager.config_path + "mirai_adapter.json"])
			GuiManager.console_print_warning("已为您使用系统默认方式打开协议后端配置文件!")
			GuiManager.console_print_text("配置选项说明:")
			for key in MiraiConfigManager.config_description:
				GuiManager.console_print_text(key+":"+MiraiConfigManager.config_description[key])
			GuiManager.console_print_warning("修改配置后请重启RainyBot")
		AdapterMenuOptions.RESTART_ADAPTER:
			CommandManager.parse_console_command("mirai restart")
		AdapterMenuOptions.ADAPTER_STATUS:
			CommandManager.parse_console_command("mirai status")
		AdapterMenuOptions.OPEN_ADAPTER_DIR:
			if OS.get_name() != "macOS":
				OS.shell_open(GlobalManager.adapter_path+"mirai")
			else:
				OS.execute("open",[GlobalManager.adapter_path+"mirai"])
			
			
func _on_help_menu_pressed(id:int)->void:
	match id:
		HelpMenuOptions.DOCUMENT:
			OS.shell_open("https://docs.rainybot.dev")
		HelpMenuOptions.QUESTIONS:
			OS.shell_open("https://godoter.cn/t/rainybot-qa")
		HelpMenuOptions.ISSUES:
			OS.shell_open("https://github.com/Xwdit/RainyBot-Core/issues")
		HelpMenuOptions.DOC_FEEDBACK:
			OS.shell_open("https://github.com/Xwdit/RainyBot-Docs/issues")
		HelpMenuOptions.COMMUNITY_GROUP:
			OS.shell_open("https://qm.qq.com/cgi-bin/qm/qr?k=1nKmcY2qdc-q2Q8BYkn1MyhHrfc3oZ58&jump_from=webapi")
		HelpMenuOptions.COMMUNITY_WEB:
			OS.shell_open("https://godoter.cn/t/rainybot")
		HelpMenuOptions.SOURCE_REPO:
			OS.shell_open("https://github.com/Xwdit/RainyBot-Core/")
