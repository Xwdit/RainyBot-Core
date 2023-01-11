extends Node


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
const KEYWORD_COLORS:Dictionary = {
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
const TYPE_DIC:Dictionary = {
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
const COLOR_REGIONS:Dictionary = {
	"#":COMMENT_COLOR,
	"\" \"":STRING_COLOR,
	"$ .":NODE_PATH_COLOR,
	"@":ANNOTATION_COLOR
}
const CORE_API_PATH:String = "res://libs/core/api/"
const ADAPTER_API_PATH:String = "res://libs/adapters/mirai/api/"
const CLASS_DOC_PATH:String = "res://libs/gui/resources/class_docs/"

var syntax_highlighter:CodeHighlighter

var api_dic:Dictionary = {}
var class_dic:Dictionary = {}
var kw_keys:Array = []
var api_keys:Array = []
var class_keys:Array = []

var _confirm_popup:PackedScene = load("res://libs/gui/modules/popups/confirm_popup/confirm_popup.tscn")
var _accept_popup:PackedScene = load("res://libs/gui/modules/popups/accept_popup/accept_popup.tscn")
var _editor:PackedScene = load("res://libs/gui/interfaces/plugin_editor/modules/editor_window/plugin_editor_window.tscn")

var scene_editor_pid:int = -1

var sysout_disabled:bool = false


func _ready() -> void:
	_init_lookup_dics()
	_init_syntax_highlight()
	_init_keys_arr()

	
func open_plugin_editor(path:String)->int:
	if !FileAccess.file_exists(path) or !path.get_file().ends_with(".gd"):
		console_print_error("插件文件不存在或文件格式错误!")
		return ERR_CANT_OPEN
	for child in get_children():
		if str(child.name).begins_with("PluginEditorWindow"):
			var unsaved_dic:Dictionary = child.plugin_editor_node.unsaved_dic
			for f in unsaved_dic:
				if path.get_file().to_lower() == f.get_file().to_lower():
					console_print_error("此文件当前正在编辑中，请勿重复打开相同的文件! | 文件:"+path.get_file())
					return ERR_ALREADY_IN_USE
	console_print_warning("正在启动插件编辑器，请稍候..... | 文件:"+path.get_file())
	await get_tree().physics_frame
	var _ins:Window = _editor.instantiate()
	_ins.name = "PluginEditorWindow"
	add_child(_ins,true)
	_ins.load_script(path)
	return OK
	
	
func open_scene_editor()->void:
	if scene_editor_pid != -1 and OS.is_process_running(scene_editor_pid):
		console_print_error("场景编辑器当前正在运行中，请不要同时启动多个场景编辑器进程!")
	else:
		console_print_warning("正在启动场景编辑器，请稍候..... | 版本: Godot-%s"% Engine.get_version_info().string)
		scene_editor_pid = OS.create_instance(["--editor"])
	
	
func open_doc_viewer(doc_name:String,member:String="")->void:
	get_tree().call_group("MainGui","load_doc",doc_name,member)
	

func console_print_text(text,sysout:bool=true)->void:
	if sysout_disabled and sysout:
		return
	get_tree().call_group("Console","add_newline_with_time",text)
	
	
func console_print_error(text,sysout:bool=true)->void:
	if sysout_disabled and sysout:
		return
	get_tree().call_group("Console","add_error",text)
	
	
func console_print_warning(text,sysout:bool=true)->void:
	if sysout_disabled and sysout:
		return
	get_tree().call_group("Console","add_warning",text)
	

func console_print_success(text,sysout:bool=true)->void:
	if sysout_disabled and sysout:
		return
	get_tree().call_group("Console","add_success",text)
	
	
func console_save_log(close:bool=false)->void:
	get_tree().call_group("Console","save_log",close)
	
	
func console_init_log(save_current:bool=false)->void:
	get_tree().call_group("Console","init_log",save_current)


func popup_notification(text:String,title:String="提示")->bool:
	var _popup:AcceptDialog = _accept_popup.instantiate()
	add_child(_popup)
	_popup.title = title
	_popup.dialog_text = text
	_popup.get_label().horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_popup.get_label().vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_popup.popup_centered()
	return await _popup.closed
	
	
func popup_confirm(text:String,title:String="请确认")->bool:
	var _popup:ConfirmationDialog = _confirm_popup.instantiate()
	add_child(_popup)
	_popup.title = title
	_popup.dialog_text = text
	_popup.get_label().horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_popup.get_label().vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_popup.popup_centered()
	return await _popup.closed


func _init_keys_arr()->void:
	kw_keys = KEYWORD_COLORS.keys()
	api_keys = api_dic.keys()
	class_keys = class_dic.keys()
	kw_keys.sort()
	api_keys.sort()
	class_keys.sort()


func _init_lookup_dics()->void:
	api_dic["BotAdapter"]= _build_script_dic(BotAdapter.get_script())
	_build_class_dics(CLASS_DOC_PATH)
	_build_api_dics(CORE_API_PATH)
	_build_api_dics(ADAPTER_API_PATH)
	

func _build_class_dics(path:String)->void:
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
					

func _build_api_dics(path:String)->void:
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
			_build_api_dics(path+file+"/")
			continue
		elif !file.begins_with(".") && file.ends_with(".gd"):
			api_dic[file.replace(".gd","")]=_build_script_dic(load(path+file))

	dir.list_dir_end()


func _build_script_dic(script:GDScript)->Dictionary:
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
			_dic["m"][m["name"]] = TYPE_DIC[m["return"]["type"]]
	for p in _p_list:
		if p["class_name"] != "":
			_dic["p"][p["name"]] = p["class_name"]
		else:
			_dic["p"][p["name"]] = TYPE_DIC[p["type"]]
	for e in _e_list:
		_dic["e"][e]=_e_list[e]
		if _e_list[e] is Dictionary:
			_c_list.append_array(_e_list[e].keys())
	for c in _c_list:
		if c is String:
			_dic["c"][c]=""
	return _dic


func _init_syntax_highlight()->void:
	var _dic:Dictionary = KEYWORD_COLORS.duplicate()
	_dic["BotAdapter"]=API_COLOR
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
	chl.color_regions = COLOR_REGIONS
	syntax_highlighter = chl


func init_delimiters(code_edit:CodeEdit,no_completion:bool=false)->void:
	code_edit.indent_automatic = true
	
	code_edit.clear_string_delimiters()
	code_edit.add_string_delimiter("'","'")
	code_edit.add_string_delimiter("\"","\"")
	code_edit.add_string_delimiter("\"\"\"","\"\"\"")
	
	code_edit.clear_comment_delimiters()
	code_edit.add_comment_delimiter("#","",true)
	
	code_edit.auto_brace_completion_enabled = true
	code_edit.auto_brace_completion_highlight_matching = true
	if !code_edit.has_auto_brace_completion_open_key("\"\"\""):
		code_edit.add_auto_brace_completion_pair("\"\"\"","\"\"\"")
		
	if !no_completion:
		code_edit.code_completion_enabled = true
		code_edit.code_completion_prefixes = [".",",","(","=","$","@","\"","\'"]
