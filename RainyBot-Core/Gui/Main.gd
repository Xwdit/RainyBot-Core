extends LineEdit

const NAME = "RainyBot-Core"
const VERSION = "V0.4-Dev"
const AUTHOR = "Xwdit"


var n_history = -1
var arr_history = []


func _ready():
	OS.set_window_title("RainyBot命令输入栏")
	print("正在加载模块:",NAME," 版本:",VERSION," 作者:",AUTHOR)
	ConfigManager.init_config()


func _on_Main_text_entered(new_text):
	text = ""
	arr_history.append(new_text)
	n_history = -1
	CommandManager.parse_command(new_text)


func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		if arr_history.size() > 0:
			if n_history == -1:
				arr_history.append(text)
				n_history = max(0,arr_history.size()-2)
			else:
				n_history = max(0,n_history-1)
			text = arr_history[n_history]
			
	if Input.is_action_just_pressed("ui_down"):
		if arr_history.size() > 0:
			if n_history != -1:
				n_history = min(n_history+1,arr_history.size()-1)
			text = arr_history[n_history]
