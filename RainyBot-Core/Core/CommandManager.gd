extends Node


var commands_dic = {}


func _ready():
	add_to_group("command")
	register_command("help",false,["help - 查看命令列表","help <命令> - 查看某个命令的帮助"],"RainyBot-Core")


func _command_help(args:Array):
	print("--------------")
	if args.size() > 0:
		var cmd = args[0]
		print_command_usages(cmd)
	else:
		for cmd in commands_dic:
			print_command_usages(cmd)
	print("--------------")


func register_command(command:String,need_arguments:bool,usages:Array,source:String):
	if commands_dic.has(command):
		printerr("无法注册以下命令，因为已存在相同命令: ",command)
		return
	commands_dic[command] = {
		"need_args":need_arguments,
		"usages":usages,
		"source":source
	}
	
	
func unregister_command(command):
	commands_dic.erase(command)


func parse_command(c_text:String):
	if !MiraiManager.is_connected_to_mirai():
		printerr("未成功连接至Mirai,因此无法执行指令，请尝试重启RainyBot!")
	if c_text.begins_with("/"):
		c_text.erase(0,1)
	var c_arr = c_text.split(" ")
	var cmd = c_arr[0].to_lower()
	if !commands_dic.has(cmd):
		print("命令 " + cmd + " 不存在！请输入help查看帮助!")
		return
	var args = []
	if c_arr.size() > 1 :
		for i in range(1,c_arr.size()):
			args.append(c_arr[i])
	elif commands_dic[cmd]["need_args"]:
		print("错误的命令用法！命令用法: ")
		print_command_usages(cmd)
		return
	get_tree().call_group("command","_command_"+cmd,args)
	
	
func print_command_usages(command):
	if commands_dic.has(command):
		var usages_arr:Array = commands_dic[command]["usages"]
		for usage in usages_arr:
			print(usage," (命令来源: " + commands_dic[command]["source"] + ")")
	else:
		print("命令 " + command + " 不存在！请输入help查看帮助!")
