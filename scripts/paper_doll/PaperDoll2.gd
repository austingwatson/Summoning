tool
extends "res://scripts/paper_doll/PaperDoll.gd"

enum BackType {
	NONE,
	LEFT_ARM,
	LEFT_LEG,
}

export (int, "NONE", "LEFT_ARM", "LEFT_LEG") var back_part_type = BackType.NONE

onready var back_part = $BackPart
onready var back_part_position = $BackPartPosition


func _physics_process(_delta):
	if back_part_type != BackType.NONE:
		back_part.offset = back_part_position.position
		

func set_position(body):
	.set_position(body)
	
	match back_part_type:
		BackType.LEFT_ARM:
			back_part.position = body.left_arm.position
		BackType.LEFT_LEG:
			back_part.position = body.left_leg.position
