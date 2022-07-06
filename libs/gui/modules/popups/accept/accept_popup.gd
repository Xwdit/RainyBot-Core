extends AcceptDialog


signal closed(confirmed:bool)


func _on_accept_popup_cancelled():
	closed.emit(false)


func _on_accept_popup_confirmed():
	closed.emit(true)


func _on_accept_popup_visibility_changed():
	if !visible:
		queue_free()
