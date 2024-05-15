extends Button

class_name Card 

# Parameters
@export_category("Card")
@export var card_name: String = "Card"
@export_enum("Bait", "Water", "Meal", "Map", "Food") var card_type: String
@export_multiline var card_description: String = "Lorem ipsum dolor es."

@export_category("Oscillator")
@export var spring: float = 150.0
@export var damp: float = 10.0
@export var velocity_multiplier: float = 0.5

# Load SignalBus
@onready var signal_bus: SignalBus = get_node("/root/SignalBus")

# Tweens
var tween_position: Tween

# Parameters for dragging the mouse around
var can_be_dragged: bool = true
var following_mouse: bool = false
var anchor_position: Vector2
var initial_position: Vector2

# Parameters for the rotation of the mouse
var stabilisation: bool = false
var displacement: float = 0.0 
var oscillator_velocity: float = 0.0
var last_position: Vector2
var velocity: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	$Name.text = card_name
	var asset_name = card_name.to_lower().replace(' ', '_')
	$Background.texture = load("res://assets/cards/background/" + card_type.to_lower() + ".png")
	$Shadow.texture = load("res://assets/cards/art/" + asset_name + ".png")
	$Art.texture = load("res://assets/cards/art/" + asset_name + ".png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follow_mouse(delta)
	rotate_velocity(delta)


### SIGNALS ###

func _on_button_down():
	if not can_be_dragged: return
	# Enable dragging
	following_mouse = true
	initial_position = global_position

	# Find mouse relative position to card
	var mouse_pos: Vector2 = get_global_mouse_position()
	anchor_position = mouse_pos - global_position
	
	# Go to front among other card 
	var parent_node = get_parent()
	parent_node.move_child(self, -1)
	
	# Show to front
	z_index = 11 # TODO: put in constant


func _on_button_up():
	if not can_be_dragged: return
	# Disable dragging
	following_mouse = false
	stabilisation = true
	
	var areas = $ActivationArea.get_overlapping_areas()
	# Remove other cards
	areas = areas.filter(func(area): return not (area.get_parent() is Card))
	# Sort by z_index
	areas.sort_custom(func(a, b): return get_absolute_z_index(a) > get_absolute_z_index(b))
	
	if areas:
		var support = areas[0].get_parent()
		
		if support.accept_card(self):
			support.add_card(self)
		else:
			reset_position()
	else:
		reset_position()
	
	# Show to front
	z_index = 0 # TODO: put in constant


func _on_mouse_entered():
	signal_bus.on_mouse_entered_card.emit(self)


func _on_mouse_exited():
	signal_bus.on_mouse_exited_card.emit(self)


### FUNCTIONS ###

func enable_drag():
	can_be_dragged = true


func disable_drag():
	can_be_dragged = false


# Follow the mouse when dragging
func follow_mouse(delta) -> void:
	if not following_mouse: return
	var mouse_pos: Vector2 = get_global_mouse_position()
	global_position = mouse_pos - anchor_position


# Rotate the card when dragging
func rotate_velocity(delta: float) -> void:
	if not following_mouse and not stabilisation: return
	var center_pos: Vector2 = global_position - anchor_position

	# Compute the velocity
	velocity = (position - last_position) / delta
	last_position = position
	
	oscillator_velocity += velocity.normalized().x * velocity_multiplier
	
	# Oscillator stuff
	var force = -spring * displacement - damp * oscillator_velocity
	oscillator_velocity += force * delta
	displacement += oscillator_velocity * delta
	
	if stabilisation and abs(displacement) < PI/36:
		stabilisation = false
		displacement = 0
		
	rotation = displacement


# Reset card position to initial position
func reset_position():
	update_position(initial_position)


func update_position(position: Vector2):
	if tween_position and tween_position.is_running():
		tween_position.kill()
	tween_position = create_tween().set_ease(Tween.EASE_OUT)
	tween_position.tween_property(self, "global_position", position, 0.2)


func get_absolute_z_index(target: CanvasItem) -> int:
	var node = target;
	var z_index = 0;
	while node and node.is_class('CanvasItem'):
		z_index += node.z_index;
		if !node.z_as_relative:
			break;
		node = node.get_parent();
	return z_index;
