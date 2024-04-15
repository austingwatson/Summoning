tool
extends Node


func _physics_process(_delta):
	if get_child_count() == 0:
		return
	
	var body = get_child(0)
	for i in range(1, get_child_count()):
		var part = get_child(i)
		part.set_position(body)
