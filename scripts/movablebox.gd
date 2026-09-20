extends RigidBody2D
class_name Movablebox
var health = 3
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func take_damage(weapon_damage: float):
	if health > 1:
		animation_player.play("damage")
		health -= weapon_damage
	elif health <= 1:
		queue_free()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body == Enemy_attack:
		if health > 1:
			animation_player.play("damage")
			health -= 2
		elif health <= 1:
			queue_free()
