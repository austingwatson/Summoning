class_name DemonEat
extends Area2D

signal open_mouth
signal close_mouth

var demon_part = null


func _physics_process(_delta):
	if is_instance_valid(demon_part) and demon_part != null and not demon_part.mouse_down:
		demon_part.part_stats.know_random_property()
		demon_part.queue_free()
		demon_part = null


func _on_DemonEat_body_entered(body):
	if body is DemonPart:
		demon_part = body


func _on_DemonEat_body_exited(body):
	demon_part = null


func _on_MouseOpen_mouse_entered():
	emit_signal("open_mouth")


func _on_MouseOpen_mouse_exited():
	emit_signal("close_mouth")
