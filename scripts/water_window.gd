extends UIWindow

# Progressbar
var progress_enable: bool = false

@onready var slots: Array[Slot] = [$Slot1, $Slot2, $Slot3]
@onready var card_scene = preload("res://scenes/card.tscn")
@onready var database: Database = get_node("/root/Database")

func _ready():
	super()

func _process(delta):
	super(delta)
	
	# Enable if not enable and not full
	if $Timer.is_stopped() and get_empty_slots():
		progress_enable = true
		$Timer.start()
	
	# Disable if full
	if progress_enable and not get_empty_slots():
		progress_enable = false
		$Timer.stop()
	
	# Progress
	if progress_enable:
		$ProgressBar.value = ($Timer.wait_time - $Timer.time_left) / $Timer.wait_time * 100
	else:
		$ProgressBar.value = 0


### SIGNALS ###

func _on_timer_timeout():
	var empty_slots = get_empty_slots()
	
	if empty_slots:
		var slot = empty_slots[0]
		
		var new_card = create_water()
		slot.add_card(new_card, true)
		new_card.z_index = 0


### REGULAR FUNCTIONS ###

# Close window
func close():
	super()
	for slot in slots:
		slot.disable()
	

# Open window
func open():
	super()
	for slot in slots:
		slot.enable()


func get_empty_slots() -> Array:
	return slots.filter(func(s): return not s.has_card())

func create_water() -> Card:
	var card = database.create_card_by_name("Aqua")
	card.z_index = 1
	
	add_child(card)
	move_child(card, -1)
	return card
	
