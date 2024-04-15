extends VBoxContainer

signal give_soul

enum SoulType {
	PRIDE,
	WRATH,
	ENVY,
	GREED,
}

export (AtlasTexture) var base
export (AtlasTexture) var hovered_1
export (AtlasTexture) var hovered_2
export (AtlasTexture) var wrath
export (AtlasTexture) var envy
export (AtlasTexture) var greed
export (AtlasTexture) var pride
export (int, "PRIDE", "WRATH", "ENVY", "GREED") var soul_type = SoulType.PRIDE

onready var animation_player = $AnimationPlayer
onready var current = $Current
onready var background = $Background
onready var icon = $Background/Icon
onready var removing = $Removing

var soul_amount = 0
var removing_amount = 0


func _ready():
	match soul_type:
		SoulType.PRIDE:
			icon.texture = pride
		SoulType.WRATH:
			icon.texture = wrath
		SoulType.ENVY:
			icon.texture = envy
		SoulType.GREED:
			icon.texture = greed
			

func add_soul_amount(amount):
	soul_amount += amount
	current.text = str(soul_amount)
	

func set_soul_amount(amount):
	soul_amount = amount
	current.text = str(soul_amount)


func set_frame(frame):
	if frame == 0:
		background.texture = hovered_1
	elif frame == 1:
		background.texture = hovered_2
		

func clear():
	soul_amount += removing_amount
	removing_amount = 0
	current.text = str(soul_amount)
	removing.text = str(0)


func accept():
	removing_amount = 0
	removing.text = str(0)


func _on_Background_gui_input(event):
	if event is InputEventMouseButton and event.is_action_pressed("click"):
		soul_amount -= 1
		if soul_amount < 0:
			soul_amount = 0
		else:
			emit_signal("give_soul")
			current.text = str(soul_amount)
			removing_amount += 1
			removing.text = str(-removing_amount)


func _on_Background_mouse_entered():
	animation_player.play("hovered")


func _on_Background_mouse_exited():
	animation_player.stop()
	background.texture = base
