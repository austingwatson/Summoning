extends Node

var music_started = false

onready var sound_slider = $Backround/VBoxContainer/Volume

func _ready():
	randomize()
	
	sound_slider.value = AudioServer.get_bus_volume_db(SoundPlayer.sound_db)
	

func _input(event):
	if not music_started:
		if event is InputEventKey or event is InputEventMouseButton:
			music_started = true
			SoundPlayer.play_main_music()


func _on_Play_pressed():
	#get_tree().change_scene("res://scenes/TestScene.tscn")
	SoundPlayer.stop_music()
	get_tree().change_scene("res://scenes/GameScreen.tscn")


func _on_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(SoundPlayer.sound_db, value)
	if value == -60:
		AudioServer.set_bus_mute(SoundPlayer.sound_db, true)
	else:
		AudioServer.set_bus_mute(SoundPlayer.sound_db, false)
