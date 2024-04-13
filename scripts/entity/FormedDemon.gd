class_name FormedDemon
extends "res://scripts/entity/DemonPart.gd"

signal new_home_set(formed_demon)

var original_position = Vector2.ZERO
	
	
func _physics_process(_delta):
	if not mouse_down:
		global_position = original_position
	

func add_part_stats(part_stats_array: Array):
	for part_stat in part_stats_array:
		self.part_stats.lethality += part_stat.lethality
		self.part_stats.endurance += part_stat.endurance
		self.part_stats.charm += part_stat.charm
		self.part_stats.speed += part_stat.speed


func set_home(global_position):
	original_position = global_position
	emit_signal("new_home_set", self)
