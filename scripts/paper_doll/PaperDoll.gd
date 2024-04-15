tool
class_name PaperDoll
extends Node2D

enum FrontType {
	BODY,
	HEAD,
	RIGHT_ARM,
	RIGHT_LEG,
}

export (int, "BODY", "HEAD", "RIGHT_ARM", "RIGHT_LEG") var front_part_type = FrontType.BODY

onready var front_part = $FrontPart
onready var front_part_position = $FrontPartPosition


func set_position(body):
	match front_part_type:
		FrontType.HEAD:
			front_part.position = body.front_part_position.position
		FrontType.RIGHT_ARM:
			front_part.position = body.right_arm.position
		FrontType.RIGHT_LEG:
			front_part.position = body.right_leg.position
	
	front_part.position -= front_part_position.position
