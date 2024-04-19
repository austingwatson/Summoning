extends Node2D

const EYE_BALL_DISTANCE = 5

onready var eye = $Pupil

var original_eye_position


func _ready():
	original_eye_position = eye.global_position


func _physics_process(_delta):
	#eye.position = Vector2.ZERO
	var direction = original_eye_position.direction_to(get_global_mouse_position())
	eye.position = lerp(eye.position, direction * EYE_BALL_DISTANCE, 0.1)
