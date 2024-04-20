extends CanvasLayer

const TEXT_SPEED = 25

onready var text = $TextureRect/Text

var lines = []
var parts = []
var current_line = 0
var can_skip = true
var stop_skip = [2, 3, 5, 6, 7, 9, 10]
var visible_characters = 0


func _ready():
	lines.append("New spawn! You will serve me.")
	lines.append("A summoner has made a pact. Their soul is ours if we fulfill their demand.")
	lines.append("Move demonflesh onto the slab to create a suitable servant.")
	lines.append("Hit the stone button on the altar when you are ready to create the demon.")
	lines.append("Move our demon to the circle when ready.")
	lines.append("Now ready the sending circle by lighting the unholy candles.")
	lines.append("Read the pact by selecting the page.")
	lines.append("Send the summoner our servant by touching the seal on their pact.")
	lines.append("Bargain fulfilled. Their sinful soul is yours.")
	lines.append("Not all demonflesh is equal. Learn the traits of each part by eating a sample.")
	lines.append("If you wish to save a servant for later, hang them on the hook. Make a spare now.")
	lines.append("Each sin grants demons specific abilities.")
	lines.append("Wrath breeds lethality, Envy – endurance, Greed – speed, and Pride – charm.")
	lines.append("I require a soul quota each month. Fail and I will have you fired.")
	lines.append("When you think you've reached your quota, get ready for work next month.")
	lines.append("I’ve got my eye on you.")


func _physics_process(delta):
	visible_characters += TEXT_SPEED * delta
	text.visible_characters = visible_characters
	

func _unhandled_input(event):
	if can_skip and text.percent_visible >= 1 and event.is_action_released("click"):
		next_line(current_line + 1)
		
		if current_line in stop_skip:
			can_skip = false


func next_line(line):
	if line >= lines.size():
		return
	
	current_line = line
	text.text = lines[current_line]
	text.percent_visible = 0
	visible_characters = 0
