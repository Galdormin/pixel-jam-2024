extends Node

# Load SignalBus
@onready var signal_bus: SignalBus = get_node("/root/SignalBus")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	signal_bus.on_map_change.connect(_on_map_change)
	signal_bus.on_unlock_plant.connect(_on_unlock_plant)
	
	$Window/HelmWindow.close()
	$Window/WaterWindow.close()
	$Window/FishingWindow.close()
	$Window/WheatWindow.close()
	$Window/KitchenWindow.close()
	$Window/CarrotWindow.close()
	$Window/CabbageWindow.close()
	
	show_menu()
	$ChefDiscussion.load_story()


### SIGNALS ###

func _on_map_change(map_name: String):
	$Background.texture = load("res://assets/background/" + map_name.to_lower() + ".png")


func _on_unlock_plant(plant_name: String):
	if plant_name == "Carrot":
		$Boat/CarrotButton.show()
	elif plant_name == "Cabbage":
		$Boat/CabbageButton.show()


func _on_helm_button_pressed():
	$Window/HelmWindow.open()


func _on_water_button_pressed():
	$Window/WaterWindow.open()


func _on_fish_button_pressed():
	$Window/FishingWindow.open()


func _on_wheat_button_pressed():
	$Window/WheatWindow.open()


func _on_kitchen_button_pressed():
	$Window/KitchenWindow.open()


func _on_carrot_button_pressed():
	$Window/CarrotWindow.open()


func _on_cabbage_button_pressed():
	$Window/CabbageWindow.open()


func _on_chef_button_pressed():
	$ChefDiscussion.open()


func _on_start_pressed():
	hide_menu()


func _on_quit_pressed():
	get_tree().quit()


func _on_menu_button_pressed():
	if $Menu.hidden:
		show_menu()
	else:
		hide_menu()


### FUNCTIONS ###

func hide_ui():
	$Window.hide()
	$Drawer.hide()
	$ChefDiscussion.hide()
	$InfoPopup.hide()
	
	$MenuButton.hide()
	
	for button in $Boat.get_children():
		button.disabled = true


func show_ui():
	$Window.show()
	$Drawer.show()
	$ChefDiscussion.show()
	$InfoPopup.show()
	
	$MenuButton.show()
	
	for button in $Boat.get_children():
		button.disabled = false

func show_menu():
	$Menu.show()
	hide_ui()


func hide_menu():
	$Menu.hide()
	show_ui()
