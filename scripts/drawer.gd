extends Control

@export var grid_size: Vector2 = Vector2(32.5, 20)

# Drawer mouvement
var following_mouse: bool = false
var initial_position: Vector2


func _ready():
	initial_position = global_position


func _process(delta):
	if following_mouse:
		var mouse_position = get_global_mouse_position()
		position.y = min(600-50, max(initial_position.y, mouse_position.y))


func accept_card(card: Card) -> bool:
	return true


func get_card_position(position: Vector2) -> Vector2:
	return round(position / grid_size) * grid_size


func update_card_support(card: Card):
	pass	


func _on_handle_button_down():
	following_mouse = true


func _on_handle_button_up():
	following_mouse = false
