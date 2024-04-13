extends Node

var game_master = preload("res://scripts/GameMaster.gd").new()
var failures_left = 5

onready var summoning_circle = $SummoningCircle
onready var pacts = $Pacts
onready var demon_parts = $DemonParts
onready var next_month_button = $Month/NextMonthButton
onready var disable_month_timer = $Month/DisableMonthTimer

onready var left = $DemonPartSpawnBoundary/Left
onready var right = $DemonPartSpawnBoundary/Right
onready var top = $DemonPartSpawnBoundary/Top
onready var bottom = $DemonPartSpawnBoundary/Bottom


func _ready():
	game_master.next_month(self, pacts.get_child_count(), demon_parts.get_child_count())
	

func add_pact(pact):
	pact.summoning_circle = summoning_circle
	pacts.add_child(pact)
	pact.connect("accepted", self, "_on_pact_accepted")
	

func get_last_pact():
	if pacts.get_child_count() > 0:
		return pacts.get_child(pacts.get_child_count() - 1)
	else:
		return null


func get_demon_part_spawn_point() -> Vector2:
	var x = rand_range(left.global_position.x, right.global_position.x)
	var y = rand_range(bottom.global_position.y, top.global_position.y)
	return Vector2(x, y)
	

func add_demon_part(demon_part):
	demon_parts.add_child(demon_part)
	

func _on_pact_accepted(accepted):
	if accepted:
		print("Pact Accepted")
	else:
		failures_left -= 1
		if failures_left <= 0:
			print("Game Over")


func _on_NextMonthButton_pressed():
	game_master.next_month(self, pacts.get_child_count(), demon_parts.get_child_count())
	disable_month_timer.start()
	next_month_button.disabled = true


func _on_DisableMonthTimer_timeout():
	next_month_button.disabled = false
