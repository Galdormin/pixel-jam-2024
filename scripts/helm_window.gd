extends Control

# Progressbar
var progress_enable: bool = false

# Move window around
var following_mouse: bool = false
var anchor_position: Vector2


func _process(delta):
	if following_mouse:
		global_position = get_global_mouse_position() - anchor_position
	
	# Progress
	if progress_enable:
		$ProgressBar.value = ($Timer.wait_time - $Timer.time_left) / $Timer.wait_time * 100
		
	if not $MapSlot.has_card():
		$ProgressBar.value = 0

### SIGNALS ###

func _on_quit_pressed():
	close()


func _on_naviguate_pressed():
	if $MapSlot.has_card():
		$MapSlot.lock_card()
		$Timer.start()
		progress_enable = true
		disable_button()


func _on_timer_timeout():
	$MapSlot.unlock_card()
	progress_enable = false
	enable_button()


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
	$MapSlot.disable()
	

# Open window
func open():
	show()
	$MapSlot.enable()


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
