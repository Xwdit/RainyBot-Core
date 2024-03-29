extends ConfirmationDialog


signal closed(confirmed:bool)


func _on_confirm_popup_canceled()->void:
	closed.emit(false)


func _on_confirm_popup_confirmed()->void:
	closed.emit(true)


func _on_confirm_popup_visibility_changed()->void:
	if !visible:
		queue_free()
