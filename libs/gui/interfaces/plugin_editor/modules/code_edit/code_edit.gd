extends CodeEdit


signal update_finished


const CLASS_COLOR:Color = Color(0.25,1,0.75)
const API_COLOR:Color = Color(0.2,0.9,0.8)
const KEYWORD_COLOR:Color = Color(1,0.44,0.52)
const CONTROL_KEYWORD_COLOR:Color = Color(1,0.55,0.8)
const SYMBOL_COLOR:Color = Color(0.66,0.78,1.0)
const FUNCTION_COLOR:Color = Color(0.34,0.69,1.0)
const MEMBER_VAR_COLOR:Color = Color(0.73,0.87,1.0)
const NUMBER_COLOR:Color = Color(0.62,1.0,0.87)
const STRING_COLOR:Color = Color(1,0.92,0.62)
const COMMENT_COLOR:Color = Color(0.8,0.81,0.82,0.5)
const NODE_PATH_COLOR:Color = Color(0.38,0.75,0.34)
const ANNOTATION_COLOR:Color = Color(1,0.69,0.44)


var keyword_colors:Dictionary = {
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
}

var type_dic:Dictionary = {
	TYPE_NIL:"null",
	TYPE_BOOL:"bool",
	TYPE_INT:"int",
	TYPE_FLOAT:"float",
	TYPE_STRING:"String",
	TYPE_VECTOR2:"Vector2",
	TYPE_VECTOR2I:"Vector2i",
	TYPE_RECT2:"Rect2",
	TYPE_RECT2I:"Rect2i",
	TYPE_VECTOR3:"Vector3",
	TYPE_VECTOR3I:"Vector3i",
	TYPE_TRANSFORM2D:"Transform2D",
	TYPE_PLANE:"Plane",
	TYPE_QUATERNION:"Quaternion",
	TYPE_AABB:"AABB",
	TYPE_BASIS:"Basis",
	TYPE_TRANSFORM3D:"Transform3D",
	TYPE_COLOR:"Color",
	TYPE_STRING_NAME:"StringName",
	TYPE_NODE_PATH:"NodePath",
	TYPE_RID:"RID",
	TYPE_OBJECT:"Object",
	TYPE_CALLABLE:"Callable",
	TYPE_SIGNAL:"Signal",
	TYPE_DICTIONARY:"Dictionary",
	TYPE_ARRAY:"Array",
	TYPE_PACKED_BYTE_ARRAY:"PackedByteArray",
	TYPE_PACKED_INT32_ARRAY:"PackedInt32Array",
	TYPE_PACKED_INT64_ARRAY:"PackedInt64Array",
	TYPE_PACKED_FLOAT32_ARRAY:"PackedFloat32Array",
	TYPE_PACKED_FLOAT64_ARRAY:"PackedFloat64Array",
	TYPE_PACKED_STRING_ARRAY:"PackedStringArray",
	TYPE_PACKED_VECTOR2_ARRAY:"PackedVector2Array",
	TYPE_PACKED_VECTOR3_ARRAY:"PackedVector3Array",
	TYPE_PACKED_COLOR_ARRAY:"PackedColorArray"
}

var color_regions:Dictionary = {
	"#":COMMENT_COLOR,
	"\" \"":STRING_COLOR,
	"$ .":NODE_PATH_COLOR,
	"@":ANNOTATION_COLOR
}

var core_api_path:String = "res://libs/core/api/"
var adapter_api_path:String = "res://libs/adapters/mirai/api/"
var class_doc_path:String = "res://libs/gui/resources/class_docs/"


var api_dic:Dictionary = {}
var class_dic:Dictionary = {}
var kw_keys:Array = []
var api_keys:Array = []
var class_keys:Array = []

var error_lines:Dictionary = {}
var last_text:String = ""


func _ready()->void:
	grab_focus()
	set_caret_line(0)
	set_caret_column(0)
	init_auto_complete()
	init_syntax_highlight()
	init_keys_arr()


func init_keys_arr()->void:
	kw_keys = keyword_colors.keys()
	api_keys = api_dic.keys()
	class_keys = class_dic.keys()
	kw_keys.sort()
	api_keys.sort()
	class_keys.sort()


func init_auto_complete()->void:
	api_dic["BotAdapter"]= build_script_dic(BotAdapter.get_script())
	add_comment_delimiter("#","",true)
	build_class_dics(class_doc_path)
	build_api_dics(core_api_path)
	build_api_dics(adapter_api_path)
	

func build_class_dics(path:String)->void:
	var dir:Directory = Directory.new()
	dir.open(path)
	var files:PackedStringArray = dir.get_files()
	for f in files:
		var _c:String = f.replacen(".xml","")
		if !class_dic.has(_c):
			class_dic[_c]={"m":{},"p":{},"c":{},"s":{}}
		var _xml:XMLParser = XMLParser.new()
		_xml.open(path+f)
		var _m:String = ""
		var _p:String = ""
		var _co:String = ""
		while _xml.read() == OK:
			if _xml.get_node_type() == _xml.NODE_ELEMENT:
				var _name:String = _xml.get_named_attribute_value_safe("name")
				match _xml.get_node_name():
					"method":
						_m = _name
						class_dic[_c]["m"][_name]=""
					"constructor":
						_co = _name
						class_dic["@GlobalScope"]["m"][_name]=""
					"member":
						_p = _name
						class_dic[_c]["p"][_name]=""
					"constant":
						class_dic[_c]["c"][_name]=""
					"signal":
						class_dic[_c]["s"][_name]=""
					"return":
						if _m != "":
							class_dic[_c]["m"][_m]=_xml.get_named_attribute_value_safe("type")
							_m = ""
						if _p != "":
							class_dic[_c]["p"][_p]=_xml.get_named_attribute_value_safe("type")
							_p = ""
						if _co != "":
							class_dic["@GlobalScope"]["m"][_co]=_xml.get_named_attribute_value_safe("type")
							_co = ""
			if _xml.get_node_type()==_xml.NODE_ELEMENT_END:
				if _xml.get_node_name() == "method" && _m != "":
					_m = ""
				if _xml.get_node_name() == "member" && _p != "":
					_p = ""
				if _xml.get_node_name() == "constructor" && _co != "":
					_co = ""
					

func build_api_dics(path:String)->void:
	var dir:Directory = Directory.new()
	var error:int = dir.open(path)
	if error!=OK:
		print(error_string(error))
		return
		
	dir.list_dir_begin()

	while true:
		var file:String = dir.get_next()
		if file == "":
			break
		if dir.current_is_dir():
			build_api_dics(path+file+"/")
			continue
		elif !file.begins_with(".") && file.ends_with(".gd"):
			api_dic[file.replace(".gd","")]=build_script_dic(load(path+file))

	dir.list_dir_end()


func build_script_dic(script:GDScript)->Dictionary:
	var _scr:GDScript = script
	var _dic:Dictionary = {}
	_dic["c"] = {}
	_dic["e"] = {}
	_dic["m"] = {}
	_dic["p"] = {}
	var _m_list:Array = _scr.get_script_method_list()
	var _e_list:Dictionary = _scr.get_script_constant_map()
	var _p_list:Array = _scr.get_script_property_list()
	var _c_list:Array = []
	for m in _m_list:
		if m["return"]["class_name"] != "":
			_dic["m"][m["name"]] = m["return"]["class_name"]
		else:
			_dic["m"][m["name"]] = type_dic[m["return"]["type"]]
	for p in _p_list:
		if p["class_name"] != "":
			_dic["p"][p["name"]] = p["class_name"]
		else:
			_dic["p"][p["name"]] = type_dic[p["type"]]
	for e in _e_list:
		_dic["e"][e]=_e_list[e]
		if _e_list[e] is Dictionary:
			_c_list.append_array(_e_list[e].keys())
	for c in _c_list:
		if c is String:
			_dic["c"][c]=""
	return _dic


func init_syntax_highlight()->void:
	var _dic:Dictionary = keyword_colors.duplicate()
	keyword_colors["BotAdapter"]=API_COLOR
	for c_name in class_dic:
		if _dic.has(c_name):
			continue
		_dic[c_name] = CLASS_COLOR
	for a_name in api_dic:
		if _dic.has(a_name):
			continue
		_dic[a_name] = API_COLOR
	var chl:CodeHighlighter = CodeHighlighter.new()
	chl.number_color = NUMBER_COLOR
	chl.symbol_color = SYMBOL_COLOR
	chl.function_color = FUNCTION_COLOR
	chl.member_variable_color = MEMBER_VAR_COLOR
	chl.keyword_colors = _dic
	chl.color_regions = color_regions
	syntax_highlighter = chl


func _on_CodeEdit_request_code_completion()->void:
	var _line:String = get_line(get_caret_line()).left(get_caret_column()).strip_edges(true,false)
	var _l_arr:PackedStringArray = _line.split(" ")
	var _latest:String = _l_arr[_l_arr.size()-1]
	if _latest.findn(".")!=-1 and get_word_under_caret() == "":
		var _l_spl:PackedStringArray = _latest.split(".")
		var _type:String = "@"
		for _t in _l_spl:
			_t = _t.split("(")[0]
			if _t.ends_with("\"") or _t.ends_with("'") or _t.begins_with("str("):
				_t = "String"
			elif _t.ends_with("}"):
				_t = "Dictionary"
			elif _t.ends_with("]"):
				_t = "Array"
				
			if class_dic.has(_t) or api_dic.has(_t):
				_type = _t
			if _type == "@":
				var _types:Array[String] = ["@GlobalScope","@GDScript","Node","Plugin"]
				for _tp in _types:
					if class_dic.has(_tp):
						if class_dic[_tp]["m"].has(_t):
							_type = class_dic[_tp]["m"][_t]
						elif class_dic[_tp]["p"].has(_t):
							_type = class_dic[_tp]["p"][_t]
					if api_dic.has(_tp):
						if api_dic[_tp]["m"].has(_t):
							_type = api_dic[_tp]["m"][_t]
			else:
				if class_dic.has(_type):
					if class_dic[_type]["m"].has(_t):
						_type = class_dic[_type]["m"][_t]
					elif class_dic[_type]["p"].has(_t):
						_type = class_dic[_type]["p"][_t]
				if api_dic.has(_type):
					if api_dic[_type]["m"].has(_t):
						_type = api_dic[_type]["m"][_t]
		if (!api_dic.has(_type) and !class_dic.has(_type)) or _type=="Variant":
			
			for _k in kw_keys:
				add_code_completion_option(CodeEdit.KIND_MEMBER,_k,_k+" ",keyword_colors[_k])
			for _a in api_keys:
				if keyword_colors.has(_a):
					continue
				add_code_completion_option(CodeEdit.KIND_CLASS,_a,_a,API_COLOR)
			for _c in class_keys:
				if keyword_colors.has(_c):
					continue
				add_code_completion_option(CodeEdit.KIND_CLASS,_c,_c,CLASS_COLOR)
			
			for _a in api_keys:
				_add_completion_api_dic(_a,true)
			for _c in class_keys:
				if !ClassDB.class_exists(_c):
					_add_completion_class_dic(_c,true)
			_add_completion_class_dic("Node",true)
		
		else:	
			_add_completion_api_dic(_type)
			_add_completion_class_dic(_type)
	else:
		parse_code_text()
		
		for _k in kw_keys:
			add_code_completion_option(CodeEdit.KIND_MEMBER,_k,_k+" ",keyword_colors[_k])
		for _a in api_keys:
			if keyword_colors.has(_a):
				continue
			add_code_completion_option(CodeEdit.KIND_CLASS,_a,_a,API_COLOR)
		for _c in class_keys:
			if keyword_colors.has(_c):
				continue
			add_code_completion_option(CodeEdit.KIND_CLASS,_c,_c,CLASS_COLOR)
	
		var _type:String = "@GlobalScope"
		_add_completion_class_dic(_type)
		_type = "@GDScript"
		_add_completion_class_dic(_type)	
		_type = "Node"
		_add_completion_class_dic(_type)	
		_type = "Plugin"
		_add_completion_api_dic(_type)
		
	update_code_completion_options(false)


func _add_completion_api_dic(_type:String,show_source:bool=false)->void:
	if !api_dic.has(_type):
		return
	var _s_text:String = ""
	if show_source:
		_s_text = " [%s]"%[_type]
	
	var _m_list:Array = api_dic[_type]["m"].keys()
	var _c_list:Array = api_dic[_type]["c"].keys()
	var _e_list:Array = api_dic[_type]["e"].keys()
	
	_m_list.sort()
	_c_list.sort()
	_e_list.sort()
	
	for _m in _m_list:
		if _m.begins_with("@"):
			continue
		add_code_completion_option(CodeEdit.KIND_FUNCTION,_m+"( )"+_s_text,_m+"()",FUNCTION_COLOR)
	for _c in _c_list:
		add_code_completion_option(CodeEdit.KIND_CONSTANT,_c+_s_text,_c,MEMBER_VAR_COLOR)
	for _e in _e_list:
		add_code_completion_option(CodeEdit.KIND_ENUM,_e+_s_text,_e,MEMBER_VAR_COLOR)


func _add_completion_class_dic(_type:String,show_source:bool=false)->void:
	if !class_dic.has(_type):
		return
	var _s_text:String = ""
	if show_source:
		_s_text = " [%s]"%[_type]
		
	var _m_list:Array = class_dic[_type]["m"].keys()
	var _c_list:Array = class_dic[_type]["c"].keys()
	var _p_list:Array = class_dic[_type]["p"].keys()
	var _s_list:Array = class_dic[_type]["s"].keys()
	
	_m_list.sort()
	_c_list.sort()
	_p_list.sort()
	_s_list.sort()
	
	for _m in _m_list:
		if _m.begins_with("@"):
			continue
		add_code_completion_option(CodeEdit.KIND_FUNCTION,_m+"( )"+_s_text,_m+"()",FUNCTION_COLOR)
	for _p in _p_list:
		add_code_completion_option(CodeEdit.KIND_MEMBER,_p+_s_text,_p,MEMBER_VAR_COLOR)
	for _s in _s_list:
		add_code_completion_option(CodeEdit.KIND_SIGNAL,_s+_s_text,_s,MEMBER_VAR_COLOR)
	for _c in _c_list:
		add_code_completion_option(CodeEdit.KIND_CONSTANT,_c+_s_text,_c,MEMBER_VAR_COLOR)


func _on_CodeEdit_text_changed()->void:
	$Timer.start(0.25)


func _on_CodeEdit_caret_changed()->void:
	$Timer.start(0.25)


func parse_code_text()->void:
	var _num:int = get_line_count()
	var _dic:Dictionary = {}
	for n in range(_num):
		var _text:PackedStringArray = get_line(n).strip_edges().split("#")[0].split(" ",false)
		if _text.size() > 0 and _text[0].begins_with("@"):
			_text.remove_at(0)
		if _text.size() > 1:
			match _text[0]:
				"var","const":
					var _word:String = _text[1].split(":")[0].split("=")[0]
					if _word.is_valid_identifier():
						_dic[_word]=MEMBER_VAR_COLOR
				"for":
					var _word:String = _text[1]
					if _word.is_valid_identifier():
						_dic[_word]=MEMBER_VAR_COLOR
				"signal":
					var _word:String = _text[1]
					if _word.is_valid_identifier():
						_dic[_word]=MEMBER_VAR_COLOR
				"enum":
					var _word:String = _text[1].split("{")[0]
					if _word.is_valid_identifier():
						_dic[_word]=MEMBER_VAR_COLOR
				"func":
					var _words:PackedStringArray = _text[1].split("(")
					if !_words.size()>1 and _text.size()>2:
						var _word:String = _text[1]
						if _word.is_valid_identifier():
							_dic[_word]=FUNCTION_COLOR
						var _args:PackedStringArray = _text[2].replace(" ","").strip_edges().rstrip("):").lstrip("(").split(",")
						for _a in _args:
							_a = _a.split(":")[0].split("=")[0]
							if _a.is_valid_identifier():
								_dic[_a]=MEMBER_VAR_COLOR
					elif _words.size()>1:
						var _word:String = _words[0]
						if _word.is_valid_identifier():
							_dic[_word]=FUNCTION_COLOR
						var _args:PackedStringArray = _words[1].replace(" ","").strip_edges().rstrip("):").split(",")
						for _a in _args:
							_a = _a.split(":")[0].split("=")[0]
							if _a.is_valid_identifier():
								_dic[_a]=MEMBER_VAR_COLOR
	for _w in _dic:
		var _dw:String = _w
		var _iw:String = _w
		if _dic[_w]==FUNCTION_COLOR:
			_dw = _w+"( )"
			_iw = _w+"()"
		for _o in get_code_completion_options():
			if _o["display_text"] == _dw:
				return
		add_code_completion_option(CodeEdit.KIND_MEMBER,_dw,_iw,_dic[_w])


func check_error()->void:
	for _l in range(get_line_count()):
		if get_line_background_color(_l) != Color(0, 0, 0, 0):
			set_line_background_color(_l,Color(0, 0, 0, 0))
		else:
			continue
	error_lines.clear()
	var _f:File = File.new()
	_f.open("user://logs/rainybot.log",File.READ)
	var curr_text:String = _f.get_as_text()
	_f.close()
	var _scr:GDScript = GDScript.new()
	_scr.source_code = text
	if _scr.reload() != OK:
		_f.open("user://logs/rainybot.log",File.READ)
		var _text:String = _f.get_as_text()
		_f.close()
		GlobalManager.last_log_text = _text
		var _err:PackedStringArray = _text.replacen(curr_text,"").split("\n")
		for _l in _err:
			if _l.findn("built-in")!=-1:
				var _sl:PackedStringArray = _l.split(" - ")
				var _num:int = clampi(abs(_sl[0].to_int())-1,0,get_line_count()-1)
				var _error:String = _sl[1]
				set_line_background_color(_num,Color(1,0.47,0.42,0.3))
				error_lines[_num]=_error


func _on_Timer_timeout()->void:
	if last_text != text:
		last_text = text
		if !GlobalManager.is_running_from_editor():
			check_error()
		if (is_in_comment(get_caret_line(),get_caret_column())==-1) and (is_in_string(get_caret_line(),get_caret_column())==-1):
			request_code_completion()
	emit_signal("update_finished")


func _gui_input(event:InputEvent)->void:
	if event.is_action_pressed("toggle_comment"):
		# If no selection is active, toggle comment on the line the cursor is currently on.
		var from:int = get_selection_from_line() if has_selection() else get_caret_line()
		var to:int = get_selection_to_line() if has_selection() else get_caret_line()
		for line in range(from, to + 1):
			if not get_line(line).begins_with("#"):
				# Code is already commented out at the beginning of the line. Uncomment it.
				set_line(line, "#%s" % get_line(line))
			else:
				# Code isn't commented out at the beginning of the line. Comment it.
				set_line(line, get_line(line).substr(1))
