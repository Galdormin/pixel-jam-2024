extends Panel


@onready var signal_bus: SignalBus = get_node("/root/SignalBus")


var tween_opacity: Tween

var current_card: Card
var displayed: bool = false


func _ready():
	hide()
	hide_popup()
	signal_bus.on_mouse_entered_card.connect(_on_mouse_entered_card)
	signal_bus.on_mouse_exited_card.connect(_on_mouse_exited_card)


### SIGNALS ###

func _on_mouse_entered_card(card: Card):
	$TimerBefore.start()
	$TimerAfter.stop()
	current_card = card


func _on_mouse_exited_card(card: Card):
	$TimerBefore.stop()
	$TimerAfter.start()
	if card == current_card:
		current_card = null


func _on_timer_before_timeout():
	update_card(current_card)
	show_popup()


func _on_timer_after_timeout():
	hide_popup()


### FUNCTIONS ###

func show_popup():
	show()
	if tween_opacity and tween_opacity.is_running():
		tween_opacity.kill()
	var col = Color(1,1,1,1)
	tween_opacity = create_tween().set_ease(Tween.EASE_OUT)
	tween_opacity.tween_property(self, "modulate", col, 0.2)


func hide_popup():
	if tween_opacity and tween_opacity.is_running():
		tween_opacity.kill()
	var col = Color(1,1,1,0)
	tween_opacity = create_tween().set_ease(Tween.EASE_OUT)
	tween_opacity.tween_property(self, "modulate", col, 0.2)


func update_card(card: Card):
	$Name.text = card.card_name
	$Type.text = card.card_type
	$Description.text = card.card_description

