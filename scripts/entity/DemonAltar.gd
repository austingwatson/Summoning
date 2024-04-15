class_name DemonAltar
extends "res://scripts/entity/FormedDemonHolder.gd"

const formed_demon_scene = preload("res://scenes/entity/FormedDemon.tscn")

export (AtlasTexture) var base_accept
export (AtlasTexture) var hover_accept_1
export (AtlasTexture) var hover_accept_2

var parts = {}
var current_demon_parts = []

onready var part_positions = $PartPositions
onready var accept_sprite = $AcceptSprite
onready var animation_player = $AnimationPlayer

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
	
	accept_sprite.texture = base_accept
	

func _physics_process(_delta):
	for demon_part in current_demon_parts:
		if not demon_part.mouse_down:
			parts[demon_part.part_type] = demon_part
			demon_part.disable()
			var array = get_closest_open_part_position(demon_part)
			demon_part.global_position = array[0]
			demon_part.part_position_index = array[1]
			demon_part.alter_location = array[0]
			current_demon_parts.erase(demon_part)


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
	

func get_closest_open_part_position(demon_part) -> Array:
	var closest: Position2D
	var closest_distance = 1.79769e308
	var index = 0
	
	for i in range(part_positions.get_child_count()):
		var position = part_positions.get_child(i)
		if not position.visible:
			continue
		
		var distance = demon_part.global_position.distance_to(position.global_position)
		if distance < closest_distance:
			closest = position
			closest_distance = distance
			index = i
	
	closest.visible = false
	return [closest.global_position, index]
	

func set_accept_texture(frame):
	if frame == 0:
		accept_sprite.texture = hover_accept_1
	elif frame == 1:
		accept_sprite.texture = hover_accept_2


func _on_DemonAltar_body_entered(body):
	if GlobalValues.tutorial_step <= GlobalValues.TutorialStep.MOVE_PART_2:
		GlobalValues.next_tutorial_step()
	
	if not has_formed_demon and body is DemonPart:
		current_demon_parts.append(body)


func _on_DemonAltar_body_exited(body):
	if body is DemonPart:
		current_demon_parts.erase(body)
		var index = body.part_position_index
		if index >= 0:
			parts[body.part_type] = null
			part_positions.get_child(index).visible = true
			body.part_position_index = -1


func _on_Accept_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_action_pressed("click"):
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


func _on_Accept_mouse_entered():
	animation_player.play("hover")


func _on_Accept_mouse_exited():
	accept_sprite.texture = base_accept
	animation_player.stop()
