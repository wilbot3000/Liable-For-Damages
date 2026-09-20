extends Area2D

@onready var timer: Timer = $Timer

var player_is
const damage = 5
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Engine.time_scale = .5
		timer.start()
		player_is = body
func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	player_is.respawn()
