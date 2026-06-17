extends CanvasLayer

func _ready() -> void:
	$Thief.grab_focus()
	newQs()

@export var goal := 10
var total := 0
var ans := 0
func newQs():
	get_parent().topic = get_parent().questions[get_parent().subject].keys().pick_random()
	get_parent().word = get_parent().random_card(get_parent().weightedQ())
	get_parent().occurrences[get_parent().word] = get_parent().occurrences.get(get_parent().word, 0) + 1
	get_parent().definition = get_parent().questions[get_parent().subject][get_parent().topic].get(get_parent().word,"...")
	$Word.text = get_parent().definition
	if randi_range(0, 1) == 1:
		$Option1.text = get_parent().word
		$Option2.text = get_parent().questions[get_parent().subject][get_parent().topic].keys().pick_random()
		while $Option2.text == $Option1.text:
			$Option2.text = get_parent().questions[get_parent().subject][get_parent().topic].keys().pick_random()
		ans = 1
	else:
		$Option1.text = get_parent().questions[get_parent().subject][get_parent().topic].keys().pick_random()
		$Option2.text = get_parent().word
		while $Option2.text == $Option1.text:
			$Option1.text = get_parent().questions[get_parent().subject][get_parent().topic].keys().pick_random()
		ans = 2
	total += 1
	if total >= goal:
		$FinalScore.show()
		$FinalScore.modulate.a = 1.0
		$FinalScore.text = $Score.text + "/" + str(goal)
		$Score.text = "SCORE: 0"
		total = 0
		await get_tree().create_timer(0.5).timeout
		for i in range(100): $FinalScore.modulate.a -= 0.01 ; await get_tree().process_frame
		$FinalScore.text = ""
		$FinalScore.modulate.a = 1.0
		$FinalScore.hide()

func _on_back_pressed() -> void: queue_free()

func _option(body: Node2D, choice := 1) -> void:
	if body is Player:
		if choice == ans: $Score.text = "SCORE: " + str(int($Score.text.lstrip("SCORE: ")) + 1)
		body.global_position = Vector2(576.0, 474.0)
		newQs()
