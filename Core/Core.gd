extends Node


const NAME = "RainyBot-Core"
const VERSION = "V2.0-Beta-1"
const AUTHOR = "Xwdit"

const MODULE_PATH = "res://Core/Modules/"


func _ready():
	load_modules()
	Console.print_warning("正在启动RainyBot进程.....")
	DisplayServer.window_set_title("RainyBot")
	Console.print_success("成功加载模块: "+NAME+" | 版本:"+VERSION+" | 作者:"+AUTHOR)
#	BotAdapter.init()


func load_modules():
	var dir = Directory.new()
	dir.open(MODULE_PATH)
	var files = dir.get_files()
	for f in files:
		var _node = load(MODULE_PATH+f).new()
		_node.name = (MODULE_PATH+f).get_file().replace(".gd","")
		add_child(_node,true)
		Engine.register_singleton(_node.name,_node)
	for child in get_children():
		child.call("start")
