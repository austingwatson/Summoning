class_name Hook
extends "res://scripts/entity/FormedDemonHolder.gd"

onready var collision_shape = $CollisionShape2D


func _on_Hook_body_entered(body):
	if not has_formed_demon and body is FormedDemon:
		set_formed_dummy(body, collision_shape.global_position)
