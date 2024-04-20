extends Node

var game_screen

export (AtlasTexture) var base_soul
export (AtlasTexture) var filled_soul

onready var background = $CanvasLayer/Background
onready var pacts_success_value = $CanvasLayer/Background/VBoxContainer/PactsSuccess/Value
onready var pacts_fail_value = $CanvasLayer/Background/VBoxContainer/PactsFailed/Value
onready var parts_eaten_value = $CanvasLayer/Background/VBoxContainer/PartsEaten/Value
onready var souls = $CanvasLayer/Background/VBoxContainer/Souls
onready var total_souls = $CanvasLayer/Background/VBoxContainer/Souls/TotalSouls/Label
onready var soul_pic = $CanvasLayer/Background/VBoxContainer/Souls/TotalSouls/TextureRect

onready var monthly_label = $CanvasLayer/Background/VBoxContainer/MonthlyReportLabel
onready var commit = $CanvasLayer/Background/VBoxContainer/Buttons/Commit

var current_souls_amount = 0


func _ready():
	background.visible = false
	

func _physics_process(_delta):
	if current_souls_amount < GlobalValues.needed_souls:
		commit.disabled = true
	else:
		commit.disabled = false


func open(pacts_completed, pacts_failed, parts_eaten, _souls_gained, _monthly = true):
	if GlobalValues.tutorial_step < GlobalValues.TutorialStep.FINISHED:
		return
		
	var total = 0
	for soul_amount in GlobalValues.current_souls:
		total += soul_amount
	if total < GlobalValues.needed_souls:
		background.visible = false
		get_tree().change_scene("res://scenes/FailScreen.tscn")
		return
	
	total_souls.text = str(current_souls_amount) + "/" + str(GlobalValues.needed_souls)
	
	pacts_success_value.text = str(pacts_completed)
	pacts_fail_value.text = str(pacts_failed)
	parts_eaten_value.text = str(parts_eaten)
	background.visible = true
	
	for i in souls.get_child_count():
		if i == 2:
			continue
		elif i > 2:
			var soul = souls.get_child(i)
			print(GlobalValues.current_souls[i - 1])
			soul.set_soul_amount(GlobalValues.current_souls[i - 1])
		else:
			var soul = souls.get_child(i)
			print(GlobalValues.current_souls[i])
			soul.set_soul_amount(GlobalValues.current_souls[i])
		
	
	if is_instance_valid(game_screen):
		SoundPlayer.play_monthly_report_sound()
	

func close():
	var amount_used = [0, 0, 0, 0]
	for i in souls.get_child_count():
		if i == 2:
			continue
		elif i > 2:
			var soul = souls.get_child(i)
			amount_used[i - 1] -= soul.removing_amount
			soul.accept()
		else:
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
	for i in souls.get_child_count():
		if i == 2:
			continue
		else:
			souls.get_child(i).clear()
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
