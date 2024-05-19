extends Node


@onready var card_scene = preload("res://scenes/card.tscn")

var _card_data: Array
var _fish_data: Dictionary
var _recipe_data: Dictionary
var _chapter_data: Dictionary


func _ready():
	_card_data = load_database("res://data/card_database.json")["data"]
	_fish_data = load_database("res://data/fishing_database.json")
	_recipe_data = load_database("res://data/recipe_database.json")
	_chapter_data = load_database("res://data/chapters_database.json")


### FUNCTIONS ###

func load_database(path: String) -> Dictionary:
	var json_as_text = FileAccess.get_file_as_string(path)
	var json_as_dict = JSON.parse_string(json_as_text)
	
	return json_as_dict


func get_card_info_by_name(card_name: String) -> Dictionary:
	for card in _card_data:
		if card["name"] == card_name:
			return card

	return {}


func create_card_by_name(card_name: String) -> Card:
	var card: Card = card_scene.instantiate()
	var card_info: Dictionary = get_card_info_by_name(card_name)
	
	card.card_name = card_info["name"]
	card.card_type = card_info["type"]
	card.card_description = card_info["description"]
	
	return card


func get_fish_from_bait(bait_name: String, biome_name: String) -> String:
	return _fish_data[biome_name][bait_name]


func get_recipe_data(fish_name: String) -> Dictionary:
	if not fish_name in _recipe_data:
		return {}
	
	return _recipe_data[fish_name]


func get_chapter_order() -> Array:
	return _chapter_data["chapter-order"]


func get_chapter_data(chapter_name: String) -> Dictionary:
	return _chapter_data["chapters"][chapter_name]
