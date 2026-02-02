extends Panel

func _on_add_pressed() -> void:
	$AddQ.show()
	$Add.hide()
	$Remove.hide()

func _on_remove_pressed() -> void:
	$RemQ.show()
	$Add.hide()
	$Remove.hide()
	$RemQ/Question.clear()
	for Q in get_parent().questions[get_parent().subject].keys(): $RemQ/Question.add_item(Q)

func _on_remove_q_pressed() -> void:
	var option_button := $RemQ/Question
	var index = option_button.selected
	if index == -1: return
	var question_text = option_button.get_item_text(index)
	get_parent().questions[get_parent().subject].erase(question_text)
	$RemQ.hide()
	hide()
	$Add.show()
	$Remove.show()

func _on_q_text_submitted(_new_text: String) -> void:
	if $AddQ/Q.text and $AddQ/Ans.text:
		get_parent().questions[get_parent().subject][$AddQ/Q.text] = $AddQ/Ans.text
		$AddQ.hide()
		hide()
		$Add.show()
		$Remove.show()
	elif $AddQ/Q.text and not $AddQ/Ans.text:
		get_parent().questions[$AddQ/Q.text] = {}
		$AddQ.hide()
		hide()
		$Add.show()
		$Remove.show()
	get_parent()._update_subjects()

func _unhandled_input(_event: InputEvent) -> void:
	if visible and Input.is_action_just_pressed("ui_cancel"):
		$RemQ.hide()
		$AddQ.hide()
		$Add.show()
		$Remove.show()
		hide()
