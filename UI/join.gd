extends Panel

func _on_line_edit_text_submitted(new_text: String) -> void:
	var room_code := int(new_text)
	if room_code < 0 or room_code > 255:
		push_error("Invalid room code: " + str(new_text))
		$LineEdit.text = "..."
		return

	get_parent().join_room(room_code)
	hide()
	$LineEdit.text = "..."
