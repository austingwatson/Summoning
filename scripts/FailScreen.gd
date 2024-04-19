extends Node

onready var life_time_report = $LifetimeReport

var lr_open = false


func _ready():
	SoundPlayer.play_lose_sound()
	#MonthlyReport.open(GlobalValues.total_pacts_completed, GlobalValues.total_pacts_failed, GlobalValues.total_parts_eaten, null, false)


func _on_ToggleLR_pressed():
	lr_open = not lr_open
	
	if lr_open:
		life_time_report.open()
	else:
		life_time_report.close()


func _on_PlayAgain_pressed():
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
