extends Area2D

export (AtlasTexture) var candle_stick_1
export (AtlasTexture) var candle_stick_2

onready var flame = $Flame


func _ready():
	flame.visible = false
	var rng = randi() % 2
	if rng == 0:
		$CandleStick.texture = candle_stick_1
		flame.play("flame_1")
	else:
		$CandleStick.texture = candle_stick_2
		flame.play("flame_2")


func _on_Candle_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_action_released("click"):
		flame.visible = not flame.visible
