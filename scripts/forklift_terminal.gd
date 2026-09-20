extends AnimatedSprite2D
var interface_open
var can_clicked
var up = true
var slider_possible = true
var timer = 0
var start_timer
@onready var collision_shape_2d: CollisionShape2D = $mouse_detector/CollisionShape2D
@onready var terminal_interface: AnimatedSprite2D = $terminal_interface
@onready var button_pressed: AudioStreamPlayer2D = $button_pressed




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	terminal_interface.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	terminal_interface.global_position = Global.player_position
	if start_timer == true:
		timer += delta
		if timer >= 3:
			start_timer = false
			timer_out()
			timer = 0
	if interface_open == true:
		terminal_interface.show()
		get_tree().paused = true
	if interface_open == false:
		terminal_interface.hide()
		get_tree().paused = false
		interface_open = null

func clicked_on():
	if can_clicked:
		interface_open = true
		collision_shape_2d.disabled = true
func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_clicked = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_clicked = false






func _highlight():
	modulate = Color(1.5, 1.5, 1.5)


func un_highlight():
	modulate = Color(1, 1, 1, 1)


func _on_sign_interface_exit_pressed() -> void:
	terminal_interface.hide()
	interface_open = false
	collision_shape_2d.disabled = false
	button_pressed.play()

func _on_slider_pressed() -> void:
	if slider_possible:
		button_pressed.play()
		var parent = get_parent()
		if up == true:
			slider_possible = false
			start_timer = true
			if parent.has_method("go_down"):
				parent.go_down()
			terminal_interface.play("turn_down")
			up = false

		elif up == false:
			slider_possible = false
			start_timer = true
			if parent.has_method("go_up"):
				parent.go_up()
			terminal_interface.play("turn_up")
			up = true
	print(up)


func timer_out():
	slider_possible = true
	print("worked")
