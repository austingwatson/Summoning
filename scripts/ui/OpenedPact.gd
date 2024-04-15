extends CanvasLayer

export (AtlasTexture) var frame1
export (AtlasTexture) var frame2
export (AtlasTexture) var frame3
export (AtlasTexture) var failed
export (AtlasTexture) var success1
export (AtlasTexture) var success2
export (AtlasTexture) var success3
export (AtlasTexture) var success4
export (AtlasTexture) var success5
export (AtlasTexture) var success6
export (AtlasTexture) var success7

onready var animation_player = $AnimationPlayer
onready var background = $Background
onready var label = $Background/Label

var pact = null
var frames = []


func _ready():
	frames.append(frame1)
	frames.append(frame2)
	frames.append(frame3)
	frames.append(failed)
	frames.append(success1)
	frames.append(success2)
	frames.append(success3)
	frames.append(success4)
	frames.append(success5)
	frames.append(success6)
	frames.append(success7)


func open(pact):
	visible = true
	animation_player.play("open_pact")
	if is_instance_valid(self.pact) and self.pact != null:
		self.pact.highlight.visible = false
		self.pact.mouse_inside = false
		self.pact.mouse_down = false
	self.pact = pact
	label.text = ""
	for line in self.pact.lines:
		label.text += line
		label.text += "\n"
	

func close():
	visible = false
	pact = null
	

func finish(accepted):
	if accepted:
		animation_player.play("pact_success")
	else:
		animation_player.play("pact_failed")


func set_background(frame):
	background.texture = frames[frame]


func _on_AcceptPact_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_action_released("click"):
		if GlobalValues.tutorial_step == GlobalValues.TutorialStep.ACCEPT_PACT:
			GlobalValues.next_tutorial_step()
		
		pact.accept()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "pact_failed" or anim_name == "pact_success":
		close()
