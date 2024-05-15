extends UIWindow

# Progressbar
var progress_enable: bool = false

@onready var slot1: Slot = $Slot1
@onready var slot2: Slot = $Slot2
@onready var slots: Array[Slot] = [slot1, slot2]
@onready var database: Database = get_node("/root/Database")
@onready var text_theme: Theme = load("res://themes/card.tres")

var nb_active_slots: int = 2 

var recipe_name: String
var recipe: Array
var recipe_description: Array
var recipe_step: int = -1
var recipe_nb_slots: int = 1

func _ready():
	super()
	setup_one_slot()
	update_recipe_layout()


func _process(delta):
	super(delta)
	
	# Recipe not started
	if recipe_step == 0 and not slot1.has_card() and not progress_enable:
		delete_recipe()
		update_recipe_layout()
	
	# Recipe started
	if recipe_step == -1 and slot1.has_card():
		var recipe_exists = find_recipe(slot1.get_card().card_name)
		if recipe_exists:
			recipe_step = 0
			update_recipe_layout()
	
	# 
	if recipe_nb_slots != nb_active_slots and not slot2.has_card():
		setup_slots(recipe_nb_slots)
	
	if not progress_enable and are_slot_correct():
		enable_button()
	else:
		disable_button()
	
	if progress_enable:
		$ProgressBar.value = ($Timer.wait_time - $Timer.time_left) / $Timer.wait_time * 100
	elif recipe_step >= 1:
		$ProgressBar.value = 100
	else:
		$ProgressBar.value = 0

### SIGNALS ###

func _on_start_pressed():
	progress_enable = true
	$Timer.start()
	
	slot1.disable()
	slot2.disable()
	
	delete_food_cards()


func _on_timer_timeout():
	progress_enable = false
	
	slot1.enable()
	if nb_active_slots > 1:
		slot2.enable()
	
	recipe_step += 1
	if recipe_step >= recipe.size():
		end_recipe()
		return
	
	recipe_nb_slots = recipe[recipe_step].size()
	$Start/Label.text = "Add Ingredient"


### REGULAR FUNCTIONS ###

# Close window
func close():
	super()
	slot1.disable()


# Open window
func open():
	super()
	slot1.enable()
	
	if nb_active_slots > 1:
		slot2.enable()


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


func setup_one_slot():
	nb_active_slots = 1
	
	slot2.disable()
	slot2.hide()
	
	slot1.position = Vector2(300, 46)


func setup_two_slots():
	nb_active_slots = 2
	
	slot2.enable()
	slot2.show()
	
	slot1.position = Vector2(250, 46)
	slot2.position = Vector2(350, 46)


func setup_slots(nb_slots: int):
	if nb_slots == 1:
		setup_one_slot()
	else:
		setup_two_slots()


func are_slot_correct():
	if recipe_step == -1: return
	var step = recipe[recipe_step]
	
	# 1 slot
	if recipe_nb_slots == 1:
		return slot1.has_card() and slot1.get_card().card_name == step[0]
	
	# 2 slots
	if not slot1.has_card() or not slot2.has_card():
		return false
	
	var card1 = slot1.get_card().card_name
	var card2 = slot2.get_card().card_name
	return (card1 == step[0] and card2 == step[1]) or (card1 == step[1] and card2 == step[0]) 


func delete_food_cards():
	var step = recipe[recipe_step]

	for i in step.size():
		slots[i].delete_card()


func end_recipe():
	var meal = create_meal_card()
	slot1.add_card(meal, true)
	meal.z_index = 0
	
	# Prepare for next meal
	delete_recipe()
	update_recipe_layout()
	setup_one_slot()
	$Start/Label.text = "Start Cooking"


func create_meal_card() -> Card:
	var card = database.create_card_by_name(recipe_name)
	card.z_index = 1
	
	add_child(card)
	move_child(card, -1)
	return card


func find_recipe(fish_name: String) -> bool:
	var recipe_dict = database.get_recipe_data(fish_name)
	
	if recipe_dict == {}:
		return false
	
	recipe_name = recipe_dict["name"]
	recipe = recipe_dict["recipe"]
	recipe_description = recipe_dict["description"]
	recipe_nb_slots = recipe[0].size()
	
	return true


func delete_recipe():
	recipe_name = ""
	recipe = []
	recipe_description = []
	recipe_nb_slots = 1
	recipe_step = -1


func update_recipe_layout():
	$RecipeLabel/RecipeName.text = recipe_name
	
	# Remove all labels
	for n in $RecipeGrid.get_children():
		$RecipeGrid.remove_child(n)
		n.queue_free()
	
	# Add new labels
	for i in recipe_description.size():
		var number = Label.new()
		number.text = str(i+1) + '-'
		number.theme = text_theme
		$RecipeGrid.add_child(number)
		
		var desc = Label.new()
		desc.text = recipe_description[i][0]
		desc.theme = text_theme
		$RecipeGrid.add_child(desc)
		
		var blank = Label.new()
		blank.text = " "
		blank.theme = text_theme
		$RecipeGrid.add_child(blank)
		
		var line = Label.new()
		line.text = "-> " + recipe_description[i][1]
		line.theme = text_theme
		$RecipeGrid.add_child(line) 
