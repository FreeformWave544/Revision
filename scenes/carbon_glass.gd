extends Control
signal PlayNext

@onready var label := $Panel/RichTextLabel
var stops = [53, 99, 175, 255, 311, 388, 470, 521, 658]
var karma = 5

func _ready() -> void: next()

func next():
	label.self_modulate.r = 255 - karma
	label.self_modulate.b = 255 - karma
	for i in range(len(stops)):
		await PlayNext
		if i != 0:
			while label.visible_characters <= stops[i] - (stops[i] - stops[i - 1]) / 2:
				label.visible_characters += 1
				var speed = lerp(0.01, 0.05, karma / 5.0)
				await get_tree().create_timer(speed).timeout
			await PlayNext
		while label.visible_characters != stops[i]:
			label.visible_characters += 1
			var speed = lerp(0.01, 0.05, karma / 10.0)
			await get_tree().create_timer(speed).timeout
	await PlayNext
	$CenterContainer.show()
	$AudioStreamPlayer.play()

func _on_next_pressed() -> void:
	PlayNext.emit()

func _on_yes_pressed() -> void:
	karma += 5
	$CenterContainer.hide()
	$Panel/RichTextLabel.visible_characters = 0
	$AudioStreamPlayer.stop()
	next()

func _on_no_pressed() -> void:
	karma -= 5
	$CenterContainer.hide()
	$Panel/RichTextLabel.visible_characters = 0
	$AudioStreamPlayer.stop()
	next()
