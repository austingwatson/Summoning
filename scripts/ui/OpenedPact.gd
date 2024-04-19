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
var hovering = false


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
	

func _input(event):
	if not hovering and event.is_action_pressed("click"):
		close()


func open(pact):
	label.visible = true
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
	SoundPlayer.play_open_pact_sound()
	

func close():
	visible = false
	if is_instance_valid(pact) and pact != null:
		pact.highlight.visible = false
		pact.mouse_inside = false
		pact.mouse_down = false
	pact = null
	

func finish(accepted):
	if accepted:
		animation_player.play("pact_success")
	else:
		animation_player.play("pact_failed")


func set_background(frame):
	background.texture = frames[frame]
	
	if frame == 6:
		label.visible = false


func _on_AcceptPact_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_action_released("click"):
		pact.accept()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "pact_failed" or anim_name == "pact_success":
		close()


func _on_CloseArea_mouse_entered():
	hovering = true


func _on_CloseArea_mouse_exited():
	hovering = false
