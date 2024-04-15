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
		head_part.part_stats = preload("res://resources/parts/tutorial/TutorialHead.tres")
		head_part.position = Vector2(150, 150)
		game_screen.add_demon_part(head_part)
		
		# tutorial body part
		var body_part = demon_part_scene.instance()
		body_part.part_type = DemonPart.PartType.BODY
		body_part.part_stats = preload("res://resources/parts/tutorial/TutorialBody.tres")
		body_part.position = Vector2(50, 150)
		game_screen.add_demon_part(body_part)
	elif month == 1:
		GlobalValues.next_tutorial_step()
		spawn_pacts(game_screen, min(1, MAX_PACTS - current_pacts))
		spawn_demon_parts(game_screen, min(4, MAX_DEMON_PARTS - current_demon_parts))
	else:
		spawn_pacts(game_screen, min(3, MAX_PACTS - current_pacts))
		spawn_demon_parts(game_screen, min(8, MAX_DEMON_PARTS - current_demon_parts))
	
		
func spawn_pacts(game_screen, amount: int):
	var last_pact = game_screen.get_last_pact()
	var offset = 10
	if last_pact != null:
		offset = last_pact.global_position.x + last_pact.get_width() + 5
	
	for i in range(amount):
		if not is_instance_valid(game_screen):
			return
		
		var pact = pact_scene.instance()
		pact.position = Vector2(i * (pact.get_width() + 5) + offset, 10)
		game_screen.add_pact(pact)
		yield(game_screen.get_tree().create_timer(1), "timeout")


func spawn_demon_parts(game_screen, amount: int):
	var spread = amount / 4
	for _i in range(spread):
		if not is_instance_valid(game_screen):
			return
		
		var head = demon_part_scene.instance()
		head.part_stats = DemonPartList.get_random_head()
		head.part_type = DemonPart.PartType.HEAD
		head.global_position = game_screen.get_demon_part_spawn_point()
		game_screen.add_demon_part(head)
		
		var body = demon_part_scene.instance()
		body.part_stats = DemonPartList.get_random_body()
		body.part_type = DemonPart.PartType.BODY
		body.global_position = game_screen.get_demon_part_spawn_point()
		game_screen.add_demon_part(body)
		
		var arm = demon_part_scene.instance()
		arm.part_stats = DemonPartList.get_random_arm()
		arm.part_type = DemonPart.PartType.ARM
		arm.global_position = game_screen.get_demon_part_spawn_point()
		game_screen.add_demon_part(arm)
		
		var leg = demon_part_scene.instance()
		leg.part_stats = DemonPartList.get_random_leg()
		leg.part_type = DemonPart.PartType.LEG
		leg.global_position = game_screen.get_demon_part_spawn_point()
		game_screen.add_demon_part(leg)
	for _i in range(amount - (spread * 4)):
		var random = demon_part_scene.instance()
		var rng = randi() % 4
		match rng:
			0:
				random.part_stats = DemonPartList.get_random_arm()
				random.part_type = DemonPart.PartType.ARM
			1:
				random.part_stats = DemonPartList.get_random_body()
				random.part_type = DemonPart.PartType.BODY
			2:
				random.part_stats = DemonPartList.get_random_head()
				random.part_type = DemonPart.PartType.HEAD
			3:
				random.part_stats = DemonPartList.get_random_leg()
				random.part_type = DemonPart.PartType.LEG
		random.global_position = game_screen.get_demon_part_spawn_point()
		game_screen.add_demon_part(random)
