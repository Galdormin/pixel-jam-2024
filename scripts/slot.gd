extends Control

@export_flags("Plant", "Water", "Map", "Food") var card_type: int

var card_types: Array[String] = []
var card_slot: Card = null


func _ready():
	var TYPES = ["Plant", "Water", "Map", "Food"]
	
	for i in range(len(TYPES)):
		if (card_type >> i) % 2 == 1:
			card_types.append(TYPES[i])


# Return if the card can be accepted into the slot
func accept_card(card: Card) -> bool:
	if card_slot == null:
		return card.card_type in card_types
	else:
		return false


# Return the position of the card
func get_card_position(position: Vector2) -> Vector2:
	return global_position + 2*Vector2.ONE


# Update the card
func update_card_support(card: Card):
	card_slot = card


func get_card() -> Card:
	return card_slot


func remove_card():
	card_slot = null


func delete_card():
	card_slot.queue_free()
	card_slot = null


func lock():
	card_slot.disable_drag()


func unlock():
	card_slot.enable_drag()
