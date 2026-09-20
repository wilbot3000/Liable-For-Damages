extends Area2D

func _ready() -> void:
	area_entered.connect(
	func _on_area_entered(area: Area2D) -> void:
		if area is Enemy_attack:
			if area == null:
				return
			if owner.has_method("take_damage"):
				owner.take_damage(area.damage)
			Global.attacked = true
)
