extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var thump: AudioStreamPlayer2D = $thump
@onready var zap: AudioStreamPlayer2D = $zap


var can_click
var already_open
var open = false

func clicked_on():
	var parent = get_parent()
	if can_click and !already_open:
		if open == false:
			animated_sprite_2d.play("open")
			thump.play()
			timer.start()
		if open == true:
			animated_sprite_2d.play("broken")
			zap.play()
			already_open = true
			gpu_particles_2d.emitting = true
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


func _on_timer_timeout() -> void:
	open = true
