extends Node

func _ready():
	randomize()


func _on_Play_pressed():
	var _error = get_tree().change_scene("res://scenes/GameScreen.tscn")
