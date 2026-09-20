extends AnimatableBody2D
@onready var door_sprites: AnimatedSprite2D = $"elevator sprites/door_sprites"
@onready var door_collision_shape: CollisionShape2D = $"door collider/door_collision_shape"
@onready var start_moving: Timer = $start_moving
@onready var door_closing: Timer = $"door closing"
@onready var elevator_particles: GPUParticles2D = $elevator_particles
@onready var elevator_particles_2: GPUParticles2D = $elevator_particles2
@onready var elevator_sounds: AudioStreamPlayer2D = $elevator_sounds
@onready var door_sound: AudioStreamPlayer2D = $door_sound

var can_start = false
var is_closed = false
var SPEED = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	door_collision_shape.set_deferred("disabled", true)
	door_sprites.play("door_open")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if can_start == true:
		position.y = move_toward(position.y, -500, SPEED * delta)
		SPEED = move_toward(SPEED, 50, delta * 7)
func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and is_closed == false:
		door_collision_shape.set_deferred("disabled", false)
		door_closing.start()
		start_moving.start()
		is_closed = true
func _on_door_closing_timeout() -> void:
	door_sprites.play("door closing")
	door_sound.play()

func _on_start_moving_timeout() -> void:
	can_start = true
	elevator_sounds.play()
	elevator_particles.emitting = true
	elevator_particles_2.emitting = true


func _on_door_sprites_animation_finished() -> void:
	if door_sprites.animation == "door closing":
		door_sound.stop()
