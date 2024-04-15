extends Node2D

signal accepted(accepted, pact_position, soul_amount)

export (AtlasTexture) var new_pact
export (AtlasTexture) var old_pact
export (AtlasTexture) var expiring_pact

onready var animated_sprite = $AnimatedSprite
onready var highlight = $Highlight
onready var pact = $Pact

var remove = false
var part_stats = PartStats.new()
var summoning_circle: SummoningCircle
var months_left = 3
var mouse_inside = false
var mouse_down = false
var pact_position = 0

var lines_1 = []
var lines_2 = []
var lines_3 = []
var task_1_words = ["a trivial", "an easy", "a moderate", "a significant", "a difficult", "an impossible"]
var task_2_words = ["a little", "somewhat", "moderately", "very", "extremely", "impossibly"]
var lines = []
var stats = [0, 1, 2, 3]

var soul_worth = [1, 2, 0, 0]


func _ready():
	part_stats.generate_random(false, 1)
	pact.texture = new_pact
	
	animated_sprite.play("smoke")
	
	set_words()
	
	
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
	
func set_words():
	lines_1.append("I need a lethal servant for {task_1} task.")
	lines_1.append("I need a durable servant for {task_1} task.")
	lines_1.append("I need a charming servant for {task_1} task.")
	lines_1.append("I need a swift servant for {task_1} task.")
	
	lines_2.append("They must be {task_2} lethal.")
	lines_2.append("They must be {task_2} durable.")
	lines_2.append("They must be {task_2} charming.")
	lines_2.append("They must be {task_2} swift.")
	
	lines_3.append("They cannot be too lethal.")
	lines_3.append("They cannot be too durable.")
	lines_3.append("They cannot be too charming.")
	lines_3.append("They cannot be too swift.")
	
	format_sentence()	
	

func format_sentence():
	stats.shuffle()
	
	var index = 0
	for i in stats:
		match i:
			0:
				if part_stats.lethality > 0:
					if index == 0:
						lines.append(lines_1[0].replace("{task_1}", task_1_words[part_stats.lethality - 1]))
					else:
						lines.append(lines_2[0].replace("{task_2}", task_2_words[part_stats.lethality - 1]))
					index += 1
			1:
				if part_stats.endurance > 0:
					if index == 0:
						lines.append(lines_1[1].replace("{task_1}", task_1_words[part_stats.endurance - 1]))
					else:
						lines.append(lines_2[1].replace("{task_2}", task_2_words[part_stats.endurance - 1]))
					index += 1
			2:
				if part_stats.charm > 0:
					if index == 0:
						lines.append(lines_1[2].replace("{task_1}", task_1_words[part_stats.charm - 1]))
					else:
						lines.append(lines_2[2].replace("{task_2}", task_2_words[part_stats.charm - 1]))
					index += 1
			3:
				if part_stats.speed > 0:
					if index == 0:
						lines.append(lines_1[3].replace("{task_1}", task_1_words[part_stats.speed - 1]))
					else:
						lines.append(lines_2[3].replace("{task_2}", task_2_words[part_stats.speed - 1]))
					index += 1
	for i in stats:
		match i:
			0:
				if part_stats.lethality < 0:
					lines.append(lines_3[0])
			1:
				if part_stats.endurance < 0:
					lines.append(lines_3[1])
			2:
				if part_stats.charm < 0:
					lines.append(lines_3[2])
			3:
				if part_stats.speed < 0:
					lines.append(lines_3[3])
	#print(lines)


func next_month():
	months_left -= 1
	
	match months_left:
		2:
			pact.texture = old_pact
		1:
			pact.texture = expiring_pact
		0:
			emit_signal("accepted", false, pact_position, [])
			remove = true
			pact.visible = false
			highlight.visible = false
			animated_sprite.frame = 0
			animated_sprite.play("smoke")


func accept():
	var formed_demon = summoning_circle.current_formed_demon
	if formed_demon != null and (summoning_circle.animated_sprite.animation == "ready" or summoning_circle.animated_sprite.animation == "demon_on"):
		var accepted = part_stats.check_score(formed_demon.part_stats, 0)
		emit_signal("accepted", accepted, pact_position, soul_worth)
		formed_demon.queue_free()
		summoning_circle.current_formed_demon = null
		summoning_circle.has_formed_demon = false
		summoning_circle.summon()
		OpenedPact.finish(accepted)
		remove = true
		pact.visible = false
		highlight.visible = false
		animated_sprite.frame = 0
		animated_sprite.play("smoke")


func _on_HighlightArea_mouse_entered():
	if GlobalValues.tutorial_step < 4 or not pact.visible:
		return
	
	mouse_inside = true
	highlight.visible = true


func _on_HighlightArea_mouse_exited():
	mouse_inside = false
	
	if not mouse_down:
		highlight.visible = false


func _on_AnimatedSprite_animation_finished():
	if remove:
		self.queue_free()
	else:
		pact.visible = true
