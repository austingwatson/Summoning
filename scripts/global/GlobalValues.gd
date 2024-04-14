extends Node

enum TutorialStep {
	MOVE_PART_1,
	MOVE_PART_2,
	ACCEPT,
	MOVE_FORMED,
	CLICK_PACT,
	ACCEPT_PACT,
	CLEAR,
	FEED,
	HOOK,
	NEXT_MONTH,
	FINISHED,
}

const demon_part_scene = preload("res://scenes/entity/DemonPart.tscn")

var game_screen = null
var hook_formed_demon = null
var tutorial_step = TutorialStep.MOVE_PART_1
	

func skip_tutorial():
	for demon_part in game_screen.demon_parts.get_children():
		demon_part.queue_free()
	
	tutorial_step = TutorialStep.NEXT_MONTH
	game_screen._on_NextMonthButton_pressed()
	print(tutorial_step)


func next_tutorial_step():
	tutorial_step += 1
	
	if tutorial_step == TutorialStep.CLEAR:
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
	elif tutorial_step == TutorialStep.FINISHED and hook_formed_demon != null:
		hook_formed_demon.queue_free()