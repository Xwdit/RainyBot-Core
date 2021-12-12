extends CodeEdit


const CLASS_COLOR = Color(0.25,1,0.75)
const API_COLOR = Color(0.2,0.9,0.8)
const KEYWORD_COLOR = Color(1,0.44,0.52)
const CONTROL_KEYWORD_COLOR = Color(1,0.55,0.8)
const SYMBOL_COLOR = Color(0.66,0.78,1.0)
const FUNCTION_COLOR = Color(0.34,0.69,1.0)
const MEMBER_VAR_COLOR = Color(0.73,0.87,1.0)
const NUMBER_COLOR = Color(0.62,1.0,0.87)
const STRING_COLOR = Color(1,0.92,0.62)
const COMMENT_COLOR = Color(0.8,0.81,0.82,0.5)
const NODE_PATH_COLOR = Color(0.38,0.75,0.34)
const ANNOTATION_COLOR = Color(1,0.69,0.44)


var keyword_colors := {
	"if":CONTROL_KEYWORD_COLOR,
	"elif":CONTROL_KEYWORD_COLOR,
	"else":CONTROL_KEYWORD_COLOR,
	"for":CONTROL_KEYWORD_COLOR,
	"while":CONTROL_KEYWORD_COLOR,
	"match":CONTROL_KEYWORD_COLOR,
	"break":CONTROL_KEYWORD_COLOR,
	"continue":CONTROL_KEYWORD_COLOR,
	"pass":CONTROL_KEYWORD_COLOR,
	"return":CONTROL_KEYWORD_COLOR,
	"class":KEYWORD_COLOR,
	"class_name":KEYWORD_COLOR,
	"extends":KEYWORD_COLOR,
	"is":KEYWORD_COLOR,
	"as":KEYWORD_COLOR,
	"self":KEYWORD_COLOR,
	"signal":KEYWORD_COLOR,
	"func":KEYWORD_COLOR,
	"static":KEYWORD_COLOR,
	"const":KEYWORD_COLOR,
	"enum":KEYWORD_COLOR,
	"var":KEYWORD_COLOR,
	"breakpoint":KEYWORD_COLOR,
	"preload":KEYWORD_COLOR,
	"await":KEYWORD_COLOR,
	"yield":KEYWORD_COLOR,
	"assert":KEYWORD_COLOR,
	"void":KEYWORD_COLOR,
	"in":KEYWORD_COLOR,
	"not":KEYWORD_COLOR,
	"and":KEYWORD_COLOR,
	"or":KEYWORD_COLOR,
	"PI":KEYWORD_COLOR,
	"TAU":KEYWORD_COLOR,
	"INF":KEYWORD_COLOR,
	"NAN":KEYWORD_COLOR,
	"null":KEYWORD_COLOR,
	"int":KEYWORD_COLOR,
	"float":KEYWORD_COLOR,
	"bool":KEYWORD_COLOR,
	"super":KEYWORD_COLOR,
	"true":KEYWORD_COLOR,
	"false":KEYWORD_COLOR,
	"String":CLASS_COLOR,
	"StringName":CLASS_COLOR,
	"NodePath":CLASS_COLOR,
	"Vector2":CLASS_COLOR,
	"Vector2i":CLASS_COLOR,
	"Rect2":CLASS_COLOR,
	"Vector3":CLASS_COLOR,
	"Vector3i":CLASS_COLOR,
	"Transform2D":CLASS_COLOR,
	"Transform3D":CLASS_COLOR,
	"Plane":CLASS_COLOR,
	"Quaternion":CLASS_COLOR,
	"AABB":CLASS_COLOR,
	"Basis":CLASS_COLOR,
	"Color":CLASS_COLOR,
	"RID":CLASS_COLOR,
	"Array":CLASS_COLOR,
	"PackedByteArray":CLASS_COLOR,
	"PackedInt32Array":CLASS_COLOR,
	"PackedInt64Array":CLASS_COLOR,
	"PackedFloat32Array":CLASS_COLOR,
	"PackedFloat64Array":CLASS_COLOR,
	"PackedStringArray":CLASS_COLOR,
	"PackedVector2Array":CLASS_COLOR,
	"PackedVector3Array":CLASS_COLOR,
	"PackedColorArray":CLASS_COLOR,
	"Dictionary":CLASS_COLOR,
	"Signal":CLASS_COLOR,
	"Callable":CLASS_COLOR,
}

var color_regions = {
	"#":COMMENT_COLOR,
	"\" \"":STRING_COLOR,
	"$ .":NODE_PATH_COLOR,
	"@":ANNOTATION_COLOR
}


var api_scripts = {}


func _ready():
	add_comment_delimiter("#","",true)
	init_syntax_highlight()
	init_auto_complete()
	
	
func init_auto_complete():
	register_api_script("res://Core/API/")
	register_api_script("res://Adapters/Mirai/API/")
	

func init_syntax_highlight():
	var class_arr = ClassDB.get_class_list()
	for c_name in class_arr:
		keyword_colors[c_name] = CLASS_COLOR
	register_api_highlight("res://Core/API/")
	register_api_highlight("res://Adapters/Mirai/API/")
	var chl = CodeHighlighter.new()
	chl.number_color = NUMBER_COLOR
	chl.symbol_color = SYMBOL_COLOR
	chl.function_color = FUNCTION_COLOR
	chl.member_variable_color = MEMBER_VAR_COLOR
	chl.keyword_colors = keyword_colors
	chl.color_regions = color_regions
	syntax_highlighter = chl


func register_api_highlight(path:String):
	keyword_colors["BotAdapter"]=API_COLOR
	var dir = Directory.new()
	var error = dir.open(path)
	if error!=OK:
		print(error_string(error))
		return
		
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		if dir.current_is_dir():
			register_api_highlight(path+file+"/")
			continue
		elif !file.begins_with(".") && file.ends_with(".gd"):
			keyword_colors[file.replace(".gd","")]=API_COLOR

	dir.list_dir_end()


func register_api_script(path:String):
	api_scripts["BotAdapter"]=BotAdapter
	var dir = Directory.new()
	var error = dir.open(path)
	if error!=OK:
		print(error_string(error))
		return
		
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		if dir.current_is_dir():
			register_api_script(path+file+"/")
			continue
		elif !file.begins_with(".") && file.ends_with(".gd"):
			api_scripts[file.replace(".gd","")]=load(path+file)

	dir.list_dir_end()


func _on_CodeEdit_request_code_completion():
	var _line = get_line(get_caret_line()).strip_edges()
	var _chr = _line.substr(get_caret_column()-1)
	var _l_arr = _line.split(" ")
	var _latest = _l_arr[_l_arr.size()-1]
	var _cls = _latest.split(".")[0]
	if _latest.countn(".")==1:
		if api_scripts.has(_cls):
			var _scr:GDScript = api_scripts[_cls]
			var _m_list = _scr.get_script_method_list()
			var _c_list = _scr.get_script_constant_map().keys()
			for m in _m_list:
				if !m["name"].begins_with("@"):
					add_code_completion_option(CodeEdit.KIND_FUNCTION,m["name"]+"( )",m["name"]+"()",FUNCTION_COLOR)
			for c in _c_list:
				add_code_completion_option(CodeEdit.KIND_MEMBER,c,c,MEMBER_VAR_COLOR)
		elif ClassDB.class_exists(_cls):
			var _m_list = ClassDB.class_get_method_list(_cls)
			var _p_list = ClassDB.class_get_property_list(_cls)
			var _s_list = ClassDB.class_get_signal_list(_cls)
			var _c_list = ClassDB.class_get_integer_constant_list(_cls)
			var _e_list = ClassDB.class_get_enum_list(_cls)
			for m in _m_list:
				add_code_completion_option(CodeEdit.KIND_FUNCTION,m["name"]+"( )",m["name"]+"()",FUNCTION_COLOR)
			for p in _p_list:
				add_code_completion_option(CodeEdit.KIND_MEMBER,p["name"],p["name"],MEMBER_VAR_COLOR)
			for s in _s_list:
				add_code_completion_option(CodeEdit.KIND_MEMBER,s["name"],s["name"],MEMBER_VAR_COLOR)
			for c in _c_list:
				add_code_completion_option(CodeEdit.KIND_MEMBER,c,c,MEMBER_VAR_COLOR)
			for e in _e_list:
				add_code_completion_option(CodeEdit.KIND_MEMBER,e,e,MEMBER_VAR_COLOR)
	else:
		var _kw = keyword_colors
		var _plug:GDScript = Plugin
		var _m_list = _plug.get_script_method_list()
		var _p_vm_list = ["_on_init","_on_connect","_on_load","_on_ready","_on_process","_on_disconnect","_on_unload"]
		for k in _kw:
			add_code_completion_option(CodeEdit.KIND_CLASS,k,k,_kw[k])
		for m in _m_list:
			if !m["name"].begins_with("_") and !m["name"].begins_with("@"):
				add_code_completion_option(CodeEdit.KIND_FUNCTION,m["name"]+"( )",m["name"]+"()",FUNCTION_COLOR)
		for vm in _p_vm_list:
			add_code_completion_option(CodeEdit.KIND_FUNCTION,vm+"( )",vm+"()",FUNCTION_COLOR)
	update_code_completion_options(false)


func _on_CodeEdit_text_changed():
	if (is_in_comment(get_caret_line(),get_caret_column())==-1) and (is_in_string(get_caret_line(),get_caret_column())==-1):
		request_code_completion()
