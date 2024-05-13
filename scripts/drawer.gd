extends Control

@export_category("Drawer")
@export var grid_size: Vector2 = Vector2(32.5, 20)


# Constants Drawer Movement
const MARGIN = 50
@onready var MAX = 600 - MARGIN
@onready var MIN = 600 - $TextureRect.size.y

# Drawer mouvement
var following_mouse: bool = false
var anchor_position: Vector2
var tween_position: Tween


func _process(delta):
	if following_mouse:
		var mouse_position = get_global_mouse_position() - anchor_position
		position.y = min(MAX, max(MIN, mouse_position.y))


### SIGNALS FUNCTIONS ###

func _on_handle_gui_input(event):
	if not(event is InputEventMouseButton): return
	
	if event.double_click:
		toggle_drawer()
		following_mouse = false
	elif event.is_pressed() and not following_mouse:
		anchor_position = get_global_mouse_position() - global_position
		following_mouse = true
	elif event.is_released() and following_mouse:
		following_mouse = false

### REGULAR FUNCTIONS ###

func accept_card(card: Card) -> bool:
	return true


func get_card_position(pos: Vector2) -> Vector2:
	return round(pos / grid_size) * grid_size


func update_card_support(card: Card):
	pass	


func open_position(pos: int):
	var pos_vec = Vector2(position.x, pos)
	if tween_position and tween_position.is_running():
		tween_position.kill()
	tween_position = create_tween().set_ease(Tween.EASE_OUT)
	tween_position.tween_property(self, "position", pos_vec, 0.5)


func toggle_drawer():
	if MAX - position.y > 100:
		open_position(MAX)
	else:
		open_position(MIN)


