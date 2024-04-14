class_name FormedDemon
extends "res://scripts/entity/DemonPart.gd"

signal new_home_set(formed_demon)

export (AtlasTexture) var body1
export (AtlasTexture) var body2
export (AtlasTexture) var body3
export (AtlasTexture) var body4

var original_position = Vector2.ZERO
var bodies = []

onready var head = $Parts/Head


func _ready():
	bodies.append(body1)
	bodies.append(body2)
	bodies.append(body3)
	bodies.append(body4)
	
	
func _physics_process(_delta):
	if not mouse_down:
		global_position = original_position
	

func form(demon_parts_array: Array):
	bodies.shuffle()
	sprite.texture = bodies[0]
	for demon_part in demon_parts_array:
		if demon_part == null:
			continue
		
		self.part_stats.lethality += demon_part.part_stats.lethality
		self.part_stats.endurance += demon_part.part_stats.endurance
		self.part_stats.charm += demon_part.part_stats.charm
		self.part_stats.speed += demon_part.part_stats.speed
		
		match demon_part.part_type:
			DemonPart.PartType.HEAD:
				head.texture = demon_part.part_stats.texture


func set_home(global_position):
	original_position = global_position
	emit_signal("new_home_set", self)
