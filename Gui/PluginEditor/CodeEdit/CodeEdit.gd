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
}

var type_dic = {
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
	TYPE_RAW_ARRAY:"PackedByteArray",
	TYPE_INT32_ARRAY:"PackedInt32Array",
	TYPE_INT64_ARRAY:"PackedInt64Array",
	TYPE_FLOAT32_ARRAY:"PackedFloat32Array",
	TYPE_FLOAT64_ARRAY:"PackedFloat64Array",
	TYPE_STRING_ARRAY:"PackedStringArray",
	TYPE_VECTOR2_ARRAY:"PackedVector2Array",
	TYPE_VECTOR3_ARRAY:"PackedVector3Array",
	TYPE_COLOR_ARRAY:"PackedColorArray"
}

var color_regions = {
	"#":COMMENT_COLOR,
	"\" \"":STRING_COLOR,
	"$ .":NODE_PATH_COLOR,
	"@":ANNOTATION_COLOR
}

var api_dic = {}
var class_dic = {}
var kw_keys = []
var api_keys = []
var class_keys = []


func _ready():
	init_auto_complete()
	init_syntax_highlight()
	init_keys_arr()
	

func init_keys_arr():
	kw_keys = keyword_colors.keys()
	api_keys = api_dic.keys()
	class_keys = class_dic.keys()
	kw_keys.sort()
	api_keys.sort()
	class_keys.sort()


func init_auto_complete():
	api_dic["BotAdapter"]= build_script_dic(BotAdapter.get_script())
	add_comment_delimiter("#","",true)
	build_class_dics()
	build_api_dics("res://Core/API/")
	build_api_dics("res://Adapters/Mirai/API/")
	


func build_class_dics():
	var dir = Directory.new()
	dir.open("res://Gui/PluginEditor/CodeEdit/ClassDocs/")
	var files = dir.get_files()
	for f in files:
		var _c = f.replacen(".xml","")
		if !class_dic.has(_c):
			class_dic[_c]={"m":{},"p":{},"c":{},"s":{}}
		var _xml = XMLParser.new()
		_xml.open("res://Gui/PluginEditor/CodeEdit/ClassDocs/"+f)
		var _m = ""
		var _p = ""
		while _xml.read() == OK:
			if _xml.get_node_type() == _xml.NODE_ELEMENT:
				var _name = _xml.get_named_attribute_value_safe("name")
				match _xml.get_node_name():
					"method":
						_m = _name
						class_dic[_c]["m"][_name]=""
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
			if _xml.get_node_type()==_xml.NODE_ELEMENT_END:
				if _xml.get_node_name() == "method" && _m != "":
					_m = ""
				if _xml.get_node_name() == "member" && _p != "":
					_p = ""
					

func build_api_dics(path:String):
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
			build_api_dics(path+file+"/")
			continue
		elif !file.begins_with(".") && file.ends_with(".gd"):
			api_dic[file.replace(".gd","")]=build_script_dic(load(path+file))

	dir.list_dir_end()


func build_script_dic(script)->Dictionary:
	var _scr:GDScript = script
	var _dic = {}
	_dic["c"] = {}
	_dic["e"] = {}
	_dic["m"] = {}
	_dic["p"] = {}
	var _m_list = _scr.get_script_method_list()
	var _e_list = _scr.get_script_constant_map()
	var _p_list = _scr.get_script_property_list()
	var _c_list = []
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


func init_syntax_highlight():
	var _dic = keyword_colors.duplicate()
	keyword_colors["BotAdapter"]=API_COLOR
	for c_name in class_dic:
		_dic[c_name] = CLASS_COLOR
	for a_name in api_dic:
		_dic[a_name] = API_COLOR
	var chl = CodeHighlighter.new()
	chl.number_color = NUMBER_COLOR
	chl.symbol_color = SYMBOL_COLOR
	chl.function_color = FUNCTION_COLOR
	chl.member_variable_color = MEMBER_VAR_COLOR
	chl.keyword_colors = _dic
	chl.color_regions = color_regions
	syntax_highlighter = chl


func _on_CodeEdit_request_code_completion():
	var _line = get_line(get_caret_line()).left(get_caret_column()).strip_edges(true,false)
	var _l_arr = _line.split(" ")
	var _latest = _l_arr[_l_arr.size()-1]
	if _latest.findn(".")!=-1 and get_word_under_caret() == "":
		var _l_spl = _latest.split(".")
		var _type = "@"
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
				var _types = ["@GlobalScope","@GDScript","Node","Plugin"]
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
		print(_type)
		if (!api_dic.has(_type) and !class_dic.has(_type)) or _type=="Variant":
			for _a in api_keys:
				_add_completion_api_dic(_a,true)
			for _c in class_keys:
				if !ClassDB.class_exists(_c):
					_add_completion_class_dic(_c,true)
			_add_completion_class_dic("Node",true)
			for _k in kw_keys:
				add_code_completion_option(CodeEdit.KIND_MEMBER,_k,_k,keyword_colors[_k])
			for _a in api_keys:
				add_code_completion_option(CodeEdit.KIND_CLASS,_a,_a,API_COLOR)
			for _c in class_keys:
				add_code_completion_option(CodeEdit.KIND_CLASS,_c,_c,CLASS_COLOR)
		else:	
			_add_completion_api_dic(_type)
			_add_completion_class_dic(_type)
				
	elif _latest.length() >= 1:
		
		var _type = "@GlobalScope"
		_add_completion_class_dic(_type)
		_type = "@GDScript"
		_add_completion_class_dic(_type)	
		_type = "Node"
		_add_completion_class_dic(_type)	
		_type = "Plugin"
		_add_completion_api_dic(_type)
		
		for _k in kw_keys:
			add_code_completion_option(CodeEdit.KIND_MEMBER,_k,_k,keyword_colors[_k])
		for _a in api_keys:
			add_code_completion_option(CodeEdit.KIND_CLASS,_a,_a,API_COLOR)
		for _c in class_keys:
			add_code_completion_option(CodeEdit.KIND_CLASS,_c,_c,CLASS_COLOR)
	update_code_completion_options(false)


func _add_completion_api_dic(_type:String,show_source:bool=false):
	if !api_dic.has(_type):
		return
	var _s_text = ""
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


func _add_completion_class_dic(_type:String,show_source:bool=false):
	if !class_dic.has(_type):
		return
	var _s_text = ""
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


func _on_CodeEdit_text_changed():
	if (is_in_comment(get_caret_line(),get_caret_column())==-1) and (is_in_string(get_caret_line(),get_caret_column())==-1):
		request_code_completion()
