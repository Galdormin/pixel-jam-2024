extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$HelmWindow.close()
	$WaterWindow.close()
	$FishingWindow.close()


func _on_helm_button_pressed():
	$HelmWindow.open()


func _on_water_button_pressed():
	$WaterWindow.open()


func _on_fish_button_pressed():
	$FishingWindow.open()
