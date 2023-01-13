extends RichTextLabel


var file:FileAccess = null


func _ready()->void:
	save_log(false)
	init_log()


func init_log(save_current:bool = false):
	if save_current:
		await save_log(true)
	file = FileAccess.open(GlobalManager.log_path+"mirai_adapter.log",FileAccess.WRITE)


func add_newline_with_time(_text,_color:Color=Color.WHITE)->void:
	if ConfigManager.get_output_cleanup_threshold() > 0 and get_line_count() >= ConfigManager.get_output_cleanup_threshold():
		clear()
		init_log(true)
		add_success("当前历史输出行数已到达设定的触发值 (%s行)，因此已为您保存日志并清空控制台中的所有历史输出！"%ConfigManager.get_output_cleanup_threshold())
	var _s_text:String = str(_text)
	if ConfigManager.get_output_max_length() > 0 and _s_text.length() > ConfigManager.get_output_max_length():
		_s_text = _s_text.substr(0,ConfigManager.get_output_max_length())+("...(省略%s个字符)"%(_s_text.length()-ConfigManager.get_output_max_length()))
	var n_text:String = "["+Time.get_datetime_string_from_system(false,true)+"] "+_s_text
	var _is_white:bool = _color.is_equal_approx(Color.WHITE)
	if !_is_white:
		push_color(_color)
	add_text(n_text)
	if !_is_white:
		pop()
	newline()
	add_to_log(n_text)


func add_error(_text)->void:
	add_newline_with_time(_text,Color("ff7085"))
	
	
func add_warning(_text)->void:
	add_newline_with_time(_text,Color("ffeda1"))


func add_success(_text)->void:
	add_newline_with_time(_text,Color("42ffc2"))


func add_to_log(_text)->void:
	var _s_text:String = str(_text)
	if file.is_open():
		file.store_line(_s_text)
		file.flush()
	
	
func save_log(_close:bool = false)->void:
	if _close and file.is_open():
		file = null
	await get_tree().process_frame
	var _dir:DirAccess = DirAccess.open(GlobalManager.log_path)
	if _dir.file_exists("mirai_adapter.log"):
		_dir.rename("mirai_adapter.log","mirai_adapter_"+Time.get_datetime_string_from_system().replace("T","_").replace(":",".")+".log")
	_dir = null
