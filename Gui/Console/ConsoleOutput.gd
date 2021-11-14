extends RichTextLabel


func add_newline_with_time(text):
	var n_text = "["+Utils.get_formated_time()+"]"+text
	newline()
	add_text(n_text)
	print(n_text)


func add_error(text):
	push_color(Color.RED)
	add_newline_with_time(text)
	pop()
	
	
func add_warning(text):
	push_color(Color.YELLOW)
	add_newline_with_time(text)
	pop()


func add_success(text):
	push_color(Color.GREEN)
	add_newline_with_time(text)
	pop()
