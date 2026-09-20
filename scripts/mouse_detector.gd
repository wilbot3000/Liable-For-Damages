class_name Mouse_detector
extends Area2D
@onready var click_timer: Timer = $click_timer
@onready var click_label: Label = $click_label

var timer_done = true
var can_clicked
func _ready() -> void:
	click_label.visible = false
func _on_mouse_entered() -> void:
	can_clicked = true
	if owner.has_method("_highlight"):
		owner._highlight()
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if can_clicked and timer_done == true:
			if owner.has_method("clicked_on"):
				owner.clicked_on()
			click_timer.start()
			timer_done = false
func _on_mouse_exited() -> void:
	can_clicked = false
	if owner.has_method("un_highlight"):
		owner.un_highlight()
func _on_click_timer_timeout() -> void:
	timer_done = true

func open_sesame():
	pass
