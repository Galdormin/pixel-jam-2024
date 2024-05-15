extends UIWindow

@onready var slot: Slot = $Slot

var progress_enable: bool = false

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


### SIGNALS ###

func _on_start_pressed():
	if slot.has_card():
		slot.lock_card()
		$Timer.start()
		progress_enable = true
		disable_button()


func _on_timer_timeout():
	slot.unlock_card()
	progress_enable = false
	enable_button()


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
