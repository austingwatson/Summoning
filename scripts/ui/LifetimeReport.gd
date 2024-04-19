extends Node

onready var background = $CanvasLayer/Background
onready var months_worked_value = $CanvasLayer/Background/VBoxContainer/MonthsWorked/Value
onready var pacts_success_value = $CanvasLayer/Background/VBoxContainer/PactsSuccess/Value
onready var pacts_fail_value = $CanvasLayer/Background/VBoxContainer/PactsFailed/Value
onready var parts_eaten_value = $CanvasLayer/Background/VBoxContainer/PartsEaten/Value


func open():
	if GlobalValues.tutorial_step < GlobalValues.TutorialStep.FINISHED:
		return
	
	months_worked_value.text = str(GlobalValues.total_months_worked)
	pacts_success_value.text = str(GlobalValues.total_pacts_completed)
	pacts_fail_value.text = str(GlobalValues.total_pacts_failed)
	parts_eaten_value.text = str(GlobalValues.total_parts_eaten)
	
	background.visible = true


func close():
	background.visible = false


func _on_Close_pressed():
	close()
