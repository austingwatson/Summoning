class_name FormedDemonHolder
extends Area2D

var has_formed_demon = false


func set_formed_dummy(formed_demon, home_position):
	formed_demon.connect("new_home_set", self, "_on_FormedDummy_new_home_set")
	formed_demon.set_home(home_position)


func _on_FormedDummy_new_home_set(formed_demon):
	if has_formed_demon:
		formed_demon.disconnect("new_home_set", self, "_on_FormedDummy_new_home_set")
		has_formed_demon = false
	else:
		has_formed_demon = true
