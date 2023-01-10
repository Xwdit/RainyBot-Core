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

var plugin_editor:PluginEditor = null

var api_dic:Dictionary = {}
var class_dic:Dictionary = {}
var kw_keys:Array = []
var api_keys:Array = []
var class_keys:Array = []

var func_line_dic:Dictionary = {}

var error_lines:Dictionary = {}
var last_text:String = ""


func _ready()->void:
	grab_focus()
	set_caret_line(0)
	set_caret_column(0)
	init_delimiters()
	init_lookup_dics()
	init_syntax_highlight()
	init_keys_arr()


func init_delimiters()->void:
	code_completion_enabled = true
	code_completion_prefixes = [".",",","(","=","$","@","\"","\'"]
	
	indent_automatic = true
	
	clear_comment_delimiters()
	add_comment_delimiter("#","",true)
	
	clear_string_delimiters()
	add_string_delimiter("'","'")
	add_string_delimiter("\"","\"")
	add_string_delimiter("\"\"\"","\"\"\"")
	
	auto_brace_completion_enabled = true
	auto_brace_completion_highlight_matching = true
	if !has_auto_brace_completion_open_key("\"\"\""):
		add_auto_brace_completion_pair("\"\"\"","\"\"\"")


func init_keys_arr()->void:
	kw_keys = keyword_colors.keys()
	api_keys = api_dic.keys()
	class_keys = class_dic.keys()
	kw_keys.sort()
	api_keys.sort()
	class_keys.sort()


func init_lookup_dics()->void:
	api_dic["BotAdapter"]= build_script_dic(BotAdapter.get_script())
	build_class_dics(class_doc_path)
	build_api_dics(core_api_path)
	build_api_dics(adapter_api_path)
	

func build_class_dics(path:String)->void:
	var dir:DirAccess = DirAccess.open(path)
	var files:PackedStringArray = dir.get_files() if dir else []
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
	var dir:DirAccess = DirAccess.open(path)
	if !dir:
		print(error_string(DirAccess.get_open_error()))
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
	var helper:GDScriptHelper = GDScriptHelper.new()
	var error:int = helper.set_completion_code(get_text_for_code_completion())
	if error == OK:
		if helper.has_completion_options():
			var list:Array[Dictionary] = helper.get_completion_options()
			for o in list:
				add_code_completion_option(o.type,o.display_text,o.insert_text,Color.WHITE,_get_complete_icon(o.type, o.display_text),o.default_value)
			for c in api_keys:
				add_code_completion_option(CodeEdit.KIND_CLASS,c,c,Color.WHITE,get_theme_icon("PluginScript","EditorIcons"))
			update_code_completion_options(helper.is_completion_forced())
		set_code_hint(helper.get_completion_hint())


func _on_CodeEdit_text_changed()->void:
	$Timer.start(0.25)


func _on_CodeEdit_caret_changed()->void:
	$Timer.start(0.25)


func _get_complete_icon(type:int,content:String="")->Texture2D:
	match type:
		KIND_CLASS:
			if !content.is_empty() and has_theme_icon(content, "EditorIcons"):
				return get_theme_icon(content, "EditorIcons")
			return get_theme_icon("Object", "EditorIcons")
		KIND_ENUM:
			return get_theme_icon("Enum", "EditorIcons")
		KIND_FILE_PATH:
			return get_theme_icon("File", "EditorIcons")
		KIND_NODE_PATH:
			return get_theme_icon("NodePath", "EditorIcons")
		KIND_VARIABLE:
			return get_theme_icon("Variant", "EditorIcons")
		KIND_CONSTANT:
			return get_theme_icon("MemberConstant", "EditorIcons")
		KIND_MEMBER:
			return get_theme_icon("MemberProperty", "EditorIcons")
		KIND_SIGNAL:
			return get_theme_icon("MemberSignal", "EditorIcons")
		KIND_FUNCTION:
			return get_theme_icon("MemberMethod", "EditorIcons")
		KIND_PLAIN_TEXT:
			return get_theme_icon("BoxMesh", "EditorIcons")
		_:
			return get_theme_icon("String", "EditorIcons")


func parse_code_text()->void:
	for _l in range(get_line_count()):
		if get_line_background_color(_l) != Color(0, 0, 0, 0):
			set_line_background_color(_l,Color(0, 0, 0, 0))
		else:
			continue
	error_lines.clear()
	func_line_dic.clear()
	var helper:GDScriptHelper = GDScriptHelper.new()
	var success:bool = helper.set_source(text)
	if success:
		if helper.has_functions():
			func_line_dic = helper.get_functions()
	else:
		if helper.has_errors():
			var e_list:Array[Dictionary] = helper.get_errors()
			for e in e_list:
				var _line:int = e.line
				var _column:int = e.column
				var _error:String = e.message
				set_line_background_color(_line,Color(1,0.47,0.42,0.3))
				error_lines[_line]=_error


func _on_Timer_timeout()->void:
	if last_text != text:
		last_text = text
		parse_code_text()
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


func _on_code_edit_symbol_validate(symbol:String)->void:
	if class_dic.has(symbol) or api_dic.has(symbol) or func_line_dic.has(symbol):
		set_symbol_lookup_word_as_valid(true)


func _on_code_edit_symbol_lookup(symbol:String, line:int, column:int)->void:
	if class_dic.has(symbol):
		OS.shell_open("https://docs.godotengine.org/en/latest/classes/class_%s.html" % symbol.to_lower())
	elif api_dic.has(symbol):
		OS.shell_open("https://docs.rainybot.dev/api/%s"% symbol.to_lower())
	elif func_line_dic.has(symbol):
		var new_line:int = func_line_dic[symbol]
		set_caret_line(new_line)
		center_viewport_to_caret()
