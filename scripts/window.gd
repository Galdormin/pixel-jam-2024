class_name UIWindow extends NinePatchRect


# Move window around
var following_mouse: bool = false
var anchor_position: Vector2


func _ready():
	pass # Replace with function body.


func _process(delta):
	if following_mouse:
		global_position = get_global_mouse_position() - anchor_position


### SIGNALS ###

func _on_quit_pressed():
	close()


func _on_gui_input(event: InputEvent):
	if not (event is InputEventMouseButton): return
	
	if event.is_pressed() and not following_mouse:
		anchor_position = get_global_mouse_position() - global_position
		following_mouse = true
		move_to_front()
	elif not event.is_pressed() and following_mouse:
		following_mouse = false


### FUNCTIONS ###

func close():
	hide()


func open():
	show()
	move_to_front()

