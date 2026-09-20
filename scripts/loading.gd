extends Node2D
@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var load_timer: Timer = $load_timer

@export var next_scene: String
var progress: Array[float] = []
var timer_start = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_start = true
	Global.loading_fade = true
	Global.fade_in = false
	Global.spawn_point = Vector2(0,0)
	if Global.final_cutscene == false:
		Global.level_level += 1
		if Global.level_level == 1:
			next_scene = "res://scenes/sub_atrium_level_1.tscn"
		if Global.level_level == 2:
			next_scene = "res://scenes/sub_atrium_level_2.tscn"
		if Global.level_level == 3:
			next_scene = "res://scenes/Bosslevel2.tscn"
	if Global.final_cutscene == true:
			next_scene = "res://scenes/final_cutscene.tscn"
	ResourceLoader.load_threaded_request(next_scene)
	SaveLoad.contents_to_save.player_respawn = Global.spawn_point
	SaveLoad.contents_to_save.level = Global.level_level
	SaveLoad.contents_to_save.health = Global.health
	SaveLoad._save()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.level_level == 1:
		next_scene = "res://scenes/sub_atrium_level_1.tscn"
	if Global.level_level == 2:
		next_scene = "res://scenes/sub_atrium_level_2.tscn"
	if Global.level_level == 3:
		next_scene = "res://scenes/Bosslevel2.tscn"
	var status = ResourceLoader.load_threaded_get_status(next_scene, progress)
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var pct = progress[0] * 100
			progress_bar.value = pct
		ResourceLoader.THREAD_LOAD_LOADED:
			if timer_start == true:
				load_timer.start()
				timer_start = false



func _on_load_timer_timeout() -> void:
	var scene = ResourceLoader.load_threaded_get(next_scene)
	get_tree().change_scene_to_packed(scene)
