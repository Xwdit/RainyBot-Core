extends Node


var console_commands_dic = {}


func _ready():
	add_to_group("console_command_help")
	register_console_command("help",false,["help - 查看命令列表","help <命令> - 查看某个命令的帮助"],"RainyBot-Core")


func _call_console_command(cmd:String,args:Array):
	GuiManager.console_print_text("--------------")
	if args.size() > 0:
		var _cmd = args[0]
		print_console_command_usages(_cmd)
	else:
		for _cmd in console_commands_dic:
			print_console_command_usages(_cmd)
	GuiManager.console_print_text("--------------")


func register_console_command(command:String,need_arguments:bool,usages:Array,source:String)->int:
	if console_commands_dic.has(command):
		GuiManager.console_print_error("无法注册以下命令，因为已存在相同命令: " + command)
		return ERR_ALREADY_EXISTS
	console_commands_dic[command] = {
		"need_args":need_arguments,
		"usages":usages,
		"source":source,
	}
	return OK
	
	
func unregister_console_command(command)->int:
	if console_commands_dic.erase(command):
		return OK
	else:
		return ERR_DOES_NOT_EXIST


func parse_console_command(c_text:String):
	if !BotAdapter.is_bot_connected():
		GuiManager.console_print_error("未成功连接至机器人后端，因此无法执行指令，请尝试重启RainyBot!")
		return
	if c_text.begins_with("/"):
		c_text= c_text.substr(1)
	var c_arr = c_text.split(" ")
	var cmd = c_arr[0].to_lower()
	if !console_commands_dic.has(cmd):
		GuiManager.console_print_warning("命令 " + cmd + " 不存在！请输入help查看帮助!")
		return
	var args = []
	if c_arr.size() > 1 :
		for i in range(1,c_arr.size()):
			args.append(c_arr[i])
	elif console_commands_dic[cmd]["need_args"]:
		GuiManager.console_print_warning("错误的命令用法！命令用法: ")
		print_console_command_usages(cmd)
		return
	get_tree().call_group("console_command_"+cmd,"_call_console_command",cmd,args)
	
	
func print_console_command_usages(command):
	if console_commands_dic.has(command):
		var usages_arr:Array = console_commands_dic[command]["usages"]
		if usages_arr.size() > 0:
			for usage in usages_arr:
				GuiManager.console_print_text(usage + " (命令来源: " + console_commands_dic[command]["source"] + ")")
		else:
			if console_commands_dic[command]["need_args"]:
				GuiManager.console_print_text(command + " <命令参数> (命令来源: " + console_commands_dic[command]["source"] + ")")
			else:
				GuiManager.console_print_text(command + " (命令来源: " + console_commands_dic[command]["source"] + ")")
	else:
		GuiManager.console_print_warning("命令 " + command + " 不存在！请输入help查看帮助!")
