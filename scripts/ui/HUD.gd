extends CanvasLayer

onready var fps_label = $FPSLabel
onready var amount = $TextureRect/HBoxContainer/Amount


func _process(_delta):
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
	

func update_soul():
	var amount = 0
	for soul in GlobalValues.current_souls:
		amount += soul
	
	self.amount.text = str(amount)
