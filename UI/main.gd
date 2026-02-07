extends Node3D

@export var bgMusic: Array[AudioStream]
@export var questions: Dictionary[String, Dictionary] = {
	"DT": {
		"What is a battery?": "Electrochemicals react with one another to convert chemical energy into electrical energy, which is then stored. A battery is made up of one or more cells.",
		"Each battery has two sides, what are these?": "A positive and negative side/terminal.",
		"What is the typical voltage of a cell?": "Typically providing 1.5V",
		"What varies between batteries?": "Size, shapes, voltage outputs (although typically 1.5V), and power levels.",
		"How do rechargeable batteries recharge?": "Rechargeable batteries reverse the chemical reactions via electrical energy input, converting electrical energy to chemical.",
		"How many times can rechargeable batteries be used?": "Rechargeable batteries can be charged and discharged hundreds, if not thousands of times.",
		"What's the difference between alkali and acid batteries?": "Acid batteries give higher current but shorter life, whereas alkali give a lower current, but longer life and are lighter.",
		"What are some benefits of rechargeable batteries?": "Cheaper long-term, better for the environment, and is more efficient for devices that need frequent charge. (e.g. phones)",
		"One main benefit and drawback to alkaline batteries.": "High capacity for their size than acid-based batteries, although they lose charge over time.",
		"What are some examples of kinetic energy?": "A ball thrown, a person walking, an object falling.",
		"What is kinetic energy?": "The energy involved in motion.",
		"How do you store potential energy?": "Springs, balloons, elastic bands.",
		"What are the main differences between pneumatics and hydraulics?": "Pneumatics use gas for a fast (yet lower) force, whereas hydraulics use liquids for a smoother, higher force.",
		"What is the most common liquid used in hydraulics?": "Oil.",
		"What is an actuator?": "An actuator is a component of a machine that is responsible for moving or controlling a mechanism or system."
		}
	}

var word := ""
var definition := ""
const STORAGE_KEY := "questions_data"
var is_host := false
var occurrences := {}
@export_enum("DT") var subject = "DT"

func _is_web() -> bool: return OS.get_name() == "Web"

func _ready() -> void:
	_load_questions_from_browser()
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	word = questions[subject].keys().pick_random()
	definition = questions[subject][word]
	_set_word()
	_update_subjects()

var side = true
func _on_button_pressed() -> void:
	_save_questions_to_browser()
	$ClickSFX.play()
	if questions[subject].is_empty(): return
	if side:
		word = random_card(weightedQ())
		if word in occurrences: occurrences[word] += 1
		else: occurrences[word] = 1
		$AnimationPlayer.play("Spin")
	else:
		definition = questions[subject][word] if word in questions[subject] else "..."
		$AnimationPlayer.play_backwards("Spin")
	side = !side

func weightedQ() -> Dictionary:
	var weighted := {}
	for question in questions[subject].keys():
		var count = occurrences.get(question, 0)
		weighted[question] = max(0.1, 1.0 / pow(count + 1, 2))
	return weighted

func _set_word() -> void: $Panel/Word.text = word

func _set_definition() -> void: $Panel/Word.text = definition

func _on_spin_sfx_finished() -> void: $SpinSFX.pitch_scale = randf_range(0.5, 1.5)

func random_card(weighted_items: Dictionary) -> Variant:
	var total := 0.0
	for w in weighted_items.values(): total += w
	var roll := randf() * total
	var cumulative := 0.0
	for key in weighted_items.keys():
		cumulative += weighted_items[key]
		if roll < cumulative: return key
	return weighted_items.keys().back()

func _on_bg_music_finished() -> void:
	$BGMusic.stream = bgMusic.pick_random()
	$BGMusic.play()

func _on_music_toggled(toggled_on: bool) -> void: $BGMusic.playing = toggled_on

func _on_questions_pressed() -> void:
	_save_questions_to_browser()
	if not $questions.visible:
		$questions.show()
		$questions.text = JSON.stringify(questions[subject], "\t")
	else:  _load_questions_from_text()

func _load_questions_from_text() -> void:
	var text = $questions.text
	var json := JSON.new()
	if json.parse(text) != OK:
		push_error("Invalid JSON")
		return
	var data = json.get_data()
	if typeof(data) != TYPE_DICTIONARY:
		push_error("JSON root is not a dictionary")
		return
	var new_questions: Dictionary[String, String] = {}
	for key in data.keys():
		if typeof(key) != TYPE_STRING or typeof(data[key]) != TYPE_STRING:
			push_error("All keys and values must be strings")
			return
		new_questions[key] = data[key]
	questions[subject] = new_questions
	$questions.hide()
	$questions.text = ""
	_save_questions_to_browser()
	if is_host: sync_questions_to_all()

func _on_add_remove_pressed() -> void: $AddRem.show()

func _load_questions_from_browser() -> void:
	if OS.get_name() != "Web": return

	var json_text = JavaScriptBridge.eval("""(function() {return localStorage.getItem('%s');})();""" % STORAGE_KEY)
	if json_text == null or json_text == "":
		print("No saved questions found")
		return
	var json := JSON.new()
	if json.parse(json_text) != OK:
		push_error("Failed to parse stored questions: " + json.get_error_message())
		return
	var data = json.get_data()
	if typeof(data) != TYPE_DICTIONARY:
		push_error("Stored data is not a dictionary")
		return
	var loaded: Dictionary[String, String] = {}
	for k in data.keys():
		if typeof(k) == TYPE_STRING and typeof(data[k]) == TYPE_STRING: loaded[k] = data[k]
	if not loaded.is_empty():
		questions[subject] = loaded
		print("Questions loaded from browser storage")

func _save_questions_to_browser() -> void:
	if OS.get_name() != "Web": return
	var json_text := JSON.stringify(questions[subject])
	var escaped := json_text.replace("\\", "\\\\").replace("'", "\\'").replace("\n", "\\n").replace("\r", "\\r")
	JavaScriptBridge.eval("""(function() {localStorage.setItem('%s', '%s');})();""" % [STORAGE_KEY, escaped])

func start_host(port := 8910):
	var peer := ENetMultiplayerPeer.new()
	if peer.create_server(port, 8) != OK:
		push_error("Failed to start server")
		return
	multiplayer.multiplayer_peer = peer
	is_host = true
	
	var broadcaster := preload("res://LAN/LanBroadcaster.gd").new()
	broadcaster.server_port = port
	add_child(broadcaster)
	print("Server started on port ", port)

func _on_peer_connected(id: int):
	print("Peer connected:", id)
	if is_host: rpc_id(id, "receive_questions_update", questions[subject])

func _on_peer_disconnected(id: int):
	print("Peer disconnected:", id)

func _on_connected_to_server():
	print("Successfully connected to server")

func _on_connection_failed():
	push_error("Failed to connect to server")

func join_host(ip: String, port := 8910):
	var peer := ENetMultiplayerPeer.new()
	if peer.create_client(ip, port) != OK:
		push_error("Failed to create client")
		return
	multiplayer.multiplayer_peer = peer
	is_host = false
	print("Connecting to ", ip)

func sync_questions_to_all():
	if is_host:
		rpc("receive_questions_update", questions[subject])

@rpc("any_peer", "call_remote", "reliable")
func receive_questions_update(new_questions: Dictionary):
	questions[subject] = new_questions
	print("Questions synced from ", multiplayer.get_remote_sender_id())
	_save_questions_to_browser()

	if not questions[subject].has(word):
		word = questions[subject].keys().pick_random()
		definition = questions[subject][word]
		if side: _set_word()
		else: _set_definition()

func update_and_sync_questions(new_questions: Dictionary):
	questions[subject] = new_questions
	_save_questions_to_browser()
	if is_host: sync_questions_to_all()

func _on_host_pressed() -> void: start_host()

func _on_notes_toggled() -> void:
	for child in get_children():
		if child is Window and child.name == "Notes":
			child.show()
			return
	add_child(load("res://UI/notes.tscn").instantiate())

func _on_subject_item_selected(index: int) -> void:
	subject = $ClickStuff/Subject.get_item_text(index)

func _update_subjects() -> void:
	$ClickStuff/Subject.clear()
	for Q in questions.keys(): $ClickStuff/Subject.add_item(Q)

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/options_menu/master_options_menu_with_tabs.tscn")
