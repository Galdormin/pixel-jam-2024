extends Control

# Progressbar
var progress_enable: bool = false

# Move window around
var following_mouse: bool = false
var anchor_position: Vector2



func _process(delta):
	if following_mouse:
		global_position = get_global_mouse_position() - anchor_position
	
	if progress_enable:
		$ProgressBar.value = ($Timer.wait_time - $Timer.time_left) / $Timer.wait_time * 100
	else:
		$ProgressBar.value = 0

### SIGNALS ###

func _on_quit_pressed():
	close()


func _on_naviguate_pressed():
	if $MapSlot.card_slot:
		$MapSlot.lock()
		$Timer.start()
		progress_enable = true


func _on_timer_timeout():
	$MapSlot.delete_card()


func _on_background_gui_input(event):
	if not (event is InputEventMouseButton): return
	
	if event.is_pressed() and not following_mouse:
		anchor_position = get_global_mouse_position() - global_position
		following_mouse = true
	elif event.is_released() and following_mouse:
		following_mouse = false


### REGULAR FUNCTIONS ###

# Close window
func close():
	hide()
	$MapSlot/Area2D/CollisionShape2D.set_deferred("disabled", true)
	

# Open window
func open():
	show()
	$MapSlot/Area2D/CollisionShape2D.set_deferred("disabled", false)
