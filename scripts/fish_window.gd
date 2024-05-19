extends UIWindow

# Progressbar
var progress_enable: bool = false

@onready var slot: Slot = $Slot
@onready var database: Database = get_node("/root/Database")
@onready var signal_bus: SignalBus = get_node("/root/SignalBus")

var bait_name: String
var current_map: String = "Sea"

func _ready():
	super()
	signal_bus.on_map_change.connect(_on_map_change)


func _process(delta):
	super(delta)
	
	# Progress
	if progress_enable:
		$ProgressBar.value = ($Timer.wait_time - $Timer.time_left) / $Timer.wait_time * 100
	elif not $Slot.has_card() or $Slot.get_card().card_type == "Bait":
		$ProgressBar.value = 0
		enable_button()

### SIGNALS ###

func _on_map_change(map_name: String):
	current_map = map_name

func _on_start_pressed():
	if not slot.has_card():
		bait_name = "empty"
	else:
		bait_name = slot.get_card().card_name
		slot.delete_card()
	
	slot.disable()
	$Timer.start()
	progress_enable = true
	disable_button()


func _on_timer_timeout():
	$Slot.enable()
	progress_enable = false
	
	var new_card = create_fish_card(bait_name)
	new_card.z_index = 0
	slot.add_card(new_card, true)


### REGULAR FUNCTIONS ###

# Close window
func close():
	super()
	slot.disable()
	

# Open window
func open():
	super()
	slot.enable()


func disable_button():
	# Change label color
	var grey = Color(0.2,0.2,0.2,1.0)
	$Start/Label.set("theme_override_colors/font_color",grey)
	
	# Disable button
	$Start.disabled = true


func enable_button():
	# Change label color
	var white = Color(1.0,1.0,1.0,1.0)
	$Start/Label.set("theme_override_colors/font_color",white)
	
	# Disable button
	$Start.disabled = false
	$Start.button_pressed = false


func create_fish_card(bait_name: String) -> Card:
	var fish_name = database.get_fish_from_bait(bait_name, current_map)
	var card = database.create_card_by_name(fish_name)
	card.z_index = 1
	
	add_child(card)
	move_child(card, -1)
	return card
