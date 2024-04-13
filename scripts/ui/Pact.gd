extends Node2D

signal accepted(accepted)

var part_stats = PartStats.new()
var summoning_circle: SummoningCircle

func _ready():
	part_stats.generate_random(2)
	

func get_width() -> int:
	return 85


func summoning_circle_has_formed_demon(formed_demon):
	print(formed_demon)


func _on_Accept_pressed():
	var formed_demon = summoning_circle.current_formed_demon
	if formed_demon != null:
		var accepted = part_stats.check_score(formed_demon.part_stats, 0)
		emit_signal("accepted", accepted)
		formed_demon.queue_free()
		summoning_circle.current_formed_demon = null
		summoning_circle.has_formed_demon = false
		self.queue_free()
