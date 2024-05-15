extends Control
class_name Slot

@export_category("Card Slot")
@export_flags("Bait", "Water", "Map", "Food", "Meal") var card_type: int

var card_types: Array[String] = []
var card_slot: Card = null
var is_disabled: bool = false


func _ready():
	var TYPES = ["Bait", "Water", "Map", "Food", "Meal"]
	
	for i in range(len(TYPES)):
		if (card_type >> i) % 2 == 1:
			card_types.append(TYPES[i])


func _process(delta):
	if card_slot and card_slot.get_parent() != self:
		card_slot = null
		
	if card_slot and not card_slot.following_mouse and card_slot.position != get_card_position(Vector2.ZERO):
		card_slot.global_position = get_card_position(Vector2.ZERO)

### SIGNAL FUNCTIONS ###


### CARD SUPPORT FUNCTIONS ###

# Return if the card can be accepted into the slot
func accept_card(card: Card) -> bool:
	if not is_disabled and card_slot == null:
		return card.card_type in card_types
	else:
		return false


# Return the position of the card
func get_card_position(position: Vector2) -> Vector2:
	return global_position + 2*Vector2.ONE


# Add the card to the support
func add_card(card: Card, with_animation: bool = false):
	card_slot = card
	card.reparent(self)
	
	if with_animation:
		card.update_position(get_card_position(card.global_position))
	else:
		card.global_position = get_card_position(card.global_position)


### REGULAR FUNCTIONS ###

func get_card() -> Card:
	return card_slot
	

func has_card() -> bool:
	return card_slot != null


func remove_card():
	card_slot = null


func delete_card():
	card_slot.queue_free()
	card_slot = null


func lock_card():
	card_slot.disable_drag()


func unlock_card():
	card_slot.enable_drag()


func disable():
	is_disabled = true
	$Area2D/CollisionShape2D.set_deferred("disabled", true)


func enable():
	is_disabled = false
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
