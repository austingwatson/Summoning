extends Node

enum TutorialStep {
	MOVE_PART_1,   # 0
	MOVE_PART_2,   # 1
	ACCEPT,        # 2
	MOVE_FORMED,   # 3
	LIGHT_CANDLES, # 4
	CLICK_PACT,    # 5
	ACCEPT_PACT,   # 6
	CLEAR,         # 7
	FEED,          # 8
	HOOK,          # 9
	NEXT_MONTH,    # 10
	FINISHED,      # 11
}

const demon_part_scene = preload("res://scenes/entity/DemonPart.tscn")

var game_screen = null
var hook_formed_demon = null
var tutorial_step = TutorialStep.MOVE_PART_1

var current_souls = [0, 0, 0, 0]
var needed_souls = 2
var pact_dif = 1

var total_months_worked = 0
var total_pacts_completed = 0
var total_pacts_failed = 0
var total_parts_eaten = 0
	

func skip_tutorial():
	for demon_part in game_screen.demon_parts.get_children():
		demon_part.queue_free()
	
	tutorial_step = TutorialStep.NEXT_MONTH
	game_screen._on_NextMonthButton_pressed()
	#print(tutorial_step)
	

func _physics_process(_delta):
	#print(tutorial_step)
	pass


func next_tutorial_step():
	tutorial_step += 1
	
	if tutorial_step == TutorialStep.ACCEPT:
		game_screen.get_node("SpeechBubble").next_line(3)
	elif tutorial_step == TutorialStep.MOVE_FORMED:
		game_screen.get_node("DemonAltar").remove_all_stats()
		game_screen.get_node("SpeechBubble").next_line(4)
	elif tutorial_step == TutorialStep.LIGHT_CANDLES:
		game_screen.get_node("SummoningCircle").stop_candles()
		game_screen.get_node("SpeechBubble").next_line(5)
	elif tutorial_step == TutorialStep.CLICK_PACT:
		game_screen.get_node("SpeechBubble").next_line(6)
	elif tutorial_step == TutorialStep.CLEAR:
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
		
		# tutorial leg part
		var leg_part = demon_part_scene.instance()
		leg_part.part_type = DemonPart.PartType.LEG
		leg_part.part_stats = preload("res://resources/parts/tutorial/TutorialLeg.tres")
		leg_part.position = Vector2(50, 200)
		game_screen.add_demon_part(leg_part)
		
		# tutorial arm part
		var arm_part = demon_part_scene.instance()
		arm_part.part_type = DemonPart.PartType.ARM
		arm_part.part_stats = preload("res://resources/parts/tutorial/TutorialArm.tres")
		arm_part.position = Vector2(150, 200)
		game_screen.add_demon_part(arm_part)
		
		next_tutorial_step()
	elif tutorial_step == TutorialStep.ACCEPT_PACT:
		game_screen.get_node("SpeechBubble").next_line(7)
	elif tutorial_step == TutorialStep.FEED:
		game_screen.get_node("SpeechBubble").next_line(8)
		game_screen.get_node("SpeechBubble").can_skip = true
	elif tutorial_step == TutorialStep.HOOK:
		game_screen.get_node("SpeechBubble").next_line(10)
	elif tutorial_step == TutorialStep.NEXT_MONTH:
		game_screen.enable_month_button()
		game_screen.get_node("SpeechBubble").next_line(11)
		game_screen.get_node("SpeechBubble").can_skip = true
	elif tutorial_step == TutorialStep.FINISHED and hook_formed_demon != null:
		game_screen.get_node("Hook").has_formed_demon = false
		hook_formed_demon.queue_free()
		
		for part in game_screen.demon_parts.get_children():
			part.queue_free()
			
	if tutorial_step > TutorialStep.FINISHED:
		tutorial_step = TutorialStep.FINISHED


func reset():
	for i in range(current_souls.size()):
		current_souls[i] = 0
	needed_souls = 2
	pact_dif = 1
	
	total_months_worked = 0
	total_pacts_completed = 0
	total_pacts_failed = 0
	total_parts_eaten = 0
	
	DemonPartList.reset()


func add_soul(soul_amount):
	for i in range(soul_amount.size()):
		current_souls[i] += soul_amount[i]
