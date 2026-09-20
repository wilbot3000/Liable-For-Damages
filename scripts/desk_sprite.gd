extends AnimatedSprite2D
var can_clicked
var interface_open
var note_open
var calendar_open
@onready var calendar: Sprite2D = $Calendar
@onready var note: Sprite2D = $Note
@onready var desk_inside: Sprite2D = $Desk_inside
@onready var desk_sprite: AnimatedSprite2D = $"."
@onready var open: AudioStreamPlayer2D = $open
@onready var button_pressed: AudioStreamPlayer2D = $button_pressed





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	desk_inside.hide()
	note.hide()
	calendar.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	desk_inside.global_position = Global.player_position
	calendar.global_position = Global.player_position
	note.global_position = Global.player_position
	if interface_open == true:
		desk_inside.show()
		get_tree().paused = true
	if interface_open == false:
		desk_inside.hide()
		note.hide()
		calendar.hide()
		get_tree().paused = false
		interface_open = null
	if note_open == true:
		note.show()
	elif note_open == false:
		note.hide()
	if calendar_open == true:
		calendar.show()
	if calendar_open == false:
		calendar.hide()
func clicked_on():
	if can_clicked:
		interface_open = true
		open.play()
func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_clicked = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_clicked = false


func _on_desk_exit_pressed() -> void:
	interface_open = false
	note_open = false
	calendar_open = false
	button_pressed.play()


func _on_note_button_pressed() -> void:
	note_open = true


func _on_note_exit_pressed() -> void:
	note_open = false


func _on_calendar_button_pressed() -> void:
	calendar_open = true


func _on_calendar_exit_pressed() -> void:
	calendar_open = false

func _highlight():
	desk_sprite.modulate = Color(1.5, 1.5, 1.5)


func un_highlight():
	desk_sprite.modulate = Color(1, 1, 1, 1)
