extends AcceptDialog


signal closed(confirmed:bool)


func _on_accept_popup_cancelled()->void:
	closed.emit(false)


func _on_accept_popup_confirmed()->void:
	closed.emit(true)


func _on_accept_popup_visibility_changed()->void:
	if !visible:
		queue_free()
