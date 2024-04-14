class_name SummoningCircle
extends "res://scripts/entity/FormedDemonHolder.gd"


var current_formed_demon = null


func _on_SummoningCircle_body_entered(body):
	if GlobalValues.tutorial_step == GlobalValues.TutorialStep.MOVE_FORMED:
		GlobalValues.next_tutorial_step()
	
	if not has_formed_demon and body is FormedDemon:
		set_formed_dummy(body, self.global_position)
		current_formed_demon = body
