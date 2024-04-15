class_name FormedDemon
extends "res://scripts/entity/DemonPart.gd"

signal new_home_set(formed_demon)

export (PackedScene) var body1
export (PackedScene) var body2
export (PackedScene) var body3
export (PackedScene) var body4

var original_position = Vector2.ZERO
var bodies = []

onready var parts = $Parts


func _ready():
	bodies.append(body1)
	bodies.append(body2)
	bodies.append(body3)
	bodies.append(body4)
	
	
func _physics_process(_delta):
	if not mouse_down:
		global_position = original_position
	

func form(demon_parts_array: Array):
	var body = bodies[randi() % bodies.size()].instance()
	parts.add_child(body)
	set_deferred("visible", true)
	for demon_part in demon_parts_array:
		if demon_part == null:
			continue
		
		self.part_stats.lethality += demon_part.part_stats.lethality
		self.part_stats.endurance += demon_part.part_stats.endurance
		self.part_stats.charm += demon_part.part_stats.charm
		self.part_stats.speed += demon_part.part_stats.speed
		
		if demon_part.part_type != DemonPart.PartType.BODY:
			var paper_doll = demon_part.part_stats.paper_doll_scene.instance()
			parts.add_child(paper_doll)
			paper_doll.set_position(body)


func set_home(global_position):
	original_position = global_position
	emit_signal("new_home_set", self)
