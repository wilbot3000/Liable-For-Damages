class_name player
extends CharacterBody2D
var stamina: float = 10
#cooldown for weapon
var is_ready = true
var jump_ready = true
#character walk speed
var SPEED = 50
var attacking = false
#jump height, every 100 pixels is ~1 block
const JUMP_VELOCITY = -250.0
var state_machine
var sprinting = false
var current_state
var recharging = false
var PUSH_FORCE = 0.1
var MAX_PUSH = 100
var movement = Vector2.ZERO
var can_regen = false
var time_to_wait = .5
var s_timer = 0
var health: float = 1
var can_start_stimer = true
var sledge_up = false
var sledge_is_down = false
var sledge_can_godown = false
var being_hit = false
var direction = 0
var hoist_ready = false
var hoisting = false
var grid_size: Vector2 = Vector2(16, 16)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var crouching = false
var sliding = false
var dashing = false
var dashvelocity = false
var dashready = true
var grounding = false
var smoothing_done = false
var ground_timer = 0
var time_to_groundset = 1
var ground_random = 0
var ground_play = false
var small_ground = false
var sledge_strike = 0
var sledge_timer = 0
var sledge_time = 1.5
var ready_to_attack = false
var walk_can_reset = false
var big_attack = false
var magic = true
var can_hurt = true
var health_can_go_up = true
var spawn_point = Vector2.ZERO
var can_respawn = true
var hit_ready = true
@onready var playermodel: Sprite2D = $playermodel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var jumpcooldown: Timer = $jumpcooldown
@onready var recharge: Timer = $recharge
@onready var sprinting_timer: Timer = $sprinting
@onready var attackarea: Attackbox = $playermodel/attackarea
@onready var player_hit: Area2D = $playermodel/player_hit
@onready var recoilcooldown: Timer = $recoilcooldown
@onready var wall_detect: RayCast2D = $playermodel/Wall_detect
@onready var ledge_detect: RayCast2D = $playermodel/Ledge_detect
@onready var playercollision: CollisionShape2D = $playercollision
@onready var roof_detect: RayCast2D = $playermodel/roof_detect
@onready var roof_detect_2: RayCast2D = $playermodel/roof_detect2
@onready var playercollision_crouch: CollisionShape2D = $playercollision_crouch
@onready var slidetimer: Timer = $Slidetimer
@onready var dashtimer: Timer = $Dashtimer
@onready var dashcooldown: Timer = $dashcooldown
@onready var collisionshape: CollisionShape2D = $playermodel/player_hit/CollisionShape2D
@onready var grounding_player: AnimationPlayer = $Ground_pound/Grounding_player
@onready var ground_pound: Sprite2D = $Ground_pound
@onready var floor_detect: RayCast2D = $playermodel/floor_detect
@onready var sledge_reset: Timer = $sledge_reset
@onready var jumpforward_timer: Timer = $jumpforward_timer
@onready var attack_poofsplayer: AnimationPlayer = $playermodel/attack_poofs/attack_poofsplayer
@onready var reset_timer: Timer = $reset_timer
@onready var crouch_hoist: RayCast2D = $playermodel/crouch_hoist
@onready var cooldown: Timer = $playermodel/player_hit/cooldown
@onready var i_fram_timer: Timer = $I_fram_timer
@onready var health_better: Timer = $health_better
@onready var step_sound: AudioStreamPlayer2D = $Step_sound
@onready var jump: AudioStreamPlayer2D = $jump
@onready var jump_2: AudioStreamPlayer2D = $jump2
@onready var thump: AudioStreamPlayer2D = $thump
@onready var slide: AudioStreamPlayer2D = $slide
@onready var hurt2: AudioStreamPlayer2D = $hurt
@onready var gag: AudioStreamPlayer2D = $gag


func _ready() -> void:
	state_machine = animation_tree["parameters/playback"]
	randomize()
	health = SaveLoad.contents_to_save.health
	global_position = SaveLoad.contents_to_save.player_respawn
	spawn_point = SaveLoad.contents_to_save.player_respawn
func _physics_process(delta: float) -> void:
	queue_redraw()
	if spawn_point == Vector2(0, 0) and Global.level_level == 1:
		spawn_point = Vector2(-28, -5)
		global_position = spawn_point
		health = SaveLoad.contents_to_save.health
	if spawn_point == Vector2(0, 0) and Global.level_level == 2:
		spawn_point = Vector2(-89, 178)
		health = SaveLoad.contents_to_save.health
		global_position = spawn_point

	if spawn_point == Vector2(0, 0) and Global.level_level == 3:
		spawn_point = Vector2(-90, 178)
		health = SaveLoad.contents_to_save.health
		global_position = spawn_point



	if is_on_floor() == false:
		hit_ready = true
	if hit_ready == true and is_on_floor() == true:
		jump_2.pitch_scale = 1 +- .2
		jump_2.play(.5)
		hit_ready = false

	if attacking:
		magic = .3
	else:
		magic = 1
#damage changing
	if current_state == "attack":
		big_attack = true
	elif current_state != "attack":
		big_attack = false
	if current_state == "ground_pound":
		if small_ground == true:
			Global.SledgeDamage = 30
		if small_ground == false:
			Global.SledgeDamage = 50
	elif current_state != "ground_pound":
		if big_attack == true:
			Global.SledgeDamage = 30
		if big_attack == false:
			Global.SledgeDamage = 20

	if current_state == "die":
		velocity.x = 0
#Global Variable stuff
	can_respawn = Global.player_respawn
	Global.player_facing = playermodel.scale.x
	Global.hit = being_hit
	Global.staminaglobal = stamina
	Global.health = health
	Global.player_position = global_position
	Global.spawn_point = spawn_point
	if sledge_strike == 3:
		sledge_strike = 0

	if can_respawn:
		respawn()
		can_respawn = false
		Global.player_respawn = false
#code for wall hoisting
	if wall_detect.is_colliding() and not ledge_detect.is_colliding() and not is_on_floor() and hoisting == false:
		hoist_ready = true
	else:
		hoist_ready = false
	if hoist_ready == true and Input.is_action_just_pressed("jump"):
		hoisting = true
		grounding = false
		state_machine.travel("hoist")
		position.y = (round(position.y / grid_size.y + .2) * grid_size.y) - 5
	if hoisting == true:
		velocity.x = 0
		velocity.y = 0
	if is_on_floor() == true:
		hoisting = false
	if hoisting and crouch_hoist.is_colliding():
		crouching = true

#dash code
	if Input.is_action_just_pressed("dash"):
		if crouching == false and sliding == false and hoisting == false and dashready == true and sledge_up == false and grounding == false and current_state != "die":
			if direction != 0 or is_on_floor() == false:
				dashing = true
				state_machine.travel("dash")
				dashtimer.start()
				dashcooldown.start()
				dashvelocity = true
				can_regen = false
				s_timer = 0
	if dashing == true:
		velocity.x = move_toward(velocity.x, 0, 500000 * delta)
		smoothing_done = true
		if dashvelocity == true:
			velocity.x = 2000 * playermodel.scale.x
			stamina = move_toward(stamina, stamina - 3.5, delta * 1500)
			dashready = false
			dashvelocity = false



	if health < 3 and health_can_go_up == true:
		health_better.start()
		health_can_go_up = false
#code for crouching
	if Input.is_action_just_pressed("crouch") and grounding == false:
		if sprinting == true:
			sliding = true
			state_machine.travel("slide")
			slidetimer.start()
		elif sprinting == false:
			if crouching == false:
				crouching = true
			elif crouching == true and roof_detect.is_colliding() == false and roof_detect_2.is_colliding() == false:
				crouching = false
	if crouching == true or sliding == true:
		playercollision.set_deferred("disabled", true)
	elif crouching == false or sliding == false:
		playercollision.set_deferred("disabled", false)
	if sliding == true:
		velocity.x = 300 * playermodel.scale.x
	if wall_detect.is_colliding():
		sliding = false
		dashing = false
#forcing player to stay still while attacking
	if attacking == true or sledge_is_down == true:
			direction = 0

#idk move and slide
	move_and_slide()

#stamina regen check and begina
	if can_regen == false and stamina != 10:
		can_start_stimer = true
		if can_start_stimer:
			s_timer += delta
			if s_timer >= time_to_wait:
				can_regen = true
				can_start_stimer = false
				s_timer = 0

#stops stamina from being overwrought
	if stamina == 10:
		can_regen = false

	#for movable boxes, lowkey just stolen code
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_box = collision.get_collider()
		if collision_box is RigidBody2D and abs(collision_box.get_linear_velocity().x) < MAX_PUSH:
			collision_box.apply_central_impulse(collision.get_normal() * -PUSH_FORCE)

	# Add the gravity.
	if is_on_floor() == false:
		velocity.y += gravity * delta * magic


	# Handling jump.
	if Input.is_action_pressed("jump") and is_on_floor() and jump_ready and Global.staminaglobal >= 2.1 and current_state != "die":
		if attacking == false and hoisting == false:
			jumpcooldown.start()
			if sliding == false:
				velocity.y = JUMP_VELOCITY
				jumpsound()
			elif sliding == true:
				velocity.y = -300
			jump_ready = false
			stamina = stamina - 2
			can_regen = false
			s_timer = 0


#sets player direction
	if being_hit == false:
		direction = Input.get_axis("move_left", "move_right")


#setting movemaent
	if attacking == true or sledge_is_down == true or being_hit == true:
		pass
	elif being_hit == false:
		if direction:
			velocity.x = direction * SPEED
		elif dashing == false:
			velocity.x = move_toward(velocity.x, 0, SPEED)


#flips direction of sprite when moving
	if attacking == false and hoisting == false and sliding == false and grounding == false:
		if direction > 0:
			playermodel.scale.x = 1
		elif direction < 0:
			playermodel.scale.x = -1

	if health <= 0:
		being_hit = true
		state_machine.travel("die")
#code for attacking
	if Input.is_action_just_pressed("attack"):
		sledge_timer = 0
	if Input.is_action_pressed("attack") and Global.staminaglobal >= 2.1:
		if being_hit == false and crouching == false and sliding == false and dashing == false and grounding == false and current_state != "attack_short1" and current_state != "attack_short2" and current_state != "attack_short3":
			can_regen = false
			s_timer = 0
			#cooldown.start()
			is_ready = false
			state_machine.travel("sledge_up")
			sledge_timer += delta
			attacking = true
	if Input.is_action_pressed("attack") == false and Global.staminaglobal >= 2.1 and ready_to_attack == true and current_state != "attack_short1" and current_state != "attack_short2" and current_state != "attack_short3":
		if sledge_timer >= sledge_time:
			state_machine.travel("attack")
		elif sledge_timer < sledge_time:
			state_machine.travel("attack_short1")
			sledge_strike = 0
			velocity.x = 200 * playermodel.scale.x
			jumpforward_timer.start()
			reset_timer.start()
			stamina -= 1.5
			can_regen = false
			s_timer = 0
	if current_state == "attack_short1" and Input.is_action_just_pressed("attack") and sledge_strike == 1 and Global.staminaglobal >= 2.1:
		state_machine.travel("attack_short2")
		velocity.x = 200 * playermodel.scale.x
		jumpforward_timer.start()
		reset_timer.start()
		stamina -= 1.5
		can_regen = false
		s_timer = 0
		sledge_strike = 1
	if current_state == "attack_short2" and Input.is_action_just_pressed("attack") and sledge_strike == 2 and Global.staminaglobal >= 2.1:
		state_machine.travel("attack_short3")
		velocity.x = 200 * playermodel.scale.x
		jumpforward_timer.start()
		reset_timer.start()
		stamina -= 1.5
		can_regen = false
		s_timer = 0
	if walk_can_reset == true and direction != 0:
		attacking = false
		ready_to_attack = false
		sledge_timer = 0
		sledge_strike = 0
		walk_can_reset = false
#code for sprinting
	if Input.is_action_just_pressed("sprint") and stamina >= 1:
		if sledge_up == true or crouching == true:
			pass
		elif sledge_up == false:
			sprinting_timer.start()
			sprinting = true

	elif Input.is_action_just_released("sprint"):
		sprinting_stopped()
	if stamina < 1 and sprinting:
		sprinting_stopped()

	if sprinting:
		SPEED = move_toward(SPEED, 175, 500 * delta)
	elif not sprinting:
		if sledge_up == true:
			SPEED = move_toward(SPEED, 100, 500 * delta)
		if sledge_up == false:
			SPEED = move_toward(SPEED, 50, 500 * delta)
	if animation_player.is_playing:
		current_state = state_machine.get_current_node()
		if velocity.x == 0 and current_state == "idle" or "run" or "dashing" and not sprinting and not attacking and current_state != "jump":
			if can_regen:
				stamina = move_toward(stamina, 10, 7 * delta)
				can_start_stimer = false
				s_timer = 0
			else:
				pass
	if sprinting == true:
		stamina = move_toward(stamina, 0, delta * 3.5)
		can_regen = false
		s_timer = 0

	#play animations for idle and run
	if is_on_floor() and not attacking and not sledge_is_down and not being_hit and not sliding and not dashing and not grounding:
		if direction == 0:
			if crouching == false:
				state_machine.travel("idle")
			elif crouching == true:
				state_machine.travel("crouch")
		elif direction != 0:
			if sprinting == true:
				state_machine.travel("run")
			elif sprinting == false:
				if crouching == true:
					state_machine.travel("crouch_walk")
				if crouching == false:
					state_machine.travel("walk")
	elif not attacking and not sledge_is_down and not being_hit and not hoisting and not dashing and not is_on_floor() and not grounding:
		state_machine.travel("jump")


func attacking_true() -> void:
	attacking = false
	attack_ready()
func _on_cooldown_timeout() -> void:
	is_ready = true
func _on_jumpcooldown_timeout() -> void:
	jump_ready = true
func _on_recharge_timeout() -> void:
	recharging = true
	recharge.stop()

func sprinting_stopped() -> void:
	sprinting = false
	sprinting_timer.stop()
	can_regen = false
	s_timer = 0
func take_damage(weapon_damage: float):
	health_better.stop()
	if hoisting == false and can_hurt:
		sledge_strike = 0
		ready_to_attack = false
		sledge_timer = 0
		attacking = false
		dashing = false
		health -= weapon_damage
		if health >= 1:
			being_hit = true
			state_machine.travel("hurt")
		elif health <= 0:
			being_hit = true
			state_machine.travel("die")

		i_fram_timer.start()
		playermodel.self_modulate = Color(1.32, 0.394, 0.4)
		can_hurt = false
func sledgeisdown() -> void:
	sledge_is_down = false
	sledge_can_godown = false


func beinghit() -> void:
	being_hit = false


func on_death() -> void:
	pass



func hoist_complete() -> void:
	position.y -= 16
	position.x += 8 * playermodel.scale.x
	hoisting = false


func _on_slidetimer_timeout() -> void:
	sliding = false


func _on_dashtimer_timeout() -> void:
	dashing = false


func _on_dashcooldown_timeout() -> void:
	dashready = true


func groundpound_particles() -> void:
	pass

func attack_ready() -> void:
	ready_to_attack = true


func unattack_ready() -> void:
	sledge_reset.start()
	sledge_strike += 1
	if sledge_strike == 3:
		sledge_strike = 0
	sledge_timer = 0
func _on_sledge_reset_timeout() -> void:
	ready_to_attack = false
	attacking = false
	sledge_timer = 0


func _on_jumpforward_timer_timeout() -> void:
	velocity.x = 0

func attack_poof() -> void:
	ground_random = randi() % 2
	if ground_random == 0:
		attack_poofsplayer.play("attack1")
	elif ground_random == 1:
		attack_poofsplayer.play("attack2")
	ground_random = randi() % 2


func _on_reset_timer_timeout() -> void:
	if !being_hit:
		walk_can_reset = true
		print("reset")
func _on_i_fram_timer_timeout() -> void:
	can_hurt = true
	playermodel.self_modulate = Color(1,1,1)


func _on_health_better_timeout() -> void:
	if current_state != "die":
		health += 1
		health_can_go_up = true

func update_spawn_point(new_spawn):
	spawn_point = new_spawn
	Global.spawn_point = spawn_point
func respawn():
	global_position = spawn_point
	Global.fade_out = true
	health = 3
	state_machine.travel("idle")
	being_hit = false

func step_taken():
	var step_random = randi() % 3
	if step_random == 0:
		step1()
	if step_random == 1:
		step2()
	if step_random == 2:
		step3()
func step1() -> void:
	step_sound.volume_db = -37
	step_sound.pitch_scale = 0.9
	step_sound.play()
func step2() -> void:
	step_sound.volume_db = -37
	step_sound.pitch_scale = 1
	step_sound.play()
func step3() -> void:
	step_sound.volume_db = -37
	step_sound.pitch_scale = 1.1
	step_sound.play()

func jumpsound() -> void:
	jump.play(.1)

func thumped() -> void:
	thump.play(.9)

func slidesound() -> void:
	slide.play()

func hurt() -> void:
	step_sound.pitch_scale = 7
	step_sound.volume_db = -10
	step_sound.play()

func deathsound() -> void:
	gag.play(.8)
