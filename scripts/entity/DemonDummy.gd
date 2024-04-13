class_name DemonDummy
extends Node2D


func remove_all():
	pass


func _on_Head_body_entered(body):
	if body is DemonPart and body.part_type == DemonPart.PartType.HEAD:
		body.disable()
