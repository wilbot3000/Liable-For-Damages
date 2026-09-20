extends Node2D
@onready var tentacle_sprites: AnimatedSprite2D = $"tentacle sprites"
@onready var attack_area: Area2D = $attack_area
var damage = 4
func _ready() -> void:
	randomize()
	var random = randi() % 3
	
	if random == 0:
		tentacle_sprites.play("start1")
	if random == 1:
		tentacle_sprites.play("start2")
	if random == 2:
		tentacle_sprites.play("start3")


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage)
