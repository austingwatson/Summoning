extends Area2D

export (AtlasTexture) var candle_stick_1
export (AtlasTexture) var candle_stick_2

onready var flame = $Flame

var mouse_inside = false


func _ready():
	var rng = randi() % 2
	if rng == 0:
		$CandleStick.texture = candle_stick_1
		flame.play("flame_1")
	else:
		$CandleStick.texture = candle_stick_2
		flame.play("flame_2")
		
	
func _unhandled_input(event):
	if mouse_inside and event.is_action_released("click"):
		flame.visible = not flame.visible


func _on_Candle_mouse_entered():
	mouse_inside = true


func _on_Candle_mouse_exited():
	mouse_inside = false
