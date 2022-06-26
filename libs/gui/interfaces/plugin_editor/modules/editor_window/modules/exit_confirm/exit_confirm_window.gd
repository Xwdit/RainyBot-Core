extends Window


signal confirm_pressed
signal cancel_pressed


func _on_ConfirmButton_button_up()->void:
	emit_signal("confirm_pressed")
	hide()


func _on_CancelButton_button_up()->void:
	emit_signal("cancel_pressed")
	hide()
