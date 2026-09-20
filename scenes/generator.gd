extends AnimatedSprite2D
var can_click
var level: float = 0.0

@onready var machinesound_1: AudioStreamPlayer2D = $machinesound1
@onready var machinesound_2: AudioStreamPlayer2D = $machinesound2
@onready var machinesound_3: AudioStreamPlayer2D = $machinesound3
@onready var powerdown: AudioStreamPlayer2D = $powerdown



func _ready() -> void:
	play("on")

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_click = true
func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_click = false

func clicked_on():
	if can_click:
		if level >= 4:
			for child in get_children():
				play("powering off")
				machinesound_1.stop()
				machinesound_2.stop()
				machinesound_3.stop()
				powerdown.start()
				if child.has_method("can_open"):
					child.can_open()
				if child.has_method("open_sesame"):
					child.open_sesame()
func open_sesame():
	level += 1
	print(level)
func _highlight():
	modulate = Color(1.5, 1.5, 1.5)


func un_highlight():
	modulate = Color(1, 1, 1, 1)
