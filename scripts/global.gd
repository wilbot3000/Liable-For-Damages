extends Node

var staminaglobal: float = 10
var SledgeDamage := 1
var health: float = 1
var hit = false
var attacked = false
var enemy_facing = 0
var player_facing
var lilenemy_damage
var chomper_damage
var player_position = Vector2()
var level_level = 1
var fade_in = false
var player_respawn = false
var fade_out
var spawn_point = Vector2.ZERO
var saved_reset
var final_cutscene = false
var loading_fade = true
