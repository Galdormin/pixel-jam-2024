extends Control

# Progressbar
var progress_enable: bool = false

# Move window around
var following_mouse: bool = false
var anchor_position: Vector2

@onready var card_scene = preload("res://scenes/card.tscn")

func _process(delta):
	if following_mouse:
		global_position = get_global_mouse_position() - anchor_position
	
	# Progress
	if progress_enable:
		$ProgressBar.value = ($Timer.wait_time - $Timer.time_left) / $Timer.wait_time * 100
	elif not $Slot.has_card():
		$ProgressBar.value = 0
		enable_button()

### SIGNALS ###

func _on_quit_pressed():
	close()


func _on_start_pressed():
	if $Slot.has_card():
		$Slot.disable()
		$Slot.delete_card()
		$Timer.start()
		progress_enable = true
		disable_button()


func _on_timer_timeout():
	$Slot.enable()
	progress_enable = false
	
	var slot = $Slot
	var new_card = create_fish_card()
	new_card.reparent(slot)
	new_card.update_position(slot.get_card_position(Vector2.ZERO))
	new_card.z_index = 0
	slot.update_card_support(new_card)


func _on_background_gui_input(event):
	if not (event is InputEventMouseButton): return
	
	if event.is_pressed() and not following_mouse:
		anchor_position = get_global_mouse_position() - global_position
		following_mouse = true
		get_parent().move_child(self, -1) # Move a top of window
	elif event.is_released() and following_mouse:
		following_mouse = false


### REGULAR FUNCTIONS ###

# Close window
func close():
	hide()
	$Slot.disable()
	

# Open window
func open():
	show()
	$Slot.enable()


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


func create_fish_card() -> Card:
	var card = card_scene.instantiate()
	
	card.card_type = "Food"
	card.card_name = "Ramen"
	card.z_index = 1
	
	add_child(card)
	move_child(card, -1)
	return card
