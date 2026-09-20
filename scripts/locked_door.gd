extends AnimatedSprite2D
var can_click
var modifier = 1
var play_change
var can_open = false
var door_open = false
@onready var black: Sprite2D = $black
@onready var animation_timer: Timer = $animation_timer
@onready var door_timer: Timer = $door_timer
@onready var marker_2d: Marker2D = $Marker2D
@onready var player_character: player = $"../../../player"
@onready var door_opensound: AudioStreamPlayer2D = $door_open

func _ready() -> void:
	black.hide()
func _physics_process(delta: float) -> void:
	if can_open == true and door_open == false:
		play("closed_unlocked")
	elif can_open == false and door_open == false:
		play("closed_locked")
	black.global_position = Global.player_position
	if play_change:
		modifier = move_toward(modifier, 0, delta * .75)
	if modifier <= 0:
		black.hide()
		modifier = 1
		play_change = false
	black.modulate = Color(1, 1, 1, modifier)
func clicked_on():
	if can_click and can_open:
		black.show()
		animation_timer.start()
		player_character.global_position = marker_2d.global_position
		door_opensound.play()
		door_open = true
		door_timer.start()
func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_click = true


func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_click = false

func _highlight():
	modulate = Color(1.5, 1.5, 1.5)


func un_highlight():
	modulate = Color(1, 1, 1, 1)



func _on_animation_timer_timeout() -> void:
	play_change = true

func open_sesame():
	can_open = true

func _on_door_timer_timeout() -> void:
	door_open = false
