extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var deltavar
var target
var hit_pos
var facing = 0
var detecting = false
var health: float = 40
var being_hit = false
var attacking = false
var current_state
var SPEED = 75
var direction = 0
var Idle_action = 0
var dashing = false
var actually_dashing = false
var dashing_timer = 0
var can_turn = true
var ready_to_dash = true
var can_idlize = true
var idle_can_walk
var idle_walk = 0
var walk_randomize
@onready var chomper_animation: AnimationPlayer = $Chomper_animation
@onready var chompersprite: Sprite2D = $Chompersprite
@onready var chomper_detector: Area2D = $Chompersprite/Chomper_Detector
@onready var hit_particles: GPUParticles2D = $"hit particles"
@onready var death_particles: GPUParticles2D = $"death particles"
@onready var chomp_timer: Timer = $chomp_timer
@onready var notice_cooldown: Timer = $notice_cooldown
@onready var idle_timer: Timer = $Idle_timer
@onready var dash_readytimer: Timer = $dash_readytimer
@onready var dash_resettimer: Timer = $dash_resettimer
@onready var dash_sensor: Area2D = $Chompersprite/dash_sensor
@onready var chomp_ready_sensor: Area2D = $Chompersprite/chomp_ready_sensor
@onready var wall_detection: RayCast2D = $wall_detection
@onready var dash_cooldown: Timer = $Dash_cooldown
@onready var chomp_collider: CollisionShape2D = $Chompersprite/chomper_attack/chomp_collider





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	can_idlize = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	current_state = chomper_animation.current_animation
	if attacking == false:
			SPEED = 85
			can_turn = true
	elif attacking == true or being_hit == true:
		if dashing == false:
			SPEED = 0
			can_turn = false
	if dashing == true:
		SPEED = 0
	if actually_dashing == true:
		can_turn = false
	if not being_hit and Global.hit == false and not actually_dashing:
		velocity.x = SPEED * -facing
	if is_on_floor() == false:
		velocity.y += gravity * delta
	move_and_slide()
	if target:
		aim()
	if being_hit:
		SPEED = 0
		facing = 0
		chomp_timer.stop()
	if velocity.x != 0 and is_on_floor() and not being_hit and not attacking and not dashing:
		chomper_animation.play("walk")
	elif velocity.x == 0 and is_on_floor() and not being_hit and not attacking and not dashing:
			chomper_animation.play("Idle")
	if wall_detection.is_colliding() and actually_dashing == true:
		dashing = false
		actually_dashing = false
		chomper_animation.play("dash_hit")
		chomp_collider.set_deferred("disabled", true)
	if velocity.x == 0 and current_state == "Idle" and can_idlize:
		idle_timer.start()
		can_idlize = false
	if current_state != "Idle" and can_idlize == true:
		can_idlize = false
	if current_state == "dash_hit":
		velocity.x = 0
func _on_notice_cooldown_timeout() -> void:
	facing = 0

func _on_chomper_detector_body_entered(body: Node2D) -> void:
	if target:
		return
	if body.is_in_group("player"):
		target = body
		notice_cooldown.stop()
func _on_chomper_detector_body_exited(body: Node2D) -> void:
	if body == target:
		notice_cooldown.start()
		target = null
func take_damage(weapon_damage: float):
	health -= weapon_damage
	chomp_collider.set_deferred("disabled", true)
	if health >= 1:
		being_hit = true
		chomper_animation.play("hurt")
		hit_particles.emitting = true
		chomp_timer.stop()
	elif health < 1:
		being_hit = true
		chomper_animation.play("Die")
		chomp_timer.stop()
		idle_timer.stop()
		death_particles.emitting = true


func aim():
	var space_state = get_world_2d().direct_space_state
	for pos in [target.position]:
		var query = PhysicsRayQueryParameters2D.create(position, pos, collision_mask, [self])
		var result = space_state.intersect_ray(query)
		if current_state != "Die" and current_state != "hurt":
			direction = global_position.x - target.global_position.x
		if result:
			hit_pos = result.position
			if result.collider.name == 'player':
				detecting = true
				if direction > 1:
					if can_turn == true:
						facing = 1
						chompersprite.scale.x = -1
				if direction < 1:
					if can_turn == true:
						facing = -1
						chompersprite.scale.x = 1
			else:
				detecting = false

func after_hit() -> void:
	being_hit = false


func in_attack() -> void:
	attacking = false










func _on_chomp_ready_sensor_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and detecting == true and current_state != "Die" and dashing == false:
		attacking = true
		chomp_timer.start()
		chomper_animation.play("Idle")
		notice_cooldown.stop()
func _on_chomp_timer_timeout() -> void:
	chomper_animation.play("chomp")

func _on_chomp_ready_sensor_body_exited(body: Node2D) -> void:
	if being_hit == true:
		return
	if body.is_in_group("player") and detecting == true and current_state != "Die" and dashing == false:
		chomp_timer.stop()
	if current_state != "chomp":
		attacking = false
		
func death_end() -> void:
	chomp_timer.stop()
	get_node("Chomper_animation").queue_free()
	queue_free()


func _on_idle_timer_timeout() -> void:
	Idle_action = randi() % 2
	if Idle_action == 1:
		chompersprite.scale.x *= -1
		can_idlize = true
	elif Idle_action == 2:
		chompersprite.scale.x *= 1
		can_idlize = true
	Idle_action = randi() % 2
func _on_dash_sensor_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and detecting == true and current_state != "Die" and attacking == false and ready_to_dash:
		dash_readytimer.start()
		dash_resettimer.stop()

func _on_dash_sensor_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and detecting == true and current_state != "Die" and attacking == false:
		dash_readytimer.stop()
		dash_resettimer.start()
func _on_dash_readytimer_timeout() -> void:
	dashing = true
	chomper_animation.play("Dash")
	ready_to_dash = false

func dash_initiate() -> void:
	actually_dashing = true
	velocity.x = 400 * chompersprite.scale.x
	dash_cooldown.start()


func _on_dash_resettimer_timeout() -> void:
	if actually_dashing == false:
		dashing = false


func _on_chomper_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and dashing == true and current_state == "Dash":
		chomper_animation.play("dash_hit")

func dash_end() -> void:
	dashing = false
	actually_dashing = false


func _on_dash_cooldown_timeout() -> void:
	ready_to_dash = true
