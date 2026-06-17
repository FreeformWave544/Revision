extends Node3D

@export var bgMusic: Array[AudioStream]
@export var questions: Dictionary = {
	"RE": {
		"Matters of Life and Death": {
			"Creationism": "the belief that the universe, and humans, were created in the way the Bible says",
			"Commodity": "something that humans want or need",
			"Conservation": "protecting and preserving natural resources and the environment",
			"Pacifism": "refusing to fight in wars",
			"Capital punishment": "the death penalty for a crime",
			"Natural selection": "the idea that life evolved through mutations, making those life forms better suited to the environment survive",
			"Foetus": "a developing human in the womb",
			"Gestation": "the process of a foetus developing inside a womb",
			"Conception": "the fertilisation of the egg by the sperm",
			"Doctrine of double effect": "the principle that it is acceptable to perform an action that has a side-effect as long as the intention was to achieve the good first effect",
			"Quality of life": "the idea that life must have some benefits to be worth living",
			"Immortality of the soul": "the idea that the soul lives on after the death of the body",
			"Paranormal": "unexplained events that are thought to have spiritual causes, e.g. ghosts",
			"Near-death experiences": "when people about to die have outer body experiences",
			"Reincarnation": "the belief that, after death, souls are reborn in a new body",
			"Euthanasia": "the painless killing of someone dying from a painful disease",
			"Stewardship": "looking after something so it can be passed on to the next generation",
			"Global warming": "the increase in the temperature of the earth’s atmosphere",
			"Environment": "the surroundings in which plants and animals live and on which they depend for survival"
		}
	}
}

var word := ""
var definition := ""
var topic := ""
const STORAGE_KEY := "questions_data"
var occurrences := {}
@export_enum("RE") var subject := "RE"

func _is_web() -> bool: return OS.get_name() == "Web"

func _ready() -> void:
	_normalize_questions()
	topic = questions[subject].keys().pick_random()
	word = questions[subject][topic].keys().pick_random()
	definition = questions[subject][topic][word]
	_set_word()
	_update_subjects()
	if $ClickStuff/Subject.item_count >= 1: $ClickStuff/Subject.selected = 1

func _normalize_questions():
	for s in questions.keys():
		var v = questions[s]
		if v.is_empty(): continue
		var k = v.keys()[0]
		if typeof(v[k]) == TYPE_STRING: questions[s] = {"General": v}

var side = true
func _on_button_pressed() -> void:
	$ClickSFX.play()
	if questions[subject][topic].is_empty(): return
	if side:
		topic = questions[subject].keys().pick_random()
		word = random_card(weightedQ())
		occurrences[word] = occurrences.get(word, 0) + 1
		$AnimationPlayer.play("Spin")
	else:
		definition = questions[subject][topic].get(word,"...")
		$AnimationPlayer.play_backwards("Spin")
	side = !side
	await get_tree().create_timer(1.5).timeout
	$Topic.text = "Topic: " + topic

func weightedQ() -> Dictionary:
	var weighted := {}
	for q in questions[subject][topic].keys():
		var c = occurrences.get(q,0)
		weighted[q] = max(0.1,1.0/pow(c+1,2))
	return weighted

func _set_word() -> void: $Panel/Word.text = word
func _set_definition() -> void: $Panel/Word.text = definition

func _on_spin_sfx_finished() -> void: $SpinSFX.pitch_scale = randf_range(0.5,1.5)

func random_card(weighted_items:Dictionary)->Variant:
	var total:=0.0
	for w in weighted_items.values(): total+=w
	var roll:=randf()*total
	var c:=0.0
	for k in weighted_items.keys():
		c+=weighted_items[k]
		if roll<c: return k
	return weighted_items.keys().back()

func _on_bg_music_finished() -> void:
	$BGMusic.stream = bgMusic.pick_random()
	$BGMusic.play()

func _on_music_toggled(toggled_on:bool)->void: $BGMusic.playing=toggled_on

func _on_questions_pressed()->void:
	if not $questions.visible:
		$questions.show()
		$questions/questions.text = JSON.stringify(questions[subject],"\t")
	else: _load_questions_from_text() ; $questions.hide()

func _load_questions_from_text()->void:
	var text = $questions/questions.text
	var json := JSON.new()
	if json.parse(text) != OK: push_error("Invalid JSON") ; return
	var data = json.get_data()
	if typeof(data)!=TYPE_DICTIONARY: push_error("JSON root is not a dictionary") ; return
	var new_q: Dictionary[String,String] = {}
	for k in data.keys():
		if typeof(k) != TYPE_STRING or typeof(data[k]) != TYPE_STRING:
			push_error("All keys and values must be strings"); return
		new_q[k] = data[k]
	questions[subject][topic] = new_q
	$questions.hide()
	$questions/questions.text = ""

func _on_add_remove_pressed()->void: $AddRem.show()

func _on_notes_toggled()->void:
	for c in get_children():
		if c is Window and c.name=="Notes": c.show(); return
	add_child(load("res://UI/notes.tscn").instantiate())

func _on_subject_item_selected(index:int)->void:
	subject=$ClickStuff/Subject.get_item_text(index)
	topic=questions[subject].keys().pick_random()

func _update_subjects()->void:
	var sel=$ClickStuff/Subject.selected
	$ClickStuff/Subject.clear()
	for s in questions.keys(): $ClickStuff/Subject.add_item(s)
	$ClickStuff/Subject.selected=sel

func _on_options_pressed()->void:
	get_tree().change_scene_to_file("res://scenes/menus/options_menu/master_options_menu_with_tabs.tscn")

func _on_resins_pressed()->void:
	get_tree().change_scene_to_file("res://scenes/carbon_glass.tscn")

func _on_platformer_pressed() -> void:
	add_child(preload("res://scenes/platformer.tscn").instantiate())
