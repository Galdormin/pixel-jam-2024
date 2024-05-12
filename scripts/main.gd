extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$HelmWindow.close()


func _on_button_pressed():
	$HelmWindow.open()
