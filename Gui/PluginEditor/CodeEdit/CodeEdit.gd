extends CodeEdit


const CLASS_COLOR = Color(0.25,1,0.75)
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

var color_regions = {
	"#":COMMENT_COLOR,
	"\" \"":STRING_COLOR,
	"$ .":NODE_PATH_COLOR,
	"@":ANNOTATION_COLOR
}


func _ready():
	var menu = get_menu()
	init_syntax_highlight()
	

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
	keyword_colors["BotAdapter"]=CLASS_COLOR
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
			keyword_colors[file.replace(".gd","")]=CLASS_COLOR

	dir.list_dir_end()
