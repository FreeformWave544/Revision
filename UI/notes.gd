extends Window

func _on_close_requested() -> void:
	hide()

func _on_mouse_entered() -> void:
	await get_tree().process_frame
	$TextEdit.grab_focus()
