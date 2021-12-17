extends LineEdit


var n_history = -1
var arr_history = []
var current_text = ""


func _process(_delta):
	update_caret()


func _input(_event):
	if Input.is_action_just_pressed("ui_up"):
		if arr_history.size() > 0:
			if n_history == -1:
				current_text = text
				n_history = maxi(0,arr_history.size()-1)
			else:
				n_history = maxi(0,n_history-1)
			text = arr_history[n_history]
			await get_tree().process_frame
			caret_column = text.length()
			_on_CommandInput_text_changed(text)
	if Input.is_action_just_pressed("ui_down"):
		if arr_history.size() > 0:
			if n_history != -1:
				if n_history == arr_history.size()-1:
					n_history = -1
					text = current_text
				else:
					n_history = mini(n_history+1,arr_history.size()-1)
					text = arr_history[n_history]
			await get_tree().process_frame
			caret_column = text.length()
			_on_CommandInput_text_changed(text)


func _on_CommandInput_text_submitted(new_text):
	text = ""
	_on_CommandInput_text_changed(text)
	if new_text.replace(" ","") == "":
		return
	if arr_history.size() > 0:
		if arr_history[arr_history.size()-1]!=new_text:
			arr_history.append(new_text)
	else:
		arr_history.append(new_text)
	n_history = -1
	CommandManager.parse_console_command(new_text)


func _on_CommandInput_text_changed(new_text):
	update_caret()
	if new_text == "":
		add_theme_color_override("font_color",Color(0.88,0.88,0.88,1))
	else:
		add_theme_color_override("font_color",Color(0.88,0.88,0.88,0))


func update_caret():
	var _text = ""
	if has_focus() && !has_selection():
		_text = text.insert(caret_column,"|")
	else:
		_text = text
	$Caret.text = _text
