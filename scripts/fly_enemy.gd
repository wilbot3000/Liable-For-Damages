extends CharacterBody2D
var target
var facing
var hit_pos
var detecting
var direction
var FLY_SPEED = 50
var real_area
var can_detectsight = false
var can_detecthidden = false
var start_hidden_timer = true
var go_way
var fleeing = false
var trying_to_attack = false
var random_direction = 0
var idle_can_reset = true
var can_shoot = true
var health = 2
var being_hit = false
var attacking = false
var bullets_instance
var can_die = true
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var noticesight_cooldown: Timer = $noticesight_cooldown
@onready var noticehidden_cooldown: Timer = $noticehidden_cooldown
@onready var idle_random_timer: Timer = $idle_random_timer
@onready var fly_enemysprites: AnimatedSprite2D = $fly_enemysprites
@onready var shooting_cooldown: Timer = $shooting_cooldown
@onready var mouth: Marker2D = $mouth
@onready var shoot_reset: Timer = $shoot_reset
@onready var death_timer: Timer = $death_timer
@onready var fly_collision: CollisionShape2D = $fly_collision
const BUG_BULLET = preload("uid://betk5nmp8xn2a")
@onready var explosion: AudioStreamPlayer2D = $explosion
@onready var shoot: AudioStreamPlayer2D = $shoot



func _ready() -> void:
	randomize()
	nav_agent.velocity_computed.connect(_on_velocity_computed)
	nav_agent.connect("velocity_computed", move_to_destination)
func _physics_process(delta: float) -> void:
	if velocity == Vector2(0, 0) and not detecting and not attacking and not being_hit:
		if random_direction == 0:
			fly_enemysprites.play("buzzleft")
		if random_direction == 1:
			fly_enemysprites.play("buzzmiddle")
		if random_direction == 2:
			fly_enemysprites.play("buzzright")
	if detecting and not attacking and not being_hit:
		if position.x - target.position.x >= 20:
			fly_enemysprites.play("buzzleft")
			random_direction = 0
		if position.x - target.position.x <= -20:
			fly_enemysprites.play("buzzright")
			random_direction = 2
		if position.x - target.position.x < 20 and position.x - target.position.x > -20:
			fly_enemysprites.play("buzzmiddle")
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
	if trying_to_attack:
		FLY_SPEED = 0
	elif !trying_to_attack:
		FLY_SPEED = 30
	if being_hit:
		FLY_SPEED = 0
		shooting_cooldown.stop()
	var next_position = nav_agent.get_next_path_position()
	if fleeing == false:
		go_way = global_position.direction_to(next_position)
	if fleeing == true:
		go_way = -global_position.direction_to(next_position)
	var new_velocity = go_way * delta * FLY_SPEED
	nav_agent.velocity = new_velocity
	move_and_slide()
	if target:
		aim()
		make_path(target.position)
	if detecting == true:
		can_detecthidden = true
		noticehidden_cooldown.stop()
	if detecting == false and start_hidden_timer:
		noticehidden_cooldown.start()
		start_hidden_timer = false
func aim():
	var space_state = get_world_2d().direct_space_state
	for pos in [target.position]:
		var query = PhysicsRayQueryParameters2D.create(position, pos, collision_mask, [self])
		var result = space_state.intersect_ray(query)
		direction = global_position.x - target.global_position.x
		if result:
			hit_pos = result.position
			if result.collider.name == 'player' and can_detectsight:
				detecting = true
				if direction > 1:
					facing = -1
				if direction < 1:
					facing = 1
			else:
				detecting = false
func _on_player_detection_body_entered(body: Node2D) -> void:
	if target:
		can_detectsight = true
		noticesight_cooldown.stop()
	if body.is_in_group("player") and target == null:
		target = body
		can_detectsight = true
		noticesight_cooldown.stop()

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body == target:
		noticesight_cooldown.start()

func _on_noticesight_cooldown_timeout() -> void:
	can_detectsight = false
func _on_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 100)
	move_and_slide()

func make_path(pos: Vector2):
	if can_detectsight and can_detecthidden:
		nav_agent.target_position = pos
func move_to_destination(new_velocity : Vector2) -> void:
	global_position = global_position.move_toward(global_position + new_velocity, FLY_SPEED)


func _on_noticehidden_cooldown_timeout() -> void:
	can_detecthidden = false
	start_hidden_timer = true


func _on_player_dont_gofarther_body_entered(body: Node2D) -> void:
	if body == target:
		trying_to_attack = true


func _on_player_dont_gofarther_body_exited(body: Node2D) -> void:
	if body == target:
		trying_to_attack = false


func _on_player_move_away_body_entered(body: Node2D) -> void:
	if body == target:
		fleeing = true
		trying_to_attack = false

func _on_player_move_away_body_exited(body: Node2D) -> void:
	if body == target:
		fleeing = false
		trying_to_attack = true


func _on_idle_random_timer_timeout() -> void:
	random_direction = randi() % 3
	idle_can_reset = true


func _on_shooting_cooldown_timeout() -> void:
	attacking = true
	bullets_instance = BUG_BULLET.instantiate()
	add_sibling(bullets_instance)
	shoot.play()
	bullets_instance.transform = mouth.global_transform
	bullets_instance.look_at(target.position)
	if position.x - target.position.x >= 20:
		fly_enemysprites.play("shootleft")
		random_direction = 0
		shoot_reset.start()
	if position.x - target.position.x <= -20:
		fly_enemysprites.play("shootright")
		random_direction = 2
		shoot_reset.start()
	if position.x - target.position.x < 20 and position.x - target.position.x > -20:
		fly_enemysprites.play("shootmiddle")
		shoot_reset.start()










func take_damage(weapon_damage: float):
	if can_die:
		health -= weapon_damage
		being_hit = true
		fly_enemysprites.play("explode")
		explosion.play()
		death_timer.start()
		fly_collision.set_deferred("disabled", true)
		can_die = false
func _on_shoot_reset_timeout() -> void:
	attacking = false


func _on_death_timer_timeout() -> void:
	queue_free()
