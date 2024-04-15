extends Node


func _ready():
	SoundPlayer.play_lose_sound()
	MonthlyReport.open(GlobalValues.total_pacts_completed, GlobalValues.total_pacts_failed, GlobalValues.total_parts_eaten, null, false)
