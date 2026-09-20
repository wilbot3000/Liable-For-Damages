extends Area2D

@onready var game_manager: Node = %Gamemanager
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gui: CanvasLayer = $"../../GUI"



func _on_body_entered(_body: Node2D) -> void:
	gui.add_point()
	animation_player.play("pickup_animation")
  
