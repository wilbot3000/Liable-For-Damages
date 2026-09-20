extends Node2D
var level = 1
@onready var timer: Timer = $loading_area/Timer
@onready var loading_fade: Sprite2D = $loading_area/loading_fade

var can_fade = false
var fade_level = 0
func _ready() -> void:
	Global.level_level = level
func _physics_process(_delta: float) -> void:
	pass
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")


func _on_loading_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		timer.start()
		Global.fade_in = true
