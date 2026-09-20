extends Node2D
var start
var movement = 1
var place_to_go
var can_door = true
var SPEED = 0
var can_detach = true
var stickout_move = false
var stickout_go
var begin_final = true
var start_final_timer = true
var final_movement
var up_SPEED = 0
var start_sound_roller = true
@onready var start_timer: Timer = $start_timer
@onready var podsprite: AnimatedSprite2D = $podsprite
@onready var moving_timer: Timer = $moving_timer
@onready var detach_timer: Timer = $detach_timer
@onready var door_collision: StaticBody2D = $podsprite/door_collision
@onready var collider: StaticBody2D = $podsprite/collider
@onready var stickout: Sprite2D = $stickout
@onready var exhaust: Sprite2D = $podsprite/exhaust
@onready var final_timer: Timer = $final_timer
@onready var top: Sprite2D = $top
@onready var roller: AudioStreamPlayer2D = $podsprite/roller
@onready var engine: AudioStreamPlayer2D = $podsprite/engine
@onready var timer: Timer = $final_detector/Timer

@onready var door_sound: AudioStreamPlayer2D = $podsprite/door_sound
@onready var hiss: AudioStreamPlayer2D = $podsprite/hiss


func _ready() -> void:
	top.visible = false
	place_to_go = podsprite.position.x + 180
	stickout_go = stickout.position.x - 60
	exhaust.visible = false
func _physics_process(delta: float) -> void:
	if start == true:
		if movement == 1 and can_door:
			podsprite.play("door_close")
		if movement == 2:
			podsprite.position.x = move_toward(podsprite.position.x, place_to_go, delta * SPEED)
			SPEED = move_toward(SPEED, 30, delta * 30)
			if podsprite.position.x == place_to_go and can_detach:
				print("got there")
				detach_timer.start()
				roller.stop()
				hiss.play()
				can_detach = false
	if stickout_move:
		stickout.position.x = move_toward(stickout.position.x, stickout_go, delta * 40)
		if start_sound_roller:
			roller.play()
			start_sound_roller = false
		if stickout.position.x <= stickout_go:
			if begin_final == true:
				hiss.play()
				begin_final = false
			roller.stop()
			if start_final_timer == true:
				final_timer.start()
				start_final_timer = false
	if final_movement == true:
		up_SPEED = move_toward(up_SPEED, 300, delta * 50)
		podsprite.position.y -= up_SPEED * delta
func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		start_timer.start()


func _on_start_timer_timeout() -> void:
	start = true
	door_sound.play()

func _on_podsprite_animation_finished() -> void:
	if podsprite.animation == "door_close":
		can_door = false
		door_sound.stop()
		hiss.play()
	moving_timer.start()
	print("start_timer")
func _on_moving_timer_timeout() -> void:
	movement += 1
	roller.play()

func _on_detach_timer_timeout() -> void:
	podsprite.play("move_out")
	door_collision.position.y += 3
	collider.position.y += 3
	stickout_move = true


func _on_final_timer_timeout() -> void:
	podsprite.play("engines_on")
	exhaust.visible = true
	final_movement = true
	engine.play()
	top.visible = true


func _on_final_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		timer.start()
		Global.fade_in = true
		Global.final_cutscene = true


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")
