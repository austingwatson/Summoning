extends Reference

const pact_scene = preload("res://scenes/ui/Pact.tscn")
const demon_part_scene = preload("res://scenes/entity/DemonPart.tscn")
const MAX_PACTS = 6
const MAX_DEMON_PARTS = 12

var month = -1


func next_month(game_screen, current_pacts, current_demon_parts):
	month += 1
	if month == 0: # tutorial month, spawn one pact and perfect demon parts
		# tutorial pact
		var pact = pact_scene.instance()
		pact.position = Vector2(10, 10)
		game_screen.add_pact(pact)
		pact.part_stats.set_all(1, 1, 0, 0)
		
		# tutorial head part
		var head_part = demon_part_scene.instance()
		head_part.part_type = DemonPart.PartType.HEAD
		head_part.part_stats = preload("res://resources/TutorialHead.tres")
		head_part.position = Vector2(150, 150)
		game_screen.add_demon_part(head_part)
		
		# tutorial body part
		var body_part = demon_part_scene.instance()
		body_part.part_type = DemonPart.PartType.BODY
		body_part.part_stats = preload("res://resources/TutorialBody.tres")
		body_part.position = Vector2(50, 150)
		game_screen.add_demon_part(body_part)
	else:
		spawn_pacts(game_screen, min(2, MAX_PACTS - current_pacts))
		spawn_demon_parts(game_screen, min(4, MAX_DEMON_PARTS - current_demon_parts))
	
		
func spawn_pacts(game_screen, amount: int):
	var last_pact = game_screen.get_last_pact()
	var offset = 10
	if last_pact != null:
		offset = last_pact.global_position.x + last_pact.get_width() + 5
	
	for i in range(amount):
		var pact = pact_scene.instance()
		pact.position = Vector2(i * (pact.get_width() + 5) + offset, 10)
		game_screen.add_pact(pact)


func spawn_demon_parts(game_screen, amount: int):
	for i in range(amount):
		var demon_part = demon_part_scene.instance()
		demon_part.global_position = game_screen.get_demon_part_spawn_point()
		demon_part.part_type = i
		game_screen.add_demon_part(demon_part)
