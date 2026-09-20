extends AnimatedSprite2D
var interface_open
@onready var sign_interface: Sprite2D = $sign_interface
var can_clicked
@onready var collision_shape_2d: CollisionShape2D = $mouse_detector/CollisionShape2D
@onready var button_pressed: AudioStreamPlayer2D = $button_pressed



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sign_interface.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	sign_interface.global_position = Global.player_position

	if interface_open == true:
		sign_interface.show()
		get_tree().paused = true
	if interface_open == false:
		sign_interface.hide()
		get_tree().paused = false
		interface_open = null

func clicked_on():
	if can_clicked:
		interface_open = true
		collision_shape_2d.disabled = true
func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_clicked = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_clicked = false






func _highlight():
	modulate = Color(1.5, 1.5, 1.5)


func un_highlight():
	modulate = Color(1, 1, 1, 1)


func _on_sign_interface_exit_pressed() -> void:
	sign_interface.hide()
	interface_open = false
	collision_shape_2d.disabled = false
	button_pressed.play()
