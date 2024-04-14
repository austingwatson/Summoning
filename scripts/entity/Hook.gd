class_name Hook
extends "res://scripts/entity/FormedDemonHolder.gd"

onready var collision_shape = $CollisionShape2D


func _on_Hook_body_entered(body):
	if GlobalValues.tutorial_step < GlobalValues.TutorialStep.HOOK:
		return
	elif GlobalValues.tutorial_step == GlobalValues.TutorialStep.HOOK:
		GlobalValues.hook_formed_demon = body
		GlobalValues.next_tutorial_step()
	
	if not has_formed_demon and body is FormedDemon:
		set_formed_dummy(body, collision_shape.global_position)


func _on_Hook_mouse_entered():
	print("bob hook")
