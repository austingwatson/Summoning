class_name PlayerDemon
extends Node2D

onready var mouth = $Polygon2D


func _on_DemonEat_open_mouth():
	mouth.visible = true


func _on_DemonEat_close_mouth():
	mouth.visible = false
