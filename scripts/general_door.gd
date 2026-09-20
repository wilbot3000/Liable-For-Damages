extends StaticBody2D
@onready var door_opening: Timer = $door_opening
@onready var door_collider: CollisionShape2D = $door_collider
@onready var door_sprites: AnimatedSprite2D = $door_sprites
@onready var door_sound: AudioStreamPlayer2D = $door_sound

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
		door_sprites.play("door_opening")
		door_opening.start()
		door_sound.play()
	

func _on_door_opening_timeout() -> void:
	open = true
	door_sound.stop()
