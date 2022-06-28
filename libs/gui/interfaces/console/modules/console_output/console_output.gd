extends RichTextLabel


var file:File = File.new()


func _ready()->void:
	save_log(false)
	file.open(GlobalManager.log_path+"rainybot.log",File.WRITE)


func add_newline_with_time(_text)->void:
	var _s_text:String = str(_text)
	var n_text:String = "["+Time.get_datetime_string_from_system(false,true)+"] "+_s_text
	add_text(n_text)
	newline()
	add_to_log(n_text)


func add_error(_text)->void:
	var _s_text:String = str(_text)
	push_color(Color.RED)
	add_newline_with_time(_s_text)
	pop()
	
	
func add_warning(_text)->void:
	var _s_text:String = str(_text)
	push_color(Color.YELLOW)
	add_newline_with_time(_s_text)
	pop()


func add_success(_text)->void:
	var _s_text:String = str(_text)
	push_color(Color.GREEN)
	add_newline_with_time(_s_text)
	pop()


func add_to_log(_text)->void:
	var _s_text:String = str(_text)
	if file.is_open():
		file.store_line(_s_text)
		file.flush()
	
	
func save_log(_close:bool = false)->void:
	if _close and file.is_open():
		file.close()
	var _dir:Directory = Directory.new()
	_dir.open(GlobalManager.log_path)
	if _dir.file_exists("rainybot.log"):
		_dir.rename("rainybot.log","rainybot_"+Time.get_datetime_string_from_system().replace("T","_").replace(":",".")+".log")
