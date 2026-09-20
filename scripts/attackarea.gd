class_name Attackbox
extends Area2D

@export var damage := 2

func _ready() -> void:
	collision_layer = 2
	collision_mask = 0

func _physics_process(_delta: float) -> void:
	damage = Global.SledgeDamage
