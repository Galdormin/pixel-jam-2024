extends Panel

@onready var signal_bus: SignalBus = get_node("/root/SignalBus")
@onready var database: Database = get_node("/root/Database")
@onready var slot: Slot = $Slot

var is_waiting = false

# Chapters
var chapters: Array
var chapter_step: int

# Chapter Variable
var waiting_meal: String = ""
var gifts: Array = []
var text: Array = []
var text_step: int = 0


func _ready():
	$Slot/TextureRect.texture = load("res://assets/ui/slot_blue.png")


func _process(delta):
	if is_waiting:
		$Next.disabled = not slot.has_card() or slot.get_card().card_name != waiting_meal
	else:
		$Next.disabled = false


### SIGNALS ###

func _on_quit_pressed():
	close()


func _on_next_pressed():
	if is_waiting:
		slot.delete_card()
		$Next.text = "Next"
		is_waiting = false
		slot.disable()
		
		# Next Chapter
		chapter_step += 1
		load_chapter()
		return
	
	if text_step < text.size():
		$Text.text = text[text_step]
		text_step += 1
	
	if text_step >= text.size():
		if waiting_meal != "":
			if gifts:
				var card: Card
				for gift in gifts:
					card = create_map_card(gift)
					card.global_position = slot.get_card_position(card.global_position)
				
				slot.add_card(card, false)
			
			$Next.text = "Feed"
			is_waiting = true
			slot.enable()
		else:
			chapter_step += 1
			load_chapter()
	else:
		slot.disable()


### FUNCTIONS ###


func open():
	show()
	if is_waiting:
		slot.enable()


func close():
	hide()
	slot.disable()


func load_story():
	chapters = database.get_chapter_order()
	chapter_step = 0
	load_chapter()


func load_chapter():
	var chapter = database.get_chapter_data(chapters[chapter_step])
	
	# Load text
	text = chapter["text"]
	$Text.text = text[0]
	text_step = 1
	
	# Load Objectives
	if "objective" in chapter:
		waiting_meal = chapter["objective"]
	else:
		waiting_meal = ""
	
	# Load Gifts
	if "gifts" in chapter:
		gifts = chapter["gifts"]
	else:
		gifts = []
	
	# If unlock
	if "unlock" in chapter:
		signal_bus.on_unlock_plant.emit(chapter["unlock"])


func create_map_card(card_name: String) -> Card:
	var card = database.create_card_by_name(card_name)
	card.z_index = 1
	
	add_child(card)
	move_child(card, -1)
	return card
