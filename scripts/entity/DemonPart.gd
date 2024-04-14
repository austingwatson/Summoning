class_name DemonPart
extends RigidBody2D

enum PartType {
	HEAD,
	BODY,
	ARM,
	LEG,
	FORMED,
}

const SPRING_CONSTANT = 1000
const LIFT_CONSTANT = 4000

export (PartType) var part_type = PartType.HEAD
export var part_stats: Resource

var mouse_inside = false
var mouse_down = false

var other_demon_parts = []
var being_pushed = false

onready var collision_shape = $CollisionShape2D
onready var sprite = $Sprite
onready var tool_tip = $ToolTip


func _ready():
	part_stats.set_known_properties()


func _unhandled_input(event):
	if mouse_inside and event.is_action_pressed("grab"):
		mouse_down = true
		tool_tip.visible = false
		apply_central_impulse(Vector2(0, -LIFT_CONSTANT))
	elif mouse_down and event.is_action_released("grab"):
		mouse_down = false
		apply_central_impulse(Vector2(0, LIFT_CONSTANT))


func _physics_process(delta):
	if mouse_down:
		apply_central_impulse(SPRING_CONSTANT * get_local_mouse_position() * delta)
	
	var direction = linear_velocity.normalized()
	direction *= Vector2(-1, -1)
	apply_central_impulse(direction)
	
	if being_pushed and not mouse_down:
		push()
		
	rotation_degrees = 0
	

func enable():
	collision_shape.set_deferred("disabled", false)
	set_deferred("mode", RigidBody2D.MODE_RIGID)
	

func disable():
	collision_shape.set_deferred("disabled", true)
	set_deferred("mode", RigidBody2D.MODE_KINEMATIC)
	mouse_down = false
	

func push():
	var added_global_positions = Vector2.ZERO
	for other_demon_part in other_demon_parts:
		added_global_positions += other_demon_part.global_position
	var distance = 100 - self.global_position.distance_to(added_global_positions)
	var direction = self.global_position.direction_to(added_global_positions)
	
	apply_central_impulse(-direction * distance)
	

func fling(direction):
	apply_central_impulse(direction)


func _on_DemonPart_mouse_entered():
	mouse_inside = true
	if part_type != PartType.FORMED and not mouse_down:
		tool_tip.set_info(part_stats)
		tool_tip.visible = true


func _on_DemonPart_mouse_exited():
	mouse_inside = false
	tool_tip.visible = false


func _on_PushArea_body_entered(body):
	if body.get_class() == "DemonPart" and body != self:
		other_demon_parts.append(body)
		being_pushed = true
	
	
func _on_PushArea_body_exited(body):
	if body.get_class() == "DemonPart" and body != self:
		other_demon_parts.erase(body)
		if other_demon_parts.empty():
			being_pushed = false
	

func get_class():
	return "DemonPart"
