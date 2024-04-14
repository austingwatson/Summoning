extends Node

func _ready():
	randomize()


func _on_Play_pressed():
	#get_tree().change_scene("res://scenes/TestScene.tscn")
	get_tree().change_scene("res://scenes/GameScreen.tscn")
