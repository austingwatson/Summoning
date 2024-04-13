extends Node2D

var part_stats = PartStat.new()

func _ready():
	part_stats.generate_random(5)
	

func get_width() -> int:
	return 85
