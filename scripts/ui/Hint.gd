extends Node2D

onready var background = $CanvasLayer/Background
onready var page_1 = $CanvasLayer/Background/Page_1
onready var page_2 = $CanvasLayer/Background/Page_2
onready var page_3 = $CanvasLayer/Background/Page_3
onready var next = $CanvasLayer/Next
onready var next_label = $CanvasLayer/Next/Label

var mouse_inside = false


func toggle():
	background.visible = not background.visible
	next.visible = not next.visible
	

func _input(event):
	if not mouse_inside and event.is_action_pressed("click"):
		background.visible = false
		next.visible = false


func _on_Next_pressed():
	if page_1.visible:
		page_1.visible = false
		page_2.visible = true
	elif page_2.visible:
		page_2.visible = false
		page_3.visible = true
		next_label.text = "Close"
	elif page_3.visible:
		page_1.visible = true
		page_3.visible = false
		next_label.text = "Next"
		toggle()


func _on_mouse_entered():
	mouse_inside = true


func _on_mouse_exited():
	mouse_inside = false
