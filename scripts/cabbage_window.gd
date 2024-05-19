extends UIWindow

# Progressbar
var progress_enable: bool = false

@onready var slot: Slot = $Slot
@onready var database: Database = get_node("/root/Database")

func _ready():
	super()


func _process(delta):
	super(delta)
	
	# Progress
	if progress_enable:
		$ProgressBar.value = ($Timer.wait_time - $Timer.time_left) / $Timer.wait_time * 100
	elif not $Slot.has_card():
		$ProgressBar.value = 0
		enable_button()

### SIGNALS ###

func _on_start_pressed():
	if slot.has_card():
		slot.disable()
		slot.delete_card()
		$Timer.start()
		progress_enable = true
		disable_button()


func _on_timer_timeout():
	$Slot.enable()
	progress_enable = false
	
	var cabbage = create_cabbage_card()
	cabbage.z_index = 0
	slot.add_card(cabbage, false)


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


func create_cabbage_card() -> Card:
	var card = database.create_card_by_name("Cabbage")
	card.z_index = 1
	
	add_child(card)
	move_child(card, -1)
	return card
