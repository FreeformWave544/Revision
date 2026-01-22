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
	for Q in get_parent().questions.keys():
		$RemQ/Question.add_item(Q)

func _on_remove_q_pressed() -> void:
	var option_button := $RemQ/Question
	var index = option_button.selected
	if index == -1: return
	var question_text = option_button.get_item_text(index)
	get_parent().questions.erase(question_text)
	$RemQ.hide()
	hide()
	$Add.show()
	$Remove.show()


func _on_q_text_submitted(_new_text: String) -> void:
	if $AddQ/Q.text and $AddQ/Ans.text:
		get_parent().questions[$AddQ/Q.text] = $AddQ/Ans.text
		$AddQ.hide()
		hide()
		$Add.show()
		$Remove.show()
