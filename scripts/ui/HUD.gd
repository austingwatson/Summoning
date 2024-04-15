extends CanvasLayer

onready var fps_label = $FPSLabel
onready var amount = $TextureRect/HBoxContainer/Amount

var current_amount = 0


func _process(_delta):
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
	

func add_soul(amount):
	current_amount += amount
	self.amount.text = str(current_amount)
