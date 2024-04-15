class_name SummoningCircle
extends "res://scripts/entity/FormedDemonHolder.gd"

onready var animated_sprite = $AnimatedSprite
onready var candles = $Candles

var current_formed_demon = null


func _ready():
	animated_sprite.play("idle")
	
	
func _physics_process(_delta):
	var ready = true
	for candle in candles.get_children():
		ready = ready and candle.flame.visible
	if ready and (animated_sprite.animation == "idle" or animated_sprite.animation == "mouse_over"):
		if current_formed_demon != null:
			animated_sprite.play("demon_on")
		else:
			animated_sprite.play("ready")
	elif not ready and animated_sprite.animation != "mouse_over" and animated_sprite.animation != "summon":
		animated_sprite.play("idle")


func summon():
	animated_sprite.play("summon")
	SoundPlayer.play_summon_sound()


func _on_SummoningCircle_body_entered(body):
	if GlobalValues.tutorial_step == GlobalValues.TutorialStep.MOVE_FORMED:
		GlobalValues.next_tutorial_step()
	
	if not has_formed_demon and body is FormedDemon:
		set_formed_dummy(body, self.global_position)
		current_formed_demon = body
		
		if animated_sprite.animation == "ready":
			animated_sprite.play("demon_on")


func _on_SummoningCircle_mouse_entered():
	if animated_sprite.animation == "idle":
		animated_sprite.play("mouse_over")


func _on_SummoningCircle_mouse_exited():
	if animated_sprite.animation == "mouse_over":
		animated_sprite.play("idle")


func _on_AnimatedSprite_animation_finished():
	if animated_sprite.animation == "summon":
		for candle in candles.get_children():
			candle.flame.visible = false
		animated_sprite.play("idle")


func _on_AutoLightTimer_timeout():
	for candle in candles.get_children():
		if not candle.flame.visible:
			candle.flame.visible = true
			break
