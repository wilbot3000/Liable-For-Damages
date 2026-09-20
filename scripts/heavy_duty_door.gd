extends StaticBody2D
@onready var door_collider: CollisionShape2D = $door_collider
@onready var door_opening: Timer = $door_opening
@onready var light_occluder_2d: LightOccluder2D = $LightOccluder2D
@onready var door_sound: AudioStreamPlayer2D = $door_sound
@onready var hiss: AudioStreamPlayer2D = $hiss

@onready var door_sprites: AnimatedSprite2D = $door_sprites
var open = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	door_sprites.play("door_closed")
	light_occluder_2d.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:

	if open:
		door_collider.set_deferred("disabled", true)
		light_occluder_2d.visible = false
	elif !open:
		door_collider.set_deferred("disabled", false)
		light_occluder_2d.visible = true
func open_sesame():
	if open:
		return
	else:
		door_sprites.play("door_opening")
		door_opening.start()
		door_sound.play()
	

func _on_door_opening_timeout() -> void:
	open = true
	door_sound.stop()
	door_sprites.play("door_open")


func _on_door_sprites_frame_changed() -> void:
	if door_sprites.frame == 8:
		hiss.play()
	if door_sprites.frame == 3:
		hiss.play()
