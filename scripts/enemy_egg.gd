extends AnimatedSprite2D
var target
var hit_pos
var detecting
var spawn = 0
var spawned
var start_timer = true
var timer = 5
var can_die = true
var can_explode = true
const A_IENEMY = preload("uid://b5osq5binc5ai")
const FLY_ENEMY = preload("uid://smnobg5lidkw")
@onready var marker_2d: Marker2D = $Marker2D
@onready var hit_particles: GPUParticles2D = $"hit particles"
@onready var dearh_timer: Timer = $dearh_timer
@onready var collision_detect: Area2D = $collision_detect
@onready var explode: AudioStreamPlayer2D = $explode
@onready var pulse_1: AudioStreamPlayer2D = $pulse1
@onready var pulse_2: AudioStreamPlayer2D = $pulse2



@onready var explosion_timer: Timer = $explosion_timer

func _ready() -> void:
	play("idle")
	randomize()
func _physics_process(delta: float) -> void:
	if detecting == true:
		timer -= delta
	if timer <= 0 and start_timer:
		explosion_timer.start()
		start_timer = false
	if target:
		aim()

func aim():
	var space_state = get_world_2d().direct_space_state
	for pos in [target.position]:
		var query = PhysicsRayQueryParameters2D.create(position, pos, 1, [self])
		var result = space_state.intersect_ray(query)
		if result:
			hit_pos = result.position
			if result.collider.name == 'player':
				detecting = true
			else:
				detecting = false
func _on_collision_detect_body_entered(body: Node2D) -> void:
	if target:
		return
	if body.is_in_group("player"):
		target = body
func _on_collision_detect_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
func take_damage(area_damage):
	if can_die:
		play("die")
		hit_particles.emitting = true
		explode.play(.25)
		can_die = false
func _on_explosion_timer_timeout() -> void:
	if can_explode:
		play("explode")
		explode.play(.25)
		hit_particles.emitting = true
		spawn = randi() % 2
		can_die = false
		if spawn == 0:
			spawned = A_IENEMY.instantiate()
		if spawn == 1:
			spawned = FLY_ENEMY.instantiate()
		owner.add_child(spawned)
		spawned.transform = marker_2d.global_transform
		spawned.rotation = 0
		spawned.scale.x = 1
		spawned.scale.y = 1
		dearh_timer.start()
func _on_animation_finished() -> void:
	if animation == "die":
		dearh_timer.start()
		explosion_timer.stop()
		can_explode = false

func _on_dearh_timer_timeout() -> void:
	queue_free()

func explodesound() -> void:
	explode.play(.3)


func _on_frame_changed() -> void:
	if animation == "idle":
		if frame == 0:
			pulse_1.play()
		if frame == 1:
			pulse_2.play()
