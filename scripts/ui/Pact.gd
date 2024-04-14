extends Node2D

signal accepted(accepted, pact_position)

export (AtlasTexture) var new_pact
export (AtlasTexture) var old_pact
export (AtlasTexture) var expiring_pact

onready var highlight = $Highlight
onready var pact = $Pact

var part_stats = PartStats.new()
var summoning_circle: SummoningCircle
var months_left = 3
var mouse_inside = false
var mouse_down = false
var pact_position = 0

func _ready():
	part_stats.generate_random(true, 2)
	pact.texture = new_pact
	
	
func _input(event):
	if mouse_inside and event.is_action_released("click"):
		mouse_down = not mouse_down
		if mouse_down:
			if GlobalValues.tutorial_step == GlobalValues.TutorialStep.CLICK_PACT:
				GlobalValues.next_tutorial_step()
			
			OpenedPact.open(self)
		else:
			OpenedPact.close()
	

func get_width() -> int:
	return 85


func next_month():
	months_left -= 1
	
	match months_left:
		2:
			pact.texture = old_pact
		1:
			pact.texture = expiring_pact
		0:
			emit_signal("accepted", false, pact_position)
			self.queue_free()


func accept():
	var formed_demon = summoning_circle.current_formed_demon
	if formed_demon != null:
		var accepted = part_stats.check_score(formed_demon.part_stats, 0)
		emit_signal("accepted", accepted, pact_position)
		formed_demon.queue_free()
		summoning_circle.current_formed_demon = null
		summoning_circle.has_formed_demon = false
		OpenedPact.finish(accepted)
		self.queue_free()


func _on_HighlightArea_mouse_entered():
	if GlobalValues.tutorial_step < 4:
		return
	
	mouse_inside = true
	highlight.visible = true


func _on_HighlightArea_mouse_exited():
	mouse_inside = false
	
	if not mouse_down:
		highlight.visible = false
