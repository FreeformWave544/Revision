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
			"What types of tasks do embedded systems perform?": "They perform very specialised tasks.",
			"Define an embedded system.": "A system which has a processor built in to another device."
		},
		"CPU": {
			"List some input devices...": "(Laptop) Keyboard, buttons, trackpad, microphone. (Smartphone) GPS sensor, gyroscopic sensor, touchscreen.",
			"List some output devices...": "(Laptop & Smartphone) Speakers, display.",
			"What did the Von Neumann architecture change?": "It stored both program instructions and data in the same memory.",
			"What is the cache?": "A small amount of very fast memory located on the CPU used to store frequently used instructions and data."
		},
		"Registers": {
			"What is a register?": "A register is a very fast memory location in the CPU itself.",
			"The PC register does...": "The PC (Program Counter) holds the address of the next instruction to be executed.",
			"The MAR does...": "The MAR (Memory Address Register) holds the address of the data or instruction that needs to be fetched from memory.",
			"The MDR does...": "The MDR (Memory Data Register) holds the data or instruction that has been fetched from memory."
		},
		"FDE Cycle": {
			"What does FDE stand for?": "Fetch, Decode, Execute.",
			"What happens in the fetch stage?": "The CPU retrieves the next instruction from memory using the address stored in the program counter.",
			"What happens in the decode stage?": "The control unit interprets the instruction to determine what action is required.",
			"What happens in the execute stage?": "The CPU carries out the instruction, such as performing a calculation or moving data."
		},
		"Memory": {
			"What is RAM?": "Random Access Memory is volatile memory used to store data and programs currently in use.",
			"What does volatile mean?": "Data is lost when power is turned off.",
			"What is ROM?": "Read Only Memory is non-volatile memory that stores permanent instructions such as the boot program.",
			"What is cache memory used for?": "To store frequently used data and instructions so the CPU can access them faster."
		},
		"Storage": {
			"What are the three main types of secondary storage?": "Magnetic, optical, and solid state.",
			"What is magnetic storage?": "Storage that uses magnetised surfaces to store data, such as hard disk drives.",
			"What is optical storage?": "Storage that uses lasers to read and write data, such as CDs and DVDs.",
			"What is solid state storage?": "Storage that uses flash memory with no moving parts, such as SSDs and USB drives."
		},
		"Binary": {
			"What is binary?": "A number system that uses only two digits: 0 and 1.",
			"What is a bit?": "A single binary digit.",
			"What is a byte?": "Eight bits.",
			"Why do computers use binary?": "Because electronic circuits have two states (on/off) which map easily to 1 and 0."
		},
		"Compression": {
			"What is data compression?": "Reducing the size of a file so it takes up less storage space or transfers faster.",
			"What is lossless compression?": "Compression where no data is lost and the original file can be perfectly reconstructed.",
			"What is lossy compression?": "Compression where some data is permanently removed to reduce file size."
		},
		"Networking": {
			"What is a computer network?": "Two or more computers connected together to share data and resources.",
			"What is a LAN?": "A Local Area Network covering a small area such as a home, school, or office.",
			"What is a WAN?": "A Wide Area Network covering a large geographical area.",
			"What is packet switching?": "Data is split into packets which are sent independently across a network and reassembled at the destination."
		},
		"Protocols": {
			"What is a network protocol?": "A set of rules that define how data is transmitted across a network.",
			"What does HTTP do?": "Transfers web pages between web servers and web browsers.",
			"What does HTTPS do?": "A secure version of HTTP that encrypts data.",
			"What does FTP do?": "Transfers files between computers on a network.",
			"What does SMTP do?": "Used to send emails between mail servers."
		},
		"Security": {
			"What is malware?": "Malicious software designed to damage or gain unauthorised access to a system.",
			"What is a firewall?": "A security system that monitors and controls incoming and outgoing network traffic.",
			"What is encryption?": "The process of converting data into a coded form to prevent unauthorised access.",
			"What is user access level?": "Restrictions that control what a user can do on a system."
		},
		"Software": {
			"What is software?": "Programs and instructions that tell a computer what to do.",
			"What is system software?": "Software that manages the hardware and basic functions of a computer.",
			"What is application software?": "Programs designed for users to perform specific tasks."
		},
		"Computer Systems": {
			"What is hardware?": "The physical components of a computer system.",
			"What is the operating system?": "System software that manages hardware, memory, files, and processes.",
			"What does the OS provide for the user?": "A user interface to interact with the computer."
		},
		"Data Types": {
			"What is an integer?": "A whole number data type.",
			"What is a real/float?": "A data type used for numbers with decimal points.",
			"What is a boolean?": "A data type that can only be true or false.",
			"What is a character?": "A single letter, number, or symbol.",
			"What is a string?": "A sequence of characters."
		},
		"Internet": {
			"What is the internet?": "A global network of interconnected computer networks.",
			"What is the World Wide Web?": "A system of linked web pages accessed through the internet.",
			"What is a web server?": "A computer that stores and delivers web pages to users."
		},
		"Laws": {
			"What does the Data Protection Act do?": "Protects personal data and controls how organisations use it.",
			"What does the Computer Misuse Act do?": "Makes unauthorised access to computer systems illegal.",
			"What does copyright law protect?": "Original work such as software, music, and documents from being copied without permission."
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
	topic = questions[subject].keys().pick_random()
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
	$ClickSFX.play()
	if questions[subject][topic].is_empty(): return
	if side:
		topic = questions[subject].keys().pick_random()
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
