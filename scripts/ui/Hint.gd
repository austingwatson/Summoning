extends Node2D

onready var background = $CanvasLayer/Background
onready var page_1 = $CanvasLayer/Background/Page_1
onready var page_2 = $CanvasLayer/Background/Page_2
onready var next = $CanvasLayer/Next


func toggle():
	background.visible = not background.visible
	next.visible = not next.visible


func _on_Next_pressed():
	if page_1.visible:
		page_1.visible = false
		page_2.visible = true
	elif page_2.visible:
		page_1.visible = true
		page_2.visible = false
		toggle()
