extends Node3D

@export var bgMusic: Array[AudioStream]
@export var questions: Dictionary[String, String] = {
	"What are pathogens?":
	"Micro-organisms that cause infectious diseases and can spread between organisms.",
	"What types of pathogens are there?":
	"Viruses, bacteria, fungi, and protists.",
	"Why are viruses difficult to treat?":
	"They live inside living cells, so destroying them often damages host cells.",
	"How do viruses reproduce?":
	"They bind to a host cell membrane, inject genetic material, and hijack the cell to produce more viruses.",
	"What are the symptoms and risks of measles?":
	"Fever, red skin rash, cough, sore throat, conjunctivitis, and possible pneumonia; it can be fatal.",
	"How is HIV transmitted?":
	"Through sexual contact or exchange of bodily fluids.",
	"What does HIV lead to?":
	"Acquired Immune Deficiency Syndrome (AIDS).",
	"What is Tobacco Mosaic Virus (TMV)?":
	"A plant virus that causes mottled leaf discolouration and reduces photosynthesis.",
	"What conditions do bacteria reproduce fastest in?":
	"Warm, moist conditions.",
	"How do bacteria cause harm?":
	"By damaging body tissues and producing toxins.",
	"How is salmonella transmitted?":
	"By ingesting contaminated food, especially undercooked poultry.",
	"What are the symptoms of salmonellosis?":
	"Fever, vomiting, abdominal cramps, and diarrhoea.",
	"Why is salmonella more common in summer?":
	"Bacteria reproduce faster at higher temperatures.",
	"What is gonorrhoea?":
	"A sexually transmitted bacterial disease causing pain when urinating and yellow or green discharge.",
	"Why is gonorrhoea harder to treat now?":
	"Some strains have evolved antibiotic resistance.",
	"How do fungi obtain nutrients?":
	"By growing on other organisms and feeding on their hosts.",
	"What is rose black spot?":
	"A fungal disease that causes black or purple spots on leaves, reducing photosynthesis.",
	"What causes malaria?":
	"A protist.",
	"How is malaria spread?":
	"By mosquitoes acting as vectors between humans.",
	"How does malaria cause illness?":
	"The protist reproduces inside red blood cells, causing fever.",
	"What physical barriers protect the body?":
	"Skin, nose hairs, mucus, and cilia in the trachea.",
	"How does stomach acid protect the body?":
	"Hydrochloric acid kills many swallowed pathogens.",
	"What are the three actions of white blood cells?":
	"Phagocytosis, producing antibodies, and producing antitoxins.",
	"What do antibiotics treat?":
	"Bacterial infections only.",
	"Why can antibiotics not treat viral diseases?":
	"Viruses live inside cells and lack structures antibiotics target.",
	"What is antibiotic resistance?":
	"When bacteria evolve so antibiotics no longer kill them.",
	"What is MDR-TB?":
	"Multi-drug-resistant tuberculosis, resistant to many antibiotics.",
	"What do painkillers do?":
	"Relieve symptoms but do not kill pathogens or cure disease.",
	"What is germ theory?":
	"The theory that diseases are caused by micro-organisms.",
	"Who introduced surgical cleanliness?":
	"Joseph Lister, who reduced infections by sterilising equipment and washing hands.",
	"Who discovered penicillin?":
	"Alexander Fleming in 1928."}

var word := "What are pathogens?"
var definition := questions[word]

func _ready() -> void:
	_on_bg_music_finished()
	word = questions.keys().pick_random()
	definition = questions[word]
	_set_word()
	_set_definition()

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
	$Panel/Definition.text = definition

func _on_spin_sfx_finished() -> void:
	$SpinSFX.pitch_scale = randf_range(0.5, 1.5)

func _on_bg_music_finished() -> void:
	$BGMusic.stream = bgMusic.pick_random()
	$BGMusic.play()
