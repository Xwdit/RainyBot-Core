extends RichTextLabel


func add_newline_with_time(_text):
	var n_text = "["+Utils.get_formated_time()+"]"+_text
	newline()
	add_text(n_text)
	print(n_text)


func add_error(_text):
	push_color(Color.RED)
	add_newline_with_time(_text)
	pop()
	
	
func add_warning(_text):
	push_color(Color.YELLOW)
	add_newline_with_time(_text)
	pop()


func add_success(_text):
	push_color(Color.GREEN)
	add_newline_with_time(_text)
	pop()
