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

func _on_quit_pressed():
	close()


func _on_timer_timeout():
	var slots = get_empty_slots()
	
	if slots:
		var slot = slots[0]
		
		var new_card = create_water()
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
	elif not event.is_released() and following_mouse:
		following_mouse = false


### REGULAR FUNCTIONS ###

# Close window
func close():
	hide()
	$WaterSlot1.disable()
	$WaterSlot2.disable()
	$WaterSlot3.disable()
	

# Open window
func open():
	show()
	$WaterSlot1.enable()
	$WaterSlot2.enable()
	$WaterSlot3.enable()


func get_empty_slots() -> Array:
	var slots: Array = []
	
	if not $WaterSlot1.has_card():
		slots.append($WaterSlot1)
	
	if not $WaterSlot2.has_card():
		slots.append($WaterSlot2)
	
	if not $WaterSlot3.has_card():
		slots.append($WaterSlot3)
	
	return slots

func create_water() -> Card:
	var card = card_scene.instantiate()
	
	card.card_type = "Water"
	card.card_name = "Aqua"
	card.z_index = 1
	
	add_child(card)
	move_child(card, -1)
	return card
	
