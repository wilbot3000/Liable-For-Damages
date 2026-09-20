extends Node

var score = 0
var stamina

#@onready var coinlabel: Label = $Coin_score
func _ready() -> void:
	pass



func add_point():
	score +=1
	print(score)
	#coinlabel.text = "coins: " + str(score)
