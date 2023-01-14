extends Panel


enum ConsoleOptions{
	RAINYBOT,
	MIRAI_ADAPTER
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_option_button_item_selected(index: int) -> void:
	$VSplitContainer/HBoxContainer/CommandInput.current_console = index
	if index == ConsoleOptions.RAINYBOT:
		$VSplitContainer/ConsoleOutput.show()
		$VSplitContainer/MiraiConsoleOutput.hide()
	else:
		$VSplitContainer/ConsoleOutput.hide()
		$VSplitContainer/MiraiConsoleOutput.show()
		
		
func clear():
	if $VSplitContainer/HBoxContainer/VBoxContainer/OptionButton.selected == ConsoleOptions.RAINYBOT:
		$VSplitContainer/ConsoleOutput.init_log()
		$VSplitContainer/ConsoleOutput.clear()
		$VSplitContainer/ConsoleOutput.add_success("已为您保存日志并清空控制台中的所有历史输出！")
	else:
		$VSplitContainer/MiraiConsoleOutput.init_log()
		$VSplitContainer/MiraiConsoleOutput.clear()
		$VSplitContainer/MiraiConsoleOutput.add_success("已为您保存日志并清空控制台中的所有历史输出！")
