extends Node


var console_commands_dic:Dictionary = {}


func _ready()->void:
	add_to_group("console_command_help")
	register_console_command("help",false,["help - 查看命令列表","help <命令> - 查看某个命令的帮助"],"RainyBot-Core",false)


func _call_console_command(_cmd:String,args:Array)->void:
	if args.size() > 0:
		var cmd:String = args[0]
		Console.print_text("-----命令列表(%s)-----"%[cmd])
		print_console_command_usages(cmd)
		Console.print_text("-----命令列表(%s)-----"%[cmd])
	else:
		Console.print_text("-----命令列表(全部)-----")
		for cmd in console_commands_dic:
			print_console_command_usages(cmd)
		Console.print_text("-----命令列表(全部)-----")


func register_console_command(command:String,need_arguments:bool,usages:Array,source:String,need_connect:bool=false)->int:
	if console_commands_dic.has(command):
		Console.print_error("无法注册以下命令，因为已存在相同命令: " + command)
		return ERR_ALREADY_EXISTS
	console_commands_dic[command] = {
		"need_args":need_arguments,
		"usages":usages,
		"source":source,
		"need_connect":need_connect
	}
	return OK
	
	
func unregister_console_command(command:String)->int:
	if console_commands_dic.erase(command):
		return OK
	else:
		Console.print_error("无法取消注册以下命令，因为此命令不存在: " + command)
		return ERR_DOES_NOT_EXIST


func parse_console_command(c_text:String)->void:
	if c_text.begins_with("/"):
		c_text= c_text.substr(1)
	var c_arr:Array = c_text.split(" ")
	var cmd:String = c_arr[0].to_lower()
	if !console_commands_dic.has(cmd):
		Console.print_warning("命令 " + cmd + " 不存在！请输入help查看帮助!")
		return
	if !BotAdapter.is_bot_connected() && console_commands_dic[cmd]["need_connect"]:
		Console.print_error("未成功连接至机器人后端，因此无法执行此指令，请尝试重启RainyBot!")
		return
	var args:Array = []
	if c_arr.size() > 1 :
		for i in range(1,c_arr.size()):
			args.append(c_arr[i])
	elif console_commands_dic[cmd]["need_args"]:
		Console.print_warning("错误的命令用法！命令用法: ")
		print_console_command_usages(cmd)
		return
	get_tree().call_group("console_command_"+cmd,"_call_console_command",cmd,args)
	
	
func print_console_command_usages(command:String)->void:
	if console_commands_dic.has(command):
		var usages_arr:Array = console_commands_dic[command]["usages"]
		if usages_arr.size() > 0:
			for usage in usages_arr:
				Console.print_text(usage + " (命令来源: " + console_commands_dic[command]["source"] + ")")
		else:
			if console_commands_dic[command]["need_args"]:
				Console.print_text(command + " <命令参数> (命令来源: " + console_commands_dic[command]["source"] + ")")
			else:
				Console.print_text(command + " (命令来源: " + console_commands_dic[command]["source"] + ")")
	else:
		Console.print_warning("命令 " + command + " 不存在！请输入help查看帮助!")
