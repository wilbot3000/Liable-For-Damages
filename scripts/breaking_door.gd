extends StaticBody2D
@onready var door_opening: Timer = $door_opening
@onready var door_collider: CollisionShape2D = $door_collider
@onready var door_sprites: AnimatedSprite2D = $door_sprites
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var door_sound: AudioStreamPlayer2D = $door_sound
@onready var zap: AudioStreamPlayer2D = $zap

var open = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	door_sprites.play("door_closed")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	if open:
		door_collider.set_deferred("disabled", true)
		door_sprites.play("door_open")
	elif !open:
		door_collider.set_deferred("disabled", false)
func open_sesame():
	if open:
		return
	else:
		door_sprites.play("door_breaking")
		door_sound.play()
func can_open():
	door_sprites.play("door_open")
	door_opening.start()
func _on_door_opening_timeout() -> void:
	open = true


func _on_door_sprites_animation_finished() -> void:
	if door_sprites.animation == "door_breaking":
		gpu_particles_2d.emitting = true
		door_sound.stop()
		zap.play()
