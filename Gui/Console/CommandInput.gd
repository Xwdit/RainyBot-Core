extends LineEdit


var n_history = -1
var arr_history = []


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


func _on_CommandInput_text_submitted(new_text):
	text = ""
	arr_history.append(new_text)
	n_history = -1
	CommandManager.parse_console_command(new_text)
