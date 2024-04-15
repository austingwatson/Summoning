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

onready var monthly_label = $CanvasLayer/Background/VBoxContainer/MonthlyReportLabel

var current_souls_amount = 0


func _ready():
	background.visible = false


func open(pacts_completed, pacts_failed, parts_eaten, _souls_gained, monthly = true):
	if GlobalValues.tutorial_step < GlobalValues.TutorialStep.FINISHED:
		return
	
	if monthly:
		monthly_label.text = "Monthly Report"
	else:
		monthly_label.text = "Lifetime Report"
	
	pacts_success_value.text = str(pacts_completed)
	pacts_fail_value.text = str(pacts_failed)
	parts_eaten_value.text = str(parts_eaten)
	background.visible = true
	
	for i in range(GlobalValues.current_souls.size()):
		var soul = souls.get_child(i)
		soul.set_soul_amount(GlobalValues.current_souls[i])
	
	if is_instance_valid(game_screen):
		SoundPlayer.play_monthly_report_sound()
	

func close():
	var amount_used = [0, 0, 0, 0]
	for i in souls.get_child_count():
		var soul = souls.get_child(i)
		amount_used[i] -= soul.removing_amount
		soul.accept()
	
	if current_souls_amount < GlobalValues.needed_souls:
		get_tree().change_scene("res://scenes/FailScreen.tscn")
	
	current_souls_amount = 0
	total_souls.text = str(current_souls_amount) + "/" + str(GlobalValues.needed_souls)
	
	GlobalValues.add_soul(amount_used)
	
	background.visible = false
	game_screen.update_hud()
	game_screen.start_month()


func _on_Commit_pressed():
	close()


func _on_Clear_pressed():
	for soul in souls.get_children():
		soul.clear()
	current_souls_amount = 0
	total_souls.text = str(current_souls_amount) + "/" + str(GlobalValues.needed_souls)
	soul_pic.texture = base_soul


func _on_give_soul():
	current_souls_amount += 1
	total_souls.text = str(current_souls_amount) + "/" + str(GlobalValues.needed_souls)
	
	if current_souls_amount >= GlobalValues.needed_souls:
		soul_pic.texture = filled_soul
	else:
		soul_pic.texture = base_soul
