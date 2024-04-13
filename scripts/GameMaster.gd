extends Node2D

const pact_scene = preload("res://scenes/ui/Pact.tscn")
const demon_part_scene = preload("res://scenes/entity/DemonPart.tscn")

onready var pacts = $Pacts
onready var demon_parts = $DemonParts

var month = -1


func _ready():
	next_month()


func next_month():
	month += 1
	if month == 0: # tutorial month, spawn one pact and perfect demon parts
		spawn_pacts(1)
		spawn_demon_parts(3)
	
		
func spawn_pacts(amount: int):
	for i in range(amount):
		var pact = pact_scene.instance()
		pact.position = Vector2(i * (pact.get_width() + 5) + 10, 10)
		pacts.add_child(pact)


func spawn_demon_parts(amount: int):
	for i in range(amount):
		var demon_part = demon_part_scene.instance()
		demon_part.position = Vector2(i * 50, 150)
		demon_parts.add_child(demon_part)
