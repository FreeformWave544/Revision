extends Node3D

@export var bgMusic: Array[AudioStream]
@export var questions: Dictionary[String, String] = {
	"Clergy": "The body of all people ordained for religious duties",
	"Congregation": "A group of people assembled for religious worship",
	"Liturgy": "A set form of public worship",
	"Penance": "An action showing sorrow for a sin",
	"Transubstantiation": "The belief that during the service of Mass the bread and wine transform into the body and blood of Christ",
	"Supplication": "Asking for something humbly",
	"Revered": "Held in deep respect",
	"Veneration": "Treating with deep respect"
}
var word := "Clergy"
var definition := questions[word]

func _ready() -> void:
	_on_bg_music_finished()
	word = questions.keys().pick_random()
	definition = questions[word]
	_set_word()
	_set_definition()

func _on_button_pressed() -> void:
	$ClickSFX.play()
	word = questions.keys().pick_random()
	definition = questions[word]
	$AnimationPlayer.play("Spin")

func _set_word() -> void:
	$Panel/Word.text = word

func _set_definition() -> void:
	$Panel/Definition.text = definition

func _on_spin_sfx_finished() -> void:
	$SpinSFX.pitch_scale = randf_range(0.5, 1.5)

func _on_bg_music_finished() -> void:
	$BGMusic.stream = bgMusic.pick_random()
	$BGMusic.play()
