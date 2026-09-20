extends Node2D

const speed = 60

var direction = 1
var state_machine
var health: float = 3
var being_hit = false
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var slime_sprite: Sprite2D = $slime_sprite
@onready var raycastright: RayCast2D = $raycastright
@onready var raycastleft: RayCast2D = $raycastleft
@onready var animation_player: AnimationPlayer = $AnimationPlayer
func _ready() -> void:
	state_machine = animation_tree["parameters/playback"]
func take_damage(weapon_damage: float):
	being_hit = true
	if health > 1:
		state_machine.travel("slime_hurt")
		health -= weapon_damage
		print("ow")
	elif health <= 1:
		state_machine.travel("slime_death")
		print("bleh D:")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += direction * speed * delta
	if raycastright.is_colliding():
		direction = -1
		slime_sprite.flip_h = true
	if raycastleft.is_colliding():
		direction = 1
		slime_sprite.flip_h = false
	if being_hit == false:
		state_machine.travel("slime_idle")
		
		
func being_hit_true() -> void:
	being_hit = false
