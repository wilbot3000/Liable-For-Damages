extends CharacterBody2D
var target
var facing
var hit_pos
var detecting
var direction
var FLY_SPEED = 50
var trying_to_attack = false
var random_direction = 0
var idle_can_reset = true
var can_shoot = true
var health = 2
var being_hit = false
var attacking = false

@onready var idle_random_timer: Timer = $idle_random_timer
@onready var shooting_cooldown: Timer = $shooting_cooldown
@onready var mouth: Marker2D = $mouth
@onready var shoot_reset: Timer = $shoot_reset
@onready var death_timer: Timer = $death_timer
@onready var shooter_collision: CollisionShape2D = $shooter_collision
@onready var tentacles_sprites: AnimatedSprite2D = $tentacles_sprites
const TENTACLE_SHOT = preload("uid://dh76loh3v3s0e")
@onready var shoot: AudioStreamPlayer2D = $shoot
@onready var explode: AudioStreamPlayer2D = $explode




func _ready() -> void:
	randomize()
func _physics_process(delta: float) -> void:
	if not detecting and not attacking and not being_hit:
		if random_direction == 0:
			tentacles_sprites.play("buzzleft")
		if random_direction == 1:
			tentacles_sprites.play("buzzmiddle")
		if random_direction == 2:
			tentacles_sprites.play("buzzright")
	if detecting and not attacking and not being_hit:
		if target:
			if position.x - target.position.x >= 20:
				tentacles_sprites.play("buzzleft")
				random_direction = 0
			if position.x - target.position.x <= -20:
				tentacles_sprites.play("buzzright")
				random_direction = 2
			if position.x - target.position.x < 20 and position.x - target.position.x > -20:
				tentacles_sprites.play("buzzmiddle")
	if can_shoot and detecting and not being_hit:
		shooting_cooldown.start()
		can_shoot = false
	elif !detecting:
		shooting_cooldown.stop()
		can_shoot = true
	if velocity == Vector2(0, 0) and idle_can_reset:
		idle_random_timer.start()
		idle_can_reset = false
	if velocity != Vector2(0, 0):
		idle_random_timer.stop()
		idle_can_reset = true
	if being_hit:
		shooting_cooldown.stop()
	if target:
		aim()
func aim():
	var space_state = get_world_2d().direct_space_state
	for pos in [target.position]:
		var query = PhysicsRayQueryParameters2D.create(position, pos, collision_mask, [self])
		var result = space_state.intersect_ray(query)
		direction = global_position.x - target.global_position.x
		if result:
			hit_pos = result.position
			if result.collider.name == 'player':
				detecting = true
			else:
				detecting = false
func _on_player_detection_body_entered(body: Node2D) -> void:
	if target:
		return
	if body.is_in_group("player"):
		target = body

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body == target:
		target = null










func _on_idle_random_timer_timeout() -> void:
	random_direction = randi() % 3
	idle_can_reset = true


func _on_shooting_cooldown_timeout() -> void:
	attacking = true
	var bullet_instance = TENTACLE_SHOT.instantiate()
	if target:
		owner.add_child(bullet_instance)
		shoot.play()
		bullet_instance.transform = mouth.global_transform
		bullet_instance.look_at(target.position)
		if position.x - target.position.x >= 20:
			tentacles_sprites.play("shootleft")
			random_direction = 0
			shoot_reset.start()
		if position.x - target.position.x <= -20:
			tentacles_sprites.play("shootright")
			random_direction = 2
			shoot_reset.start()
		if position.x - target.position.x < 20 and position.x - target.position.x > -20:
			tentacles_sprites.play("shootmiddle")
			shoot_reset.start()










func take_damage(weapon_damage: float):
	health -= weapon_damage
	being_hit = true
	tentacles_sprites.play("explode")
	explode.play()
	death_timer.start()
	shooter_collision.set_deferred("disabled", true)
func _on_shoot_reset_timeout() -> void:
	attacking = false


func _on_death_timer_timeout() -> void:
	queue_free()
