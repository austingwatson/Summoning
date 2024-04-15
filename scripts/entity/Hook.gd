class_name Hook
extends "res://scripts/entity/FormedDemonHolder.gd"

onready var animation_player = $AnimationPlayer
onready var collision_shape = $CollisionShape2D
onready var background_hook = $BackgroundHook
onready var foreground_hook = $ForegroundHook


func _physics_process(_delta):
	if has_formed_demon and not formed_demon.mouse_down:
		foreground_hook.visible = true
		if background_hook.position != Vector2.ZERO:
			animation_player.play("RESET")
	else:
		foreground_hook.visible = false
		
		if has_formed_demon:
			SoundPlayer.play_hook_sound()


func _on_Hook_body_entered(body):
	if GlobalValues.tutorial_step < GlobalValues.TutorialStep.HOOK:
		return
	elif GlobalValues.tutorial_step == GlobalValues.TutorialStep.HOOK:
		GlobalValues.hook_formed_demon = body
		GlobalValues.next_tutorial_step()
	
	if not has_formed_demon and body is FormedDemon:
		set_formed_dummy(body, collision_shape.global_position)
		

func _on_HookBobRange_mouse_entered():
	if has_formed_demon and not formed_demon.mouse_down:
		return
	
	animation_player.play("bob_hook")


func _on_HookBobRange_mouse_exited():
	animation_player.play("RESET")
