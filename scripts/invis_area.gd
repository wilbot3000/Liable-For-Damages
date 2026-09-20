extends Area2D
@onready var tile_map_layer: TileMapLayer = $TileMapLayer


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		tile_map_layer.modulate = Color(1, 1, 1, 0.3)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		tile_map_layer.modulate = Color(1,1,1,1)
