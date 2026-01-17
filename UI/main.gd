extends Node3D

@export var bgMusic: Array[AudioStream]
@export var questions: Dictionary[String, String] = {
	"What does Biodegradeable mean?": "(of a substance or object) capable of being decomposed by bacteria or other living organisms and thereby avoiding pollution.",
	"What are corn starch polymers made from?": "Vegetable starches (corn starch).",
	"Why can’t corn starch polymers be recycled?": "They decompose easily.",
	"Which industries use corn starch polymers?": "Manufacturing and retail.",
	"What is PLA made from?": "Vegetable starches.",
	"What is PLA widely used for?": "3D printer filament.",
	"Is PLA flexible or brittle?": "Quite brittle.",
	"What is PHB also known as?": "Biopol.",
	"Describe the appearance of PLA and PHB.": "Smooth or textured, easily coloured.",
	"Name one use of PLA.": "[Bottles/food containers/pens/phone cases/3D prints.]"
}

var word := ""
var definition := ""

func _ready() -> void:
	_on_bg_music_finished()
	word = questions.keys().pick_random()
	definition = questions[word]
	_set_word()

var side = true
func _on_button_pressed() -> void:
	$ClickSFX.play()
	if side:
		word = questions.keys().pick_random()
		$AnimationPlayer.play("Spin")
	else:
		definition = questions[word]
		$AnimationPlayer.play_backwards("Spin")
	side = !side

func _set_word() -> void:
	$Panel/Word.text = word

func _set_definition() -> void:
	$Panel/Word.text = definition

func _on_spin_sfx_finished() -> void:
	$SpinSFX.pitch_scale = randf_range(0.5, 1.5)

func _on_bg_music_finished() -> void:
	$BGMusic.stream = bgMusic.pick_random()
	$BGMusic.play()
