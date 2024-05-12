extends Control



func close():
	hide()
	$FoodSlot/Area2D/CollisionShape2D.set_deferred("disabled", true)
	

func open():
	show()
	$FoodSlot/Area2D/CollisionShape2D.set_deferred("disabled", false)


func _on_quit_pressed():
	close()


func _on_start_pressed():
	$FoodSlot.lock()
	$Timer.start()


func _on_timer_timeout():
	$FoodSlot.delete_card()
