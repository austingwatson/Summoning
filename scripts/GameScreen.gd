extends Node

var game_master = preload("res://scripts/GameMaster.gd").new()
var failures_left = 5
var pact_locations_occupied = [false, false, false, false, false, false]

onready var summoning_circle = $SummoningCircle
onready var pacts = $Pacts
onready var player_demon = $PlayerDemon
onready var demon_parts = $DemonParts
onready var next_month_button = $Month/NextMonthButton
onready var disable_month_timer = $Month/DisableMonthTimer

onready var left = $DemonPartSpawnBoundary/Left
onready var right = $DemonPartSpawnBoundary/Right
onready var top = $DemonPartSpawnBoundary/Top
onready var bottom = $DemonPartSpawnBoundary/Bottom

onready var pact_locations = $PactLocations
onready var hud = $HUD

var pacts_success = 0
var pacts_fail = 0
var parts_eaten = 0


func _ready():
	SoundPlayer.stop_music()
	
	GlobalValues.game_screen = self
	MonthlyReport.game_screen = self
	game_master.next_month(self, pacts.get_child_count(), demon_parts.get_child_count())
	
	# for debugging only, comment out for full game
	call_deferred("skip_tutorial")
	GlobalValues.reset()
	

func skip_tutorial():
	for pact in pacts.get_children():
		pact.queue_free()
	for i in range(pact_locations_occupied.size()):
		pact_locations_occupied[i] = false
	
	GlobalValues.skip_tutorial()
	$DemonAltar.empty_parts()
	start_month()


func add_pact(pact):
	pact.summoning_circle = summoning_circle
	pacts.add_child(pact)
	pact.connect("accepted", self, "_on_pact_accepted")
	
	for i in range(pact_locations.get_child_count()):
		if not pact_locations_occupied[i]:
			pact_locations_occupied[i] = true
			pact.global_position = pact_locations.get_child(i).global_position
			pact.z_index = i
			pact.pact_position = i
			break


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
	demon_part.connect("flame_on", self, "flame_on")
	demon_part.connect("flame_off", self, "flame_off")
	

func flame_on():
	player_demon.flame_on()
	

func flame_off():
	player_demon.flame_off()
	

func start_month():
	game_master.next_month(self, pacts.get_child_count(), demon_parts.get_child_count())
	disable_month_timer.start()
	
	GlobalValues.total_pacts_completed += pacts_success
	GlobalValues.total_pacts_failed += pacts_fail
	GlobalValues.total_parts_eaten += parts_eaten
	
	pacts_success = 0
	pacts_fail = 0
	parts_eaten = 0
	if game_master.month % 2 == 0:
		GlobalValues.pact_dif += 1
	

func _on_pact_accepted(accepted, pact_position, soul_amount):
	pact_locations_occupied[pact_position] = false
	if accepted:
		pacts_success += 1
		GlobalValues.add_soul(soul_amount)
		hud.update_soul()
	else:
		pacts_fail += 1
		GlobalValues.needed_souls += 1


func update_hud():
	hud.update_soul()


func _on_NextMonthButton_pressed():
	if GlobalValues.tutorial_step < GlobalValues.TutorialStep.NEXT_MONTH:
		return
	
	for pact in pacts.get_children():
		pact.next_month()
	
	MonthlyReport.open(pacts_success, pacts_fail, parts_eaten, [9, 9, 9, 9])
	next_month_button.disabled = true


func _on_DisableMonthTimer_timeout():
	next_month_button.disabled = false


func _on_PlayerDemon_eat_part():
	parts_eaten += 1
