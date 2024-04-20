extends Node

# arms
export (Resource) var alien_arm
export (Resource) var buff_arm
export (Resource) var crab_arm
export (Resource) var mantis_arm
export (Resource) var wing
export (Resource) var wire_arm
export (Resource) var big_foot_arm
export (Resource) var snake_arm

# bodies
export (Resource) var big_heart
export (Resource) var dead_heart
export (Resource) var iron_heart
export (Resource) var lungs
export (Resource) var small_heart
export (Resource) var spiky_heart

# heads
export (Resource) var bird_head
export (Resource) var bull_head
export (Resource) var girl_head
export (Resource) var long_horn_head
export (Resource) var mask_head
export (Resource) var pig_head
export (Resource) var pyramid_head
export (Resource) var sand_person_head
export (Resource) var snake_head

# legs
export (Resource) var average_leg
export (Resource) var bird_leg
export (Resource) var bone_leg
export (Resource) var bull_leg
export (Resource) var footless_leg
export (Resource) var thick_leg
export (Resource) var backward_knee_leg
export (Resource) var goat_leg

var arms = []
var bodies = []
var heads = []
var legs = []


func _ready():
	arms.append(alien_arm)
	arms.append(buff_arm)
	arms.append(crab_arm)
	arms.append(mantis_arm)
	arms.append(wing)
	arms.append(wire_arm)
	arms.append(big_foot_arm)
	arms.append(snake_arm)
	
	bodies.append(big_heart)
	bodies.append(dead_heart)
	bodies.append(iron_heart)
	bodies.append(lungs)
	bodies.append(small_heart)
	bodies.append(spiky_heart)
	
	heads.append(bird_head)
	heads.append(bull_head)
	heads.append(girl_head)
	heads.append(long_horn_head)
	heads.append(mask_head)
	heads.append(pig_head)
	heads.append(pyramid_head)
	heads.append(sand_person_head)
	heads.append(snake_head)
	
	legs.append(average_leg)
	legs.append(bird_leg)
	legs.append(bone_leg)
	legs.append(bull_leg)
	legs.append(footless_leg)
	legs.append(thick_leg)
	legs.append(backward_knee_leg)
	legs.append(goat_leg)
	

func reset():
	for arm in arms:
		arm.forget_all_properties()
	for body in bodies:
		body.forget_all_properties()
	for head in heads:
		head.forget_all_properties()
	for leg in legs:
		leg.forget_all_properties()


func show_all_properties():
	for arm in arms:
		arm.know_all_properties()
	for body in bodies:
		body.know_all_properties()
	for head in heads:
		head.know_all_properties()
	for leg in legs:
		leg.know_all_properties()


func get_random_arm():
	return arms[randi() % arms.size()]


func get_random_body():
	return bodies[randi() % bodies.size()]
	

func get_random_head():
	return heads[randi() % heads.size()]
	

func get_random_leg():
	return legs[randi() % legs.size()]
