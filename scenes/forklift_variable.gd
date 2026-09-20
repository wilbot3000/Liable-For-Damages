extends Sprite2D
@onready var animation_player: AnimationPlayer = $forklifter/AnimationPlayer
func _ready() -> void:
	animation_player.play("go_up")
func go_up():
	animation_player.play("go_up")
	print("up")
func go_down():
	animation_player.play("go_down")
	print("down")
