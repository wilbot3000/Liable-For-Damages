extends Node

const save_location: String = "user://Savefolder.json"
var timer = 0
var current_scene
var active_json
var contents_to_save: Dictionary = {
	"player_respawn" = Vector2.ZERO,
	"level" = 1,
	"health" = 3.0,
	
	}

func _ready() -> void:
	_load()
	if Global.level_level == 1:
		pass
	if Global.level_level == 2:
		SaveLoad.contents_to_save.player_respawn = Vector2()
	if Global.level_level == 3:
		SaveLoad.contents_to_save.player_respawn = Vector2()
func _physics_process(delta: float) -> void:
	timer += delta

	if get_tree().get_current_scene():
		current_scene = get_tree().current_scene.name
	if current_scene == "Bosslevel2":
		Global.level_level = 3
	if current_scene == "Sub_atrium_Level2":
		Global.level_level = 2
	if current_scene == "Sub_atrium_Level1":
		Global.level_level = 1
	if timer >= 20:
		SaveLoad.contents_to_save.player_respawn = Global.spawn_point
		SaveLoad.contents_to_save.level = Global.level_level
		SaveLoad.contents_to_save.health = Global.health

		Global.saved_reset = true
		timer = 0
func _save():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_string(JSON.stringify(contents_to_save))
	file.close()
	print("worked")
func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var json = JSON.new()
		var data = json.parse(file.get_as_text())

		file.close()

		var json_data: Dictionary = json.data

		active_json = json_data
		Global.spawn_point = json_data.player_respawn
		Global.level_level = json_data.level
		Global.health = json_data.health
		contents_to_save.spawn_point = json_data.player_respawn
		contents_to_save.level = json_data.level
		contents_to_save.health = json_data.health
	#print(file)
