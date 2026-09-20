extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var beep: AudioStreamPlayer2D = $beep
@onready var button_pressed: AudioStreamPlayer2D = $button_pressed
@onready var bepp_timer: Timer = $bepp_timer



var can_click
var already_open


func clicked_on():
	var parent = get_parent()
	if can_click and !already_open:
		button_pressed.play()
		bepp_timer.start()
		animated_sprite_2d.play("activation")
		if parent.has_method("open_sesame"):
			parent.open_sesame()
		for child in get_children():
			if child.has_method("open_sesame"):
				child.open_sesame()
			already_open = true
func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_click = true


func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_click = false

func _highlight():
	animated_sprite_2d.modulate = Color(1.5, 1.5, 1.5)


func un_highlight():
	animated_sprite_2d.modulate = Color(1, 1, 1, 1)


func _on_bepp_timer_timeout() -> void:
	beep.play()
