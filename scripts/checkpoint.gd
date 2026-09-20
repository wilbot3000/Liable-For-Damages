extends Node2D
var new_spawn = Vector2.ZERO

func _on_respawn_point_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		new_spawn = global_position
		body.update_spawn_point(new_spawn)
