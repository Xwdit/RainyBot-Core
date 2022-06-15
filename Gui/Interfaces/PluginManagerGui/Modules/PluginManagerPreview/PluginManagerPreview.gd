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

var color_regions = {
	"#":COMMENT_COLOR,
	"\" \"":STRING_COLOR,
	"$ .":NODE_PATH_COLOR,
	"@":ANNOTATION_COLOR
}

var core_api_path = "res://Core/API/"
var adapter_api_path = "res://Adapters/Mirai/API/"
var class_doc_path = "res://Gui/Interfaces/PluginEditor/Modules/CodeEdit/ClassDocs/"


var api_dic = {}
var class_dic = {}
var kw_keys = []
var api_keys = []
var class_keys = []

var error_lines = {}
var last_text = ""


func _ready():
	set_caret_line(0)
	set_caret_column(0)
	build_highlight_dics()
	init_syntax_highlight()


func load_script(path:String)->int:
	var scr:GDScript = PluginManager.load_plugin_script(PluginManager.plugin_path+path)
	if is_instance_valid(scr):
		text = scr.source_code
		return OK
	else:
		Console.print_error("插件文件加载时出现错误，请检查文件权限是否正确")
		return ERR_CANT_OPEN


func build_highlight_dics():
	api_dic["BotAdapter"]= build_script_dic(BotAdapter.get_script())
	add_comment_delimiter("#","",true)
	build_class_dics(class_doc_path)
	build_api_dics(core_api_path)
	build_api_dics(adapter_api_path)
	

func build_class_dics(path:String):
	var dir = Directory.new()
	dir.open(path)
	var files = dir.get_files()
	for f in files:
		var _c = f.replacen(".xml","")
		if !class_dic.has(_c):
			class_dic[_c]={"m":{},"p":{},"c":{},"s":{}}
		var _xml = XMLParser.new()
		_xml.open(path+f)
		var _m = ""
		var _p = ""
		var _co = ""
		while _xml.read() == OK:
			if _xml.get_node_type() == _xml.NODE_ELEMENT:
				var _name = _xml.get_named_attribute_value_safe("name")
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


func build_script_dic(script:GDScript)->Dictionary:
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
		if _dic.has(c_name):
			continue
		_dic[c_name] = CLASS_COLOR
	for a_name in api_dic:
		if _dic.has(a_name):
			continue
		_dic[a_name] = API_COLOR
	var chl = CodeHighlighter.new()
	chl.number_color = NUMBER_COLOR
	chl.symbol_color = SYMBOL_COLOR
	chl.function_color = FUNCTION_COLOR
	chl.member_variable_color = MEMBER_VAR_COLOR
	chl.keyword_colors = _dic
	chl.color_regions = color_regions
	syntax_highlighter = chl
