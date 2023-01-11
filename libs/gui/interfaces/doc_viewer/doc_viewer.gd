extends Control


const API_DOC_PATH = "res://libs/gui/resources/api_docs/"
const CATALOG_PATH = API_DOC_PATH+"CATALOG"


@onready var label:RichTextLabel = $HSplitContainer/RichTextLabel
@onready var tree:Tree = $HSplitContainer/VBoxContainer/Tree

var tree_items:Array[TreeItem] = []
var loaded_doc:String = ""


func _ready() -> void:
	load_catalog_tree()


func load_doc(doc_name:String,member:String="")->int:
	var scroll_to_member:Callable = func(_member:String):
		if _member.is_empty():
			label.scroll_to_line(0)
		else:
			var pos:int = label.get_parsed_text().findn(char(0xFFFF)+_member+char(0xFFFF))
			if pos != -1:
				var line:int = label.get_character_line(pos)
				label.scroll_to_line(line)
	if loaded_doc == doc_name:
		scroll_to_member.call(member)
		return OK
	var file:FileAccess = FileAccess.open(API_DOC_PATH+doc_name+".bb",FileAccess.READ)
	if !file:
		loaded_doc = ""
		$HSplitContainer/NoDocLabel.show()
		label.hide()
		return FileAccess.get_open_error()
	$HSplitContainer/NoDocLabel.hide()
	label.show()
	label.text = file.get_as_text()
	file = null
	await label.finished
	if label.text.is_empty():
		return ERR_CANT_OPEN
	loaded_doc = doc_name
	for i in tree_items:
		if i.get_text(0) == doc_name:
			if tree.get_selected() != i:
				tree.set_selected(i,0)
				tree.queue_redraw()
				break
	scroll_to_member.call(member)
	return OK
	
	
func load_catalog_tree()->int:
	var file:FileAccess = FileAccess.open(CATALOG_PATH,FileAccess.READ)
	if !file:
		return FileAccess.get_open_error()
	var c_text:String = file.get_as_text()
	file = null
	if c_text.is_empty():
		return ERR_CANT_OPEN
	var tree_levels:Array[TreeItem] = []
	tree.clear()
	tree_items.clear()
	var tree_root:TreeItem = tree.create_item()
	tree_root.set_text(0,"API文档")
	tree_root.set_icon(0,get_theme_icon("Help","EditorIcons"))
	for l in c_text.split("\n",false):
		var level:int = l.countn("	")
		var item:TreeItem = null
		if tree_levels.is_empty():
			item = tree.create_item(tree_root)
			tree_levels.append(item)
		elif level == tree_levels.size()-1:
			if level == 0:
				item = tree.create_item(tree_root)
			else:
				item = tree.create_item(tree_levels[level-1])
			tree_levels[level] = item
		elif level == tree_levels.size():
			item = tree.create_item(tree_levels[tree_levels.size()-1])
			tree_levels.append(item)
		elif level < tree_levels.size()-1:
			for i in tree_levels.size()-1-level:
				tree_levels.pop_back()
			if level == 0:
				item = tree.create_item(tree_root)
			else:
				item = tree.create_item(tree_levels[level-1])
			tree_levels[level] = item
		else:
			return ERR_CANT_CREATE
		var text_arr:PackedStringArray = l.strip_edges().split(":",false)
		item.set_text(0,text_arr[0])
		item.set_tooltip_text(0,text_arr[1])
		item.set_icon(0,get_theme_icon("PluginScript","EditorIcons"))
		tree_items.append(item)
	tree.set_selected(tree_root,0)
	return OK


func _on_tree_item_selected() -> void:
	var item:TreeItem = tree.get_selected()
	var err:int = await load_doc(item.get_text(0))
	if err == OK:
		$HSplitContainer/VBoxContainer/BrowserButton.text = "在浏览器中打开"
		$HSplitContainer/VBoxContainer/BrowserButton.set_meta("doc_name",item.get_text(0))
	else:
		$HSplitContainer/VBoxContainer/BrowserButton.text = "访问RainyBot文档页面"
		$HSplitContainer/VBoxContainer/BrowserButton.set_meta("doc_name","")


func _on_browser_button_button_down() -> void:
	var doc_name:String = ""
	if $HSplitContainer/VBoxContainer/BrowserButton.has_meta("doc_name"):
		doc_name = $HSplitContainer/VBoxContainer/BrowserButton.get_meta("doc_name")
	OS.shell_open("https://docs.rainybot.dev/api/%s"%doc_name.to_lower())


func _on_godot_doc_button_button_down() -> void:
	OS.shell_open("https://docs.godotengine.org/en/latest/classes/")
