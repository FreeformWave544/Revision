extends Node3D

@export var bgMusic: Array[AudioStream]
@export var questions: Dictionary = {
	"DT": {
		"What is a battery?": "Electrochemicals react with one another to convert chemical energy into electrical energy, which is then stored. A battery is made up of one or more cells.",
		"Each battery has two sides, what are these?": "A positive and negative side/terminal.",
		"What is the typical voltage of a cell?": "Typically providing 1.5V",
		"What varies between batteries?": "Size, shapes, voltage outputs (although typically 1.5V), and power levels.",
		"How do rechargeable batteries recharge?": "Rechargeable batteries reverse the chemical reactions via electrical energy input, converting electrical energy to chemical.",
		"How many times can rechargeable batteries be used?": "Rechargeable batteries can be charged and discharged hundreds, if not thousands of times.",
		"What's the difference between alkali and acid batteries?": "Acid batteries give higher current but shorter life, whereas alkali give a lower current, but longer life and are lighter.",
		"What are some benefits of rechargeable batteries?": "Cheaper long-term, better for the environment, and is more efficient for devices that need frequent charge. (e.g. phones)",
		"One main benefit and drawback to alkaline batteries.": "Higher capacity for their size than acid-based batteries, although they lose charge over time.",
		"What are some examples of kinetic energy?": "A ball thrown, a person walking, an object falling.",
		"What is kinetic energy?": "The energy involved in motion.",
		"How do you store potential energy?": "Springs, balloons, elastic bands.",
		"What are the main differences between pneumatics and hydraulics?": "Pneumatics use gas for a fast (yet lower) force, whereas hydraulics use liquids for a smoother, higher force.",
		"What is the most common liquid used in hydraulics?": "Oil.",
		"What is an actuator?": "An actuator is a component of a machine that is responsible for moving or controlling a mechanism or system."
	},
	"CS": {
		"Embedded Systems": {
			"What is a computer system made up of? [hint: —ware]": "Both hardware and software.",
			"List a few common examples of embedded systems:": "Dishwasher, washing machine, fridge, smart phone, TV.",
			"Do embedded systems contain an OS?": "Not usually.",
			"What types of tasks do embedded systems perform?": "They perform very specialised tasks",
			"Define an embedded system.": "A system which has a processor built in to another device."
		},
		"CPU": {
			"List some input devices...": "(Laptop) Keyboard, buttons, trackpad, microphone.  (Smartphone) GPS sensor, gyroscopic sensor, touchscreen.",
			"List some output devices...": "(Laptop & Smartphone) Speakers, display.",
			"What did the Von Neumann architecture change?": "It stored the program data alongside the data as well.",
			"What is the cache?": "The cache is a memory located on the CPU that is slower than registers yet faster than RAM."
		},
		"Registers": {
			"What is a register?": "A register is a very fast memory location in the CPU itself.",
			"The PC register does...": "The PC (Program Counter) holds the address of the next instruction to be executed.",
			"The MAR does...": "The MAR (Memory Address Register) holds the memory address of the current instruction, and then the data that it uses, so that these can be fetched from memory.",
			"The MDR does...": "The MDR (Memory Data Register) holds the actual instruction, and then the data that has been fetched from memory."
		}
	}
}

var word := ""
var definition := ""
var topic := ""
const STORAGE_KEY := "questions_data"
var is_host := false
var occurrences := {}
@export_enum("DT","Religious Education","CS") var subject := "CS"

func _is_web() -> bool: return OS.get_name() == "Web"

func _ready() -> void:
	_normalize_questions()
	_load_questions_from_browser()
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	topic = questions[subject].keys()[0]
	word = questions[subject][topic].keys().pick_random()
	definition = questions[subject][topic][word]
	_set_word()
	_update_subjects()
	if $ClickStuff/Subject.item_count >= 1: $ClickStuff/Subject.selected = 0

func _normalize_questions():
	for s in questions.keys():
		var v = questions[s]
		if v.is_empty(): continue
		var k = v.keys()[0]
		if typeof(v[k]) == TYPE_STRING: questions[s] = {"General": v}

var side = true
func _on_button_pressed() -> void:
	_save_questions_to_browser()
	$ClickSFX.play()
	if questions[subject][topic].is_empty(): return
	if side:
		word = random_card(weightedQ())
		occurrences[word] = occurrences.get(word,0)+1
		$AnimationPlayer.play("Spin")
	else:
		definition = questions[subject][topic].get(word,"...")
		$AnimationPlayer.play_backwards("Spin")
	side = !side

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
	_save_questions_to_browser()
	if not $questions.visible:
		$questions.show()
		$questions.text = JSON.stringify(questions[subject][topic],"\t")
	else: _load_questions_from_text()

func _load_questions_from_text()->void:
	var text=$questions.text
	var json:=JSON.new()
	if json.parse(text)!=OK: push_error("Invalid JSON"); return
	var data=json.get_data()
	if typeof(data)!=TYPE_DICTIONARY: push_error("JSON root is not a dictionary"); return
	var new_q:Dictionary[String,String]={}
	for k in data.keys():
		if typeof(k)!=TYPE_STRING or typeof(data[k])!=TYPE_STRING:
			push_error("All keys and values must be strings"); return
		new_q[k]=data[k]
	questions[subject][topic]=new_q
	$questions.hide()
	$questions.text=""
	_save_questions_to_browser()
	if is_host: sync_questions_to_all()

func _on_add_remove_pressed()->void: $AddRem.show()

func _load_questions_from_browser()->void:
	if not _is_web(): return
	var json_text=JavaScriptBridge.eval("""(function(){return localStorage.getItem('%s');})();"""%STORAGE_KEY)
	if json_text==null or json_text=="": return
	var json:=JSON.new()
	if json.parse(json_text)!=OK: push_error("Failed to parse stored questions"); return
	var data=json.get_data()
	if typeof(data)!=TYPE_DICTIONARY: return
	questions=data

func _save_questions_to_browser()->void:
	if not _is_web(): return
	var json_text:=JSON.stringify(questions)
	var esc=json_text.replace("\\","\\\\").replace("'","\\'")
	JavaScriptBridge.eval("""(function(){localStorage.setItem('%s','%s');})();"""%[STORAGE_KEY,esc])

func start_host(port:=8910):
	var peer:=ENetMultiplayerPeer.new()
	if peer.create_server(port,8)!=OK: push_error("Failed to start server"); return
	multiplayer.multiplayer_peer=peer
	is_host=true

func _on_peer_connected(id:int):
	print("Peer connected:",id)
	if is_host: rpc_id(id,"receive_questions_update",questions)

func _on_peer_disconnected(id:int): print("Peer disconnected:",id)
func _on_connected_to_server(): print("Successfully connected to server")
func _on_connection_failed(): push_error("Failed to connect to server")

func join_host(ip:String,port:=8910):
	var peer:=ENetMultiplayerPeer.new()
	if peer.create_client(ip,port)!=OK: push_error("Failed to create client"); return
	multiplayer.multiplayer_peer=peer
	is_host=false
	print("Connecting to ",ip)

func sync_questions_to_all():
	if is_host: rpc("receive_questions_update",questions)

@rpc("any_peer","call_remote","reliable")
func receive_questions_update(new_q:Dictionary):
	questions=new_q
	print("Questions synced from ",multiplayer.get_remote_sender_id())
	_save_questions_to_browser()
	if not questions[subject][topic].has(word):
		word=questions[subject][topic].keys().pick_random()
		definition=questions[subject][topic][word]
		if side: _set_word()
		else: _set_definition()

func update_and_sync_questions(new_q:Dictionary):
	questions=new_q
	_save_questions_to_browser()
	if is_host: sync_questions_to_all()

func _on_host_pressed()->void: start_host()

func _on_notes_toggled()->void:
	for c in get_children():
		if c is Window and c.name=="Notes": c.show(); return
	add_child(load("res://UI/notes.tscn").instantiate())

func _on_subject_item_selected(index:int)->void:
	subject=$ClickStuff/Subject.get_item_text(index)
	topic=questions[subject].keys()[0]

func _update_subjects()->void:
	var sel=$ClickStuff/Subject.selected
	$ClickStuff/Subject.clear()
	for s in questions.keys(): $ClickStuff/Subject.add_item(s)
	$ClickStuff/Subject.selected=sel

func _on_options_pressed()->void:
	get_tree().change_scene_to_file("res://scenes/menus/options_menu/master_options_menu_with_tabs.tscn")

func _on_resins_pressed()->void:
	get_tree().change_scene_to_file("res://scenes/carbon_glass.tscn")
