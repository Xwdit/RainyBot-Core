extends ConfirmationDialog


signal closed(confirmed:bool)


func _on_confirm_popup_cancelled():
	closed.emit(false)


func _on_confirm_popup_confirmed():
	closed.emit(true)


func _on_confirm_popup_visibility_changed():
	if !visible:
		queue_free()
