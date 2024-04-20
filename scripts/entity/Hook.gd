class_name Hook
extends "res://scripts/entity/FormedDemonHolder.gd"

onready var animation_player = $AnimationPlayer
onready var collision_shape = $CollisionShape2D
onready var background_hook = $BackgroundHook
onready var foreground_hook = $ForegroundHook
onready var formed_demon_pos = $FormedDemonPos


func _physics_process(_delta):
	if has_formed_demon and not formed_demon.mouse_down:
		if GlobalValues.tutorial_step == GlobalValues.TutorialStep.HOOK:
			GlobalValues.hook_formed_demon = formed_demon
			GlobalValues.next_tutorial_step()
		
		foreground_hook.visible = true
		if background_hook.position != Vector2.ZERO:
			animation_player.play("RESET")
	else:
		foreground_hook.visible = false
		

func _on_FormedDummy_new_home_set(formed_demon):
	if has_formed_demon:
		var has_head = false
		var has_legs = false
		for part in formed_demon.parts.get_children():
			if part.front_part_type == PaperDoll.FrontType.HEAD:
				has_head = true
				break
			elif part.front_part_type == PaperDoll.FrontType.RIGHT_LEG:
				has_legs = true
		if not has_head and not has_legs:
			formed_demon.parts.position.y = 25
	._on_FormedDummy_new_home_set(formed_demon)


func _on_Hook_body_entered(body):
	if GlobalValues.tutorial_step < GlobalValues.TutorialStep.HOOK:
		return
	
	if not has_formed_demon and body is FormedDemon:
		var has_head = false
		var has_legs = false
		for part in body.parts.get_children():
			if part.front_part_type == PaperDoll.FrontType.HEAD:
				has_head = true
			elif part.front_part_type == PaperDoll.FrontType.RIGHT_LEG:
				has_legs = true
		if not has_head and not has_legs:
			print("has neighter")
			body.parts.position.y = 0
		set_formed_dummy(body, formed_demon_pos.global_position)
		SoundPlayer.play_hook_sound()
		

func _on_HookBobRange_mouse_entered():
	if has_formed_demon and not formed_demon.mouse_down:
		return
	
	animation_player.play("bob_hook")


func _on_HookBobRange_mouse_exited():
	animation_player.play("RESET")
