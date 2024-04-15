class_name DemonPart
extends RigidBody2D

signal flame_on
signal flame_off

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
var part_position_index = -1
var alter_location = Vector2.ZERO

onready var collision_shape = $CollisionShape2D
onready var flame = $Flame
onready var sprite = $Sprite
onready var tool_tip = $ToolTip


func _ready():
	sprite.texture = part_stats.texture
	if part_type != PartType.FORMED:
		collision_shape.shape.extents = sprite.texture.get_size() / 2


func _unhandled_input(event):
	if mouse_inside and event.is_action_pressed("grab"):
		mouse_down = true
		tool_tip.visible = false
		flame.visible = true
		flame.frame = 0
		flame.play("spark")
		emit_signal("flame_on")
		enable()
		apply_central_impulse(Vector2(0, -LIFT_CONSTANT))
	elif mouse_down and event.is_action_released("grab"):
		mouse_down = false
		flame.visible = false
		emit_signal("flame_off")
		
		if part_position_index >= 0:
			disable()
			set_deferred("global_position", alter_location)
		else:
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
	#collision_shape.set_deferred("disabled", false)
	set_deferred("mode", RigidBody2D.MODE_RIGID)
	

func disable():
	#collision_shape.set_deferred("disabled", true)
	set_deferred("mode", RigidBody2D.MODE_KINEMATIC)
	mouse_down = false
	flame.visible = false
	emit_signal("flame_off")
	#call_deferred("enable")
	

func push():
	var closest_position = Vector2(10000, 10000)
	var closest_distance = 10000
	for other_demon_part in other_demon_parts:
		var distance = self.global_position.distance_to(other_demon_part.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_position = other_demon_part.global_position
	
	#var added_global_positions = Vector2.ZERO
	#for other_demon_part in other_demon_parts:
	#	added_global_positions += other_demon_part.global_position
	#var distance = self.global_position.distance_to(added_global_positions)
	var distance = closest_distance
	if distance != 0.0:
		distance = 1 / distance * 2500
	var direction = self.global_position.direction_to(closest_position)

	#print(distance)

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


func _on_Flame_animation_finished():
	flame.play("holding")


func _on_OrganBeatTimer_timeout():
	if part_type != PartType.BODY:
		sprite.position.y = 0
		$OrganBeatTimer.stop()
	
	sprite.position.y *= -1
