extends CharacterBody2D
var direction = 0
var SPEED = 45
var playerright = false
var playerleft = false
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
var recoil_ready = true
@onready var enemysprite: Sprite2D = $enemysprite
@onready var notice_cooldown: Timer = $notice_cooldown
@onready var collision_detect: Area2D = $collision_detect
@onready var enemyshape: CollisionShape2D = $enemyshape
@onready var meanie_animations: AnimationPlayer = $meanie_animations
@onready var hit_particles: GPUParticles2D = $"hit particles"
@onready var death_particles: GPUParticles2D = $"death particles"
@onready var player_detect: Area2D = $player_detect
@onready var attack_timer: Timer = $"attack timer"
@onready var hurt_box: hurtbox = $hurtbox
@onready var collider_thingy: CollisionShape2D = $enemysprite/attack_zone/CollisionShape2D
@onready var recoil_timer: Timer = $recoil_timer
@onready var hurt: AudioStreamPlayer2D = $hurt
@onready var death: AudioStreamPlayer2D = $death




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	Global.enemy_facing = facing
	if attacking == false:
		SPEED = 50
	if attacking == true:
		SPEED = 0
	if not being_hit and not Global.hit:
		velocity.x = SPEED * facing
	if is_on_floor() == false:
		velocity.y += gravity * delta
	move_and_slide()
	if target:
		aim()
	if velocity.x != 0 and is_on_floor() and not being_hit and not attacking:
		meanie_animations.speed_scale = 1.5
		meanie_animations.play("walk")
	elif velocity.x == 0 and is_on_floor() and not being_hit and not attacking:
			meanie_animations.speed_scale = 1
			meanie_animations.play("idle")
	if being_hit == true:
		SPEED = 0
		attack_timer.stop()
	current_state = meanie_animations.current_animation
	if recoil_ready == true:
		#velocity.x += 500 * Global.player_facing
		recoil_timer.start()
		recoil_ready = false

func _on_notice_cooldown_timeout() -> void:
	facing = 0

func _on_collision_detect_body_entered(body: Node2D) -> void:
	if target:
		return
	if body.is_in_group("player"):
		target = body
		notice_cooldown.stop()

func _on_collision_detect_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		notice_cooldown.start()
func take_damage(weapon_damage: float):
	health -= weapon_damage
	if health >= 1:
		meanie_animations.speed_scale = 1
		being_hit = true
		meanie_animations.play("damaged")
	elif health < 1:
		meanie_animations.speed_scale = 1
		being_hit = true
		meanie_animations.play("death")

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
				if direction > 1:
					facing = -1
					enemysprite.scale.x = 1
				if direction < 1:
					facing = 1
					enemysprite.scale.x = -1
		else:
			detecting = false


func after_hit() -> void:
	being_hit = false

func if_killed() -> void:
	death_particles.emitting = true
	recoil_ready = true
func if_hit() -> void:
	hit_particles.emitting = true
	recoil_ready = true

func _on_player_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and detecting == true and current_state != "death":
		attacking = true
		attack_timer.start()
		meanie_animations.play("idle")
		notice_cooldown.stop()

func _on_player_detect_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and detecting == true:
		attack_timer.stop()
	if current_state != "slice":
		attacking = false
func _on_attack_timer_timeout() -> void:
	meanie_animations.speed_scale = 1
	meanie_animations.play("slice")

func in_attack() -> void:
	attacking = false

func death_end() -> void:
	attack_timer.stop()
	get_node("meanie_animations").queue_free()
	queue_free()


func _on_recoil_timer_timeout() -> void:
	#velocity.x -= 500 * Global.player_facing
	velocity.x = 0
	pass
func recoilready() -> void:
	velocity.x -= 400 * -Global.player_facing


func _on_ontop_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		position.y += 10

func hurtsound() -> void:
	hurt.play(.5)

func deathsound() -> void:
	death.play(.35)
