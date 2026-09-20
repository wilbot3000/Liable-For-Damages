extends Area2D
@onready var keypad_interface: AnimatedSprite2D = $keypad_interface
@onready var keypad_screen: AnimatedSprite2D = $keypad_interface/keypad_screen
@onready var label: Label = $correct_code
@onready var keypad_sprite: AnimatedSprite2D = $keypad_sprite
@onready var beep: AudioStreamPlayer2D = $beep
@onready var button_pressed: AudioStreamPlayer2D = $button_pressed

var interface_open = false
var pressing = false
var code = 0
var code_step = 0
var step_modifier = 10000
var last_code = 0
var correct_code 
var opened = false
var can_click = false
@onready var exit_button: TextureButton = $keypad_interface/exit_button


func _physics_process(_delta: float) -> void:
	keypad_interface.global_position = Global.player_position
	if interface_open == false:
		keypad_interface.hide()
		get_tree().paused = false
		keypad_interface.hide()
		interface_open = null
	if pressing == false:
		keypad_interface.play("default")
	correct_code = int(label.text)
	if opened:
		keypad_sprite.play("activated")
	else:
		keypad_sprite.play("idle")
func clicked_on():
	if can_click:
		interface_open = true
		keypad_interface.show()
		get_tree().paused = true

		if interface_open == true:
			return


func _on_1_press_pressed() -> void:
	pressed()
	pressing = true
	keypad_interface.play("1_press")
	last_code = 1
func _on_2_press_pressed() -> void:
	pressed()
	pressing = true
	keypad_interface.play("2_press")
	last_code = 2


func _on_keypad_interface_animation_finished() -> void:
	pressing = false
	code_step = code_step + 1
	code += step_modifier * last_code


	if code_step == 0:
		step_modifier = 10000
		keypad_screen.play("default")
	if code_step == 1:
		step_modifier = 1000
		keypad_screen.play("1_number")
	if code_step == 2:
		step_modifier = 100
		keypad_screen.play("2_number")
	if code_step == 3:
		step_modifier = 10
		keypad_screen.play("3_number")
	if code_step == 4:
		step_modifier = 1
		keypad_screen.play("4_number")
	if code_step == 5:
		keypad_screen.play("5_number")

func _on_exit_button_pressed() -> void:
	pressed()
	interface_open = false
	get_tree().paused = false




func _on_3_press_pressed() -> void:
	pressed()
	pressed()
	pressing = true
	keypad_interface.play("3_press")
	last_code = 3
func _on_4_press_pressed() -> void:
	pressed()
	pressing = true
	keypad_interface.play("4_press")
	last_code = 4
func _on_5_press_pressed() -> void:
	pressed()
	pressing = true
	keypad_interface.play("5_press")
	last_code = 5
func _on_6_press_pressed() -> void:
	pressed()
	pressing = true
	keypad_interface.play("6_press")
	last_code = 6
func _on_7_press_pressed() -> void:
	pressed()
	pressing = true
	keypad_interface.play("7_press")
	last_code = 7
func _on_8_press_pressed() -> void:
	pressed()
	pressing = true
	keypad_interface.play("8_press")
	last_code = 8
func _on_9_press_pressed() -> void:
	pressed()
	pressing = true
	keypad_interface.play("9_press")
	last_code = 9
func _on_0_press_pressed() -> void:
	pressed()
	pressed()
	pressing = true
	keypad_interface.play("0_press")
	last_code = 0
func _on_back_press_pressed() -> void:
	pressed()
	pressing = true
	keypad_interface.play("back_press")
	last_code = 0
	code_step = -1
	code = 0
func _on_enter_press_pressed() -> void:
	pressed()
	pressing = true
	keypad_interface.play("enter_press")
	if code == correct_code:
		keypad_screen.play("correct_number")
		open_ready()
		beep.play()
		opened = true
	if code != correct_code:
		keypad_screen.play("incorrect_number")
	last_code = 0
	code_step = -1
	code = 0
func open_ready():
	for child in get_children():
		if child.has_method("open_sesame"):
				child.open_sesame()






func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_click = true


func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_click = false

func _highlight():
	keypad_sprite.modulate = Color(1.5, 1.5, 1.5)


func un_highlight():
	keypad_sprite.modulate = Color(1, 1, 1, 1)


func pressed():
	button_pressed.play()
