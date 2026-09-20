extends Area2D
var speed = 100

func _physics_process(delta: float) -> void:
	position += speed * transform.x * delta
func _on_body_entered(body: Node2D) -> void:
	if body == player:
		queue_free()
	queue_free()
