class_name hurtbox
extends Area2D

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	area_entered.connect(
	func _on_area_entered(area: Attackbox) -> void:
		if area == null:
			return
		if owner.has_method("take_damage"):
			owner.take_damage(area.damage)
)
