class_name DemonAltar
extends "res://scripts/entity/FormedDemonHolder.gd"

const formed_demon_scene = preload("res://scenes/entity/FormedDemon.tscn")

var parts = {}

onready var part_positions = $PartPositions

func _ready():
	empty_parts()
	
	var demon_part_scene = preload("res://scenes/entity/DemonPart.tscn")
	
	var leg_part = demon_part_scene.instance()
	leg_part.part_type = DemonPart.PartType.HEAD
	leg_part.part_stats = preload("res://resources/parts/tutorial/TutorialLeg.tres")
	leg_part.global_position = part_positions.get_child(0).global_position
	leg_part.part_type = DemonPart.PartType.LEG
	get_parent().call_deferred("add_demon_part", leg_part)
	leg_part.call_deferred("disable")
	parts[DemonPart.PartType.LEG] = leg_part
	part_positions.get_child(0).visible = false
	
	var arm_part = demon_part_scene.instance()
	arm_part.part_type = DemonPart.PartType.HEAD
	arm_part.part_stats = preload("res://resources/parts/tutorial/TutorialArm.tres")
	arm_part.global_position = part_positions.get_child(2).global_position
	arm_part.part_type = DemonPart.PartType.ARM
	get_parent().call_deferred("add_demon_part", arm_part)
	arm_part.call_deferred("disable")
	parts[DemonPart.PartType.ARM] = arm_part
	part_positions.get_child(2).visible = false


func empty_parts():
	for part in parts.values():
		if part != null:
			part.enable()
			part.call_deferred("fling", Vector2(rand_range(-25000, 0), 10000))
	
	parts[DemonPart.PartType.HEAD] = null
	parts[DemonPart.PartType.BODY] = null
	parts[DemonPart.PartType.ARM] = null
	parts[DemonPart.PartType.LEG] = null
	
	for position in part_positions.get_children():
		position.visible = true
	

func get_closest_open_part_position(demon_part) -> Vector2:
	var closest: Position2D
	var closest_distance = 1.79769e308
	
	for position in part_positions.get_children():
		if not position.visible:
			continue
		
		var distance = demon_part.global_position.distance_to(position.global_position)
		if distance < closest_distance:
			closest = position
			closest_distance = distance
	
	closest.visible = false
	return closest.global_position


func _on_DemonAltar_body_entered(body):
	if GlobalValues.tutorial_step <= GlobalValues.TutorialStep.MOVE_PART_2:
		GlobalValues.next_tutorial_step()
	
	if not has_formed_demon and body is DemonPart and body.mouse_down:
		if body.part_type != DemonPart.PartType.FORMED and parts[body.part_type] == null:
			parts[body.part_type] = body
			body.disable()
			body.global_position = get_closest_open_part_position(body)


func _on_Accept_pressed():
	if GlobalValues.tutorial_step != GlobalValues.TutorialStep.ACCEPT and GlobalValues.tutorial_step < GlobalValues.TutorialStep.HOOK:
		return
	elif GlobalValues.tutorial_step == GlobalValues.TutorialStep.ACCEPT:
		GlobalValues.next_tutorial_step()
	
	if has_formed_demon:
		return
	
	var parts_stats = []
	
	for part in parts.values():
		if part != null:
			parts_stats.append(part.part_stats)
			part.queue_free()
			
	if not parts_stats.empty():
		var formed_demon = formed_demon_scene.instance()
		get_parent().add_child(formed_demon)
		
		formed_demon.form(parts.values())
		set_formed_dummy(formed_demon, self.global_position)
	
	empty_parts()


func _on_Clear_pressed():
	if GlobalValues.tutorial_step < GlobalValues.TutorialStep.CLEAR:
		return
	elif GlobalValues.tutorial_step == GlobalValues.TutorialStep.CLEAR:
		GlobalValues.next_tutorial_step()
	
	empty_parts()
