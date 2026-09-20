extends Node2D
@onready var background: Sprite2D = $background
@onready var timer: Timer = $Timer
@onready var settings_screen: Sprite2D = $Settings_screen
@onready var button_pressed: AudioStreamPlayer2D = $button_pressed


func _on_credits_pressed() -> void:
	background.visible = true
	button_pressed.play()

func _on_credit_exit_pressed() -> void:
	background.visible = false
	button_pressed.play()

func _on_start_pressed() -> void:
	timer.start()
	button_pressed.play()
	Global.spawn_point = SaveLoad.contents_to_save.player_respawn
	Global.level_level = Global.level_level - 1
	get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")
func _on_timer_timeout() -> void:
	print("something worekd")

func _on_quit_pressed() -> void:
	button_pressed.play()
	get_tree().quit()


func _on_settings_exit_pressed() -> void:
	settings_screen.visible = false
	button_pressed.play()

func _on_settings_pressed() -> void:
	settings_screen.visible = true
	button_pressed.play()

func _on_load_pressed() -> void:
	SaveLoad._load()
	Global.spawn_point = SaveLoad.contents_to_save.player_respawn
	Global.level_level = SaveLoad.contents_to_save.level
	Global.health = SaveLoad.contents_to_save.health
	button_pressed.play()
