extends Node2D
var start_fade = false
@onready var sprite_2d: Sprite2D = $Sprite2D
var fade = 0
var can_timer = true
var label_step = 0
@onready var label: Label = $Label
@onready var timer: Timer = $Sprite2D/Timer

func _physics_process(delta: float) -> void:
	if label_step == 1:
		label.text = "Hi"
		label.visible = true
	if label_step == 2:
		label.text = "Thanks for playing"
	if label_step == 3:
		label.text = "Hope you liked it"
	if label_step == 4:
		label.text = "You'll go back"
	if label_step == 5:
		label.text = "bye"
	if label_step == 6:
		get_tree().change_scene_to_file("res://scenes/start.tscn")
		Global.final_cutscene = false
	if start_fade:
		sprite_2d.self_modulate = Color(1, 1, 1, fade)
		fade = move_toward(fade, 1, delta * 1)
		if can_timer:
			timer.start()
			can_timer = false
func _on_animated_sprite_2d_animation_finished() -> void:
	start_fade = true


func _on_timer_timeout() -> void:
	label_step += 1
