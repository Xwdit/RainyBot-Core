extends CodeEdit


signal update_finished


var plugin_editor:PluginEditor = null
var func_line_dic:Dictionary = {}
var error_lines:Dictionary = {}
var last_text:String = ""
var helper:GDScriptHelper = GDScriptHelper.new()


func _ready()->void:
	grab_focus()
	set_caret_line(0)
	set_caret_column(0)
	GuiManager.init_delimiters(self)
	syntax_highlighter = GuiManager.syntax_highlighter


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


func _on_CodeEdit_request_code_completion()->void:
	var src_path:String = plugin_editor.loaded_ins.get_script().resource_path if is_instance_valid(plugin_editor.loaded_ins) else ProjectSettings.localize_path(plugin_editor.loaded_path)
	var error:int = helper.set_completion_code(get_text_for_code_completion(),src_path,plugin_editor.loaded_ins)
	if error == OK:
		if helper.has_completion_options():
			var list:Array[Dictionary] = helper.get_completion_options()
			for o in list:
				var font_color:Color = Color.WHITE
				if o.display_text.begins_with("\"") or o.display_text.begins_with("'") or o.display_text.begins_with("/"):
					font_color = GuiManager.STRING_COLOR
				elif o.display_text.begins_with("#"):
					font_color = GuiManager.COMMENT_COLOR
				add_code_completion_option(o.type,o.display_text,o.insert_text,font_color,_get_complete_icon(o.type, o.display_text),o.default_value)
			for c in GuiManager.api_keys:
				add_code_completion_option(CodeEdit.KIND_CLASS,c+" (RainyBot)",c,Color.WHITE,get_theme_icon("PluginScript","EditorIcons"))
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
	var src_path:String = plugin_editor.loaded_ins.get_script().resource_path if is_instance_valid(plugin_editor.loaded_ins) else ProjectSettings.localize_path(plugin_editor.loaded_path)
	var success:bool = helper.set_validate_code(text,src_path)
	if success:
		if helper.has_functions():
			func_line_dic = helper.get_functions()
	else:
		if helper.has_errors():
			var e_list:Array[Dictionary] = helper.get_errors()
			for e in e_list:
				var _line:int = e.line if e.line < get_line_count() else get_line_count()-1
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


func _on_code_edit_symbol_validate(symbol:String)->void:
	var src_path:String = plugin_editor.loaded_ins.get_script().resource_path if is_instance_valid(plugin_editor.loaded_ins) else ProjectSettings.localize_path(plugin_editor.loaded_path)
	var lookup_result:Dictionary = helper.lookup_code(get_text_for_symbol_lookup(),symbol,src_path,plugin_editor.loaded_ins)
	if !lookup_result.is_empty() or GuiManager.class_dic.has(symbol) or GuiManager.api_dic.has(symbol) or func_line_dic.has(symbol):
		set_symbol_lookup_word_as_valid(true)


func _on_code_edit_symbol_lookup(symbol:String, line:int, column:int)->void:
	var src_path:String = plugin_editor.loaded_ins.get_script().resource_path if is_instance_valid(plugin_editor.loaded_ins) else ProjectSettings.localize_path(plugin_editor.loaded_path)
	var lookup_result:Dictionary = helper.lookup_code(get_text_for_symbol_lookup(),symbol,src_path,plugin_editor.loaded_ins)
	
	if !lookup_result.is_empty():
		var c_name:String = lookup_result["class_name"]
		var s_path:String = lookup_result["class_path"]
		var type:int = lookup_result["type"]
		var type_name:Array[String] = ["","","#constants","#properties","#methods","#signals","#enumerations","","#annotations",""]
		if GuiManager.class_dic.has(c_name):
			OS.shell_open("https://docs.godotengine.org/en/latest/classes/class_%s.html%s" % [c_name.to_lower(),type_name[type]])
			return
		elif GuiManager.api_dic.has(s_path.get_basename().get_file()):
			GuiManager.open_doc_viewer(s_path.get_basename().get_file(),symbol)
			return
		
	if GuiManager.class_dic.has(symbol):
		OS.shell_open("https://docs.godotengine.org/en/latest/classes/class_%s.html" % symbol.to_lower())
	elif GuiManager.api_dic.has(symbol):
		GuiManager.open_doc_viewer(symbol)
	elif func_line_dic.has(symbol):
		var new_line:int = func_line_dic[symbol]
		set_caret_line(new_line)
		center_viewport_to_caret()
