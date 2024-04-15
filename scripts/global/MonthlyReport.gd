extends Node

var game_screen

export (AtlasTexture) var base_soul
export (AtlasTexture) var filled_soul

onready var background = $CanvasLayer/Background
onready var pacts_success_value = $CanvasLayer/Background/VBoxContainer/PactsSuccess/Value
onready var pacts_fail_value = $CanvasLayer/Background/VBoxContainer/PactsFailed/Value
onready var parts_eaten_value = $CanvasLayer/Background/VBoxContainer/PartsEaten/Value
onready var souls = $CanvasLayer/Background/VBoxContainer/Souls
onready var total_souls = $CanvasLayer/Background/VBoxContainer/Buttons/TotalSouls/Label
onready var soul_pic = $CanvasLayer/Background/VBoxContainer/Buttons/TotalSouls/TextureRect

var needed_souls = 2
var current_souls_amount = 0


func _ready():
	background.visible = false


func open(pacts_completed, pacts_failed, parts_eaten, souls_gained):
	if GlobalValues.tutorial_step < GlobalValues.TutorialStep.FINISHED:
		return
	
	pacts_success_value.text = str(pacts_completed)
	pacts_fail_value.text = str(pacts_failed)
	parts_eaten_value.text = str(parts_eaten)
	background.visible = true
	
	for i in range(souls_gained.size()):
		var soul = souls.get_child(i)
		soul.add_soul_amount(souls_gained[i])
	

func close():
	for soul in souls.get_children():
		soul.accept()
	
	if current_souls_amount < needed_souls:
		get_tree().change_scene("res://scenes/TitleScreen.tscn")
	
	current_souls_amount = 0
	total_souls.text = str(current_souls_amount) + "/" + str(needed_souls)
	
	background.visible = false
	game_screen.start_month()


func _on_Commit_pressed():
	close()


func _on_Clear_pressed():
	for soul in souls.get_children():
		soul.clear()
	current_souls_amount = 0
	total_souls.text = str(current_souls_amount) + "/" + str(needed_souls)
	soul_pic.texture = base_soul


func _on_give_soul():
	current_souls_amount += 1
	total_souls.text = str(current_souls_amount) + "/" + str(needed_souls)
	
	if current_souls_amount >= needed_souls:
		soul_pic.texture = filled_soul
	else:
		soul_pic.texture = base_soul
