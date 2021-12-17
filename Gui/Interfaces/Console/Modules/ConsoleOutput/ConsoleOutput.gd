extends RichTextLabel


var file = File.new()


func _ready():
	save_log(false)
	file.open(OS.get_executable_path().get_base_dir() + "/logs/rainybot.log",File.WRITE)


func add_newline_with_time(_text):
	_text = str(_text)
	var n_text = "["+Utils.get_formated_time()+"] "+_text
	add_text(n_text)
	newline()
	add_to_log(n_text)


func add_error(_text):
	_text = str(_text)
	push_color(Color.RED)
	add_newline_with_time(_text)
	pop()
	
	
func add_warning(_text):
	_text = str(_text)
	push_color(Color.YELLOW)
	add_newline_with_time(_text)
	pop()


func add_success(_text):
	_text = str(_text)
	push_color(Color.GREEN)
	add_newline_with_time(_text)
	pop()


func add_to_log(_text):
	_text = str(_text)
	file.store_line(_text)
	file.flush()
	
	
func save_log(_close:bool = false):
	if _close:
		file.close()
	var _dir = Directory.new()
	_dir.open(OS.get_executable_path().get_base_dir() + "/logs/")
	if _dir.file_exists("rainybot.log"):
		_dir.rename("rainybot.log","rainybot_"+Time.get_datetime_string_from_system().replace("T","_").replace(":",".")+".log")
