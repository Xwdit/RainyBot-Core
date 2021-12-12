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
	"Rect2i":CLASS_COLOR,
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

var api_dic = {}

var class_dic = {}


func _ready():
	init_syntax_highlight()
	init_auto_complete()
	
	
func init_auto_complete():
	add_comment_delimiter("#","",true)
	build_doc_dics()
	var _scr:GDScript = BotAdapter.get_script()
	api_dic["BotAdapter"]= build_script_dic(_scr)
	build_api_dics("res://Core/API/")
	build_api_dics("res://Adapters/Mirai/API/")


func build_doc_dics():
	var dir = Directory.new()
	dir.open("res://Gui/PluginEditor/CodeEdit/ClassDocs/")
	var files = dir.get_files()
	for f in files:
		var _c = f.replacen(".xml","")
		if !class_dic.has(_c):
			class_dic[_c]={"m":[],"p":[],"c":[]}
		var _xml = XMLParser.new()
		_xml.open("res://Gui/PluginEditor/CodeEdit/ClassDocs/"+f)
		while _xml.read() == OK:
			if _xml.get_node_type() == _xml.NODE_ELEMENT:
				var _name = _xml.get_named_attribute_value_safe("name")
				match _xml.get_node_name():
					"method":
						class_dic[_c]["m"].append(_name)
					"member":
						class_dic[_c]["p"].append(_name)
					"constant":
						class_dic[_c]["c"].append(_name)


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
	_dic["c"] = []
	_dic["e"] = []
	_dic["m"] = []
	_dic["p"] = []
	var _m_list = _scr.get_script_method_list()
	var _e_list = _scr.get_script_constant_map()
	var _p_list = _scr.get_script_property_list()
	var _c_list = []
	for m in _m_list:
		_dic["m"].append(m["name"])
	for p in _p_list:
		_dic["p"].append(p["name"])
	for e in _e_list:
		_dic["e"].append(e)
		if _e_list[e] is Dictionary:
			_c_list.append_array(_e_list[e].keys())
	for c in _c_list:
		if c is String:
			_dic["c"].append(c)
	return _dic


func init_syntax_highlight():
	var class_arr = ClassDB.get_class_list()
	for c_name in class_arr:
		keyword_colors[c_name] = CLASS_COLOR
	keyword_colors["BotAdapter"]=API_COLOR
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


func _on_CodeEdit_request_code_completion():
	var _line = get_line(get_caret_line()).left(get_caret_column()).strip_edges(true,false)
	var _l_arr = _line.split(" ")
	var _latest = _l_arr[_l_arr.size()-1]
	if _latest.findn(".")!=-1 and get_word_under_caret() == "":
		var _l_spl = _latest.split(".")
		var _cls = _l_spl[0]
		
		if _cls.ends_with("\"") or _cls.ends_with("'") or _cls.begins_with("str("):
			_cls = "String"
		elif _cls.ends_with("}"):
			_cls = "Dictionary"
		elif _cls.ends_with("]"):
			_cls = "Array"
		
		if _cls == "Plugin" and _l_spl.size() <= 2:
			var _m_list = api_dic[_cls]["m"]
			var _p_vm_list = ["_on_init","_on_connect","_on_load","_on_ready","_on_process","_on_disconnect","_on_unload"]
			for m in _m_list:
				if !m.begins_with("_") and !m.begins_with("@"):
					add_code_completion_option(CodeEdit.KIND_FUNCTION,m+"( )",m+"()",FUNCTION_COLOR)
			for vm in _p_vm_list:
				add_code_completion_option(CodeEdit.KIND_FUNCTION,vm+"( )",vm+"()",FUNCTION_COLOR)
		
		elif api_dic.has(_cls) and _l_spl.size() <= 2:
			var _m_list = api_dic[_cls]["m"]
			var _e_list = api_dic[_cls]["e"]
			for m in _m_list:
				if !m.begins_with("@"):
					add_code_completion_option(CodeEdit.KIND_FUNCTION,m+"( )",m+"()",FUNCTION_COLOR)
			for e in _e_list:
				add_code_completion_option(CodeEdit.KIND_MEMBER,e,e,MEMBER_VAR_COLOR)
		
		elif class_dic.has(_cls) and _l_spl.size() <= 2:
			var _m_list = class_dic[_cls]["m"]
			var _c_list = class_dic[_cls]["c"]
			var _p_list = class_dic[_cls]["p"]
			for m in _m_list:
				add_code_completion_option(CodeEdit.KIND_FUNCTION,m+"( )",m+"()",FUNCTION_COLOR)
			for c in _c_list:
				add_code_completion_option(CodeEdit.KIND_MEMBER,c,c,MEMBER_VAR_COLOR)
			for p in _p_list:
				add_code_completion_option(CodeEdit.KIND_MEMBER,p,p,MEMBER_VAR_COLOR)
		
		elif ClassDB.class_exists(_cls) and _l_spl.size() <= 2:
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
			var _sort = func(_a,_b):return _b.length()>_a.length()
			var _keys = api_dic.keys()
			_keys.sort_custom(_sort)
			
			for _k in _keys:
				var _m_list = api_dic[_k]["m"]
				var _e_list = api_dic[_k]["e"]
				var _c_list = api_dic[_k]["c"]
				for m in _m_list:
					if !m.begins_with("@") and (_k != "Plugin" or !m.begins_with("_")):
						add_code_completion_option(CodeEdit.KIND_FUNCTION,m+"( ) [%s]"%["BotAPI: "+_k],m+"()",FUNCTION_COLOR)
				for e in _e_list:
					add_code_completion_option(CodeEdit.KIND_MEMBER,e+" [%s]"%["BotAPI: "+_k],e,MEMBER_VAR_COLOR)
				for c in _c_list:
					add_code_completion_option(CodeEdit.KIND_MEMBER,c+" [%s]"%["BotAPI: "+_k],c,MEMBER_VAR_COLOR)
			
			for _cl in class_dic:
				var _m_list = class_dic[_cl]["m"]
				var _c_list = class_dic[_cl]["c"]
				var _p_list = class_dic[_cl]["p"]
				for m in _m_list:
					add_code_completion_option(CodeEdit.KIND_FUNCTION,m+"( ) [%s]"%["GodotAPI: "+_cl],m+"()",FUNCTION_COLOR)
				for c in _c_list:
					add_code_completion_option(CodeEdit.KIND_MEMBER,c+" [%s]"%["GodotAPI: "+_cl],c,MEMBER_VAR_COLOR)
				for p in _p_list:
					add_code_completion_option(CodeEdit.KIND_MEMBER,p+" [%s]"%["GodotAPI: "+_cl],p,MEMBER_VAR_COLOR)
			
			var _kw = keyword_colors
			var _p_vm_list = ["_on_init","_on_connect","_on_load","_on_ready","_on_process","_on_disconnect","_on_unload"]
			var _kw_keys = _kw.keys()
			_kw_keys.sort_custom(_sort)
			for k in _kw_keys:
				add_code_completion_option(CodeEdit.KIND_CLASS,k,k,_kw[k])
			for vm in _p_vm_list:
				add_code_completion_option(CodeEdit.KIND_FUNCTION,vm+"( ) [BotAPI: Plugin]",vm+"()",FUNCTION_COLOR)
		
		update_code_completion_options(false)
	
	elif _latest.length() > 0:
		var _kw = keyword_colors
		var _m_list = api_dic["Plugin"]["m"]
		var _p_vm_list = ["_on_init","_on_connect","_on_load","_on_ready","_on_process","_on_disconnect","_on_unload"]
		var _kw_keys = _kw.keys()
		var _sort = func(_a,_b):return _b.length()>_a.length()
		_kw_keys.sort_custom(_sort)
		
		for k in _kw_keys:
			add_code_completion_option(CodeEdit.KIND_CLASS,k,k,_kw[k])
		for m in _m_list:
			if !m.begins_with("_") and !m.begins_with("@"):
				add_code_completion_option(CodeEdit.KIND_FUNCTION,m+"( )",m+"()",FUNCTION_COLOR)
		for vm in _p_vm_list:
			add_code_completion_option(CodeEdit.KIND_FUNCTION,vm+"( )",vm+"()",FUNCTION_COLOR)
		for _cl in class_dic:
			if !_cl.begins_with("@"):
				continue
			_m_list = class_dic[_cl]["m"]
			var _c_list = class_dic[_cl]["c"]
			var _p_list = class_dic[_cl]["p"]
			for m in _m_list:
				add_code_completion_option(CodeEdit.KIND_FUNCTION,m+"( )",m+"()",FUNCTION_COLOR)
			for c in _c_list:
				add_code_completion_option(CodeEdit.KIND_MEMBER,c,c,MEMBER_VAR_COLOR)
			for p in _p_list:
				add_code_completion_option(CodeEdit.KIND_MEMBER,p,p,MEMBER_VAR_COLOR)
		
		update_code_completion_options(false)
	
	else:
		cancel_code_completion()


func _on_CodeEdit_text_changed():
	if (is_in_comment(get_caret_line(),get_caret_column())==-1) and (is_in_string(get_caret_line(),get_caret_column())==-1):
		request_code_completion()
