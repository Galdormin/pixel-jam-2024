extends UIWindow

@onready var slot: Slot = $Slot

# Load SignalBus
@onready var signal_bus: SignalBus = get_node("/root/SignalBus")

var progress_enable: bool = false
var current_map: String = "Sea"

# Called when the node enters the scene tree for the first time.
func _ready():
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(ready)
	
	# Progress
	if progress_enable:
		$ProgressBar.value = ($Timer.wait_time - $Timer.time_left) / $Timer.wait_time * 100
		
	if not slot.has_card():
		$ProgressBar.value = 0

	if not progress_enable and slot.has_card() and slot.get_card().card_name != current_map:
		enable_button()
	else:
		disable_button()

### SIGNALS ###

func _on_start_pressed():
	slot.lock_card()
	$Timer.start()
	progress_enable = true
	disable_button()


func _on_timer_timeout():
	slot.unlock_card()
	progress_enable = false
	
	var card_map_name = slot.get_card().card_name
	current_map = card_map_name
	signal_bus.on_map_change.emit(current_map)


### FUNCTIONS ###

func close():
	super()
	slot.disable()


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
