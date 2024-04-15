class_name DemonEat
extends Area2D

signal open_mouth
signal close_mouth
signal eat_part

var demon_part = null


func _physics_process(_delta):
	if is_instance_valid(demon_part) and demon_part != null and not demon_part.mouse_down:
		demon_part.part_stats.know_all_properties()
		demon_part.queue_free()
		demon_part = null
		emit_signal("eat_part")
		SoundPlayer.play_eating_sound()


func _on_DemonEat_body_entered(body):
	if GlobalValues.tutorial_step != GlobalValues.TutorialStep.FEED and GlobalValues.tutorial_step < GlobalValues.TutorialStep.FINISHED:
		return
	elif GlobalValues.tutorial_step == GlobalValues.TutorialStep.FEED:
		GlobalValues.next_tutorial_step()
	
	if body is DemonPart:
		demon_part = body


func _on_DemonEat_body_exited(_body):
	demon_part = null


func _on_MouseOpen_mouse_entered():
	emit_signal("open_mouth")


func _on_MouseOpen_mouse_exited():
	emit_signal("close_mouth")
