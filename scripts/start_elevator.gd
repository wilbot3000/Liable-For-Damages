extends AnimatableBody2D
@onready var door_collision_shape: CollisionShape2D = $"door collider/door_collision_shape"
@onready var door_sprites: AnimatedSprite2D = $"elevator sprites/door_sprites"
@onready var door_open: Timer = $door_open
@onready var elevator_sounds: AudioStreamPlayer2D = $elevator_sounds
@onready var hiss: AudioStreamPlayer2D = $hiss
@onready var door_sound: AudioStreamPlayer2D = $door_sound


var can_start = false
var is_closed = false
var SPEED = 50
var movement
var timer_start = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	door_collision_shape.set_deferred("disabled", false)
	door_sprites.play("door_closed")
	can_start = true
	movement = position.y - 80
	elevator_sounds.play(2)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	if can_start == true:
		position.y = move_toward(position.y, movement, SPEED * delta)
		SPEED = move_toward(SPEED, 0, delta * 15)
	
	if position.y <= movement + 7 and elevator_sounds.pitch_scale > 0:
		elevator_sounds.pitch_scale = move_toward(elevator_sounds.pitch_scale, 0.1, delta)
	if position.y == movement and timer_start:
		door_open.start()
		hiss.play()
		timer_start = false
func _on_door_open_timeout() -> void:
	door_sprites.play("door_opening")
	door_sound.play()
	elevator_sounds.stop()
func _on_door_sprites_animation_finished() -> void:
	door_collision_shape.set_deferred("disabled", true)
	door_sound.stop()
