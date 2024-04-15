class_name PlayerDemon
extends Node2D

signal eat_part

onready var body = $Body
onready var hand = $Hand

var clicked = false


func _ready():
	body.play("idle")
	$Tail.play("idle")
	hand.play("idle")
	

func _unhandled_input(event):
	if event.is_action_pressed("click") and hand.animation == "idle":
		clicked = true
		hand.play("start_fire")
	

func flame_on():
	hand.play("start_fire")
	

func flame_off():
	hand.play("end_fire")


func _on_DemonEat_open_mouth():
	body.play("start_eat")


func _on_DemonEat_close_mouth():
	body.play("end_eat")


func _on_Body_animation_finished():
	if body.animation == "start_eat":
		body.play("eat_loop")
	elif body.animation == "end_eat":
		body.play("idle")


func _on_Hand_animation_finished():
	if hand.animation == "start_fire":
		if clicked:
			hand.play("end_fire")
		else:
			hand.play("idle_fire")
		clicked = false
	elif hand.animation == "end_fire":
		hand.play("idle")


func _on_DemonEat_eat_part():
	emit_signal("eat_part")
