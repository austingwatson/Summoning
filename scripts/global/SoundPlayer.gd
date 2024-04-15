extends Node

var sound_db = 0

var demon_screams = []
var eating_sounds = []
var summons = []
var open_pacts = []

var lose: AudioStreamPlayer
var ignite_hand: AudioStreamPlayer
var drop_part: AudioStreamPlayer
var hook: AudioStreamPlayer
var monthly_report: AudioStreamPlayer

var main_music: AudioStreamPlayer
var game_music: AudioStreamPlayer


func _ready():
	sound_db = AudioServer.get_bus_index("Sound")
	
	demon_screams.append(load_sound("res://assets/sounds/demon1.wav"))
	demon_screams.append(load_sound("res://assets/sounds/demon2.wav"))
	demon_screams.append(load_sound("res://assets/sounds/demon3.wav"))
	demon_screams.append(load_sound("res://assets/sounds/demon4.wav"))
	demon_screams.append(load_sound("res://assets/sounds/demon6.wav"))
	demon_screams.append(load_sound("res://assets/sounds/demon7.wav"))
	demon_screams.append(load_sound("res://assets/sounds/demon8.wav"))
	demon_screams.append(load_sound("res://assets/sounds/demonshort1.wav"))
	demon_screams.append(load_sound("res://assets/sounds/demonshort2.wav"))
	demon_screams.append(load_sound("res://assets/sounds/demonshort3.wav"))
	
	eating_sounds.append(load_sound("res://assets/sounds/eating-sound-effect-36186.mp3"))
	eating_sounds.append(load_sound("res://assets/sounds/game-eat-sound-83240.mp3"))
	
	summons.append(load_sound("res://assets/sounds/epic-swoosh-boom-1-183996.mp3"))
	summons.append(load_sound("res://assets/sounds/fire-torch-whoosh-4-190300.mp3"))
	
	open_pacts.append(load_sound("res://assets/sounds/handle-paper-foley-1-172688.mp3"))
	open_pacts.append(load_sound("res://assets/sounds/paper-collect-8-186722.mp3"))
	
	lose = load_sound("res://assets/sounds/evil-demonic-laugh-6925.mp3")
	ignite_hand = load_sound("res://assets/sounds/fire-torch-whoosh-2-186586.mp3")
	drop_part = load_sound("res://assets/sounds/gooey-squish-14820.mp3")
	hook = load_sound("res://assets/sounds/squeakyclick2-91869.mp3")
	monthly_report = load_sound("res://assets/sounds/stoneblockdragwoodgrind-82327.mp3")
	
	main_music = load_sound("res://assets/sounds/hellsong_ambient.wav")


func load_sound(loc):
	var sound = AudioStreamPlayer.new()
	sound.stream = load(loc)
	sound.bus = "Sound"
	add_child(sound)
	return sound


func get_random_sound(array):
	return array[randi() % array.size()]


func play_demon_sound():
	get_random_sound(demon_screams).play()
	

func play_eating_sound():
	get_random_sound(eating_sounds).play()
	

func play_summon_sound():
	get_random_sound(summons).play()
	

func play_open_pact_sound():
	get_random_sound(open_pacts).play()
	

func play_lose_sound():
	lose.play()
	

func play_ignite_hand_sound():
	ignite_hand.play()
	

func play_drop_part_sound():
	drop_part.play()
	

func play_hook_sound():
	hook.play()
	

func play_monthly_report_sound():
	monthly_report.play()	
	

func stop_music():
	main_music.stop()
	

func play_main_music():
	if not main_music.playing:
		main_music.play()
