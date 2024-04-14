class_name PartStats
extends Resource

const MIN: int = -1
const MAX: int = 6

export (String, "Head", "Organ", "Arm", "Leg") var type
export (int, -1, 6) var lethality = 0
export (int, -1, 6) var endurance = 0
export (int, -1, 6) var charm = 0
export (int, -1, 6) var speed = 0
export (AtlasTexture) var texture
export (PackedScene) var paper_doll_scene

export var known_properties = {
	"lethality": false,
	"endurance": false,
	"charm": false,
	"speed": false,
	}


func set_all(lethality, endurance, charm, speed):
	self.lethality = lethality
	self.endurance = endurance
	self.charm = charm
	self.speed = speed
	

func generate_random(zero_min, max_stats: int):
	var order = [0, 1, 2, 3]
	order.shuffle()
	for i in order:
		var stat = min(round(rand_range(MIN, MAX)), max_stats)
		if zero_min:
			stat = max(0, stat)
		max_stats -= stat
		match i:
			0:
				lethality = stat
			1:
				endurance = stat
			2:
				charm = stat
			3:
				speed = stat


func know_random_property():
	var list = known_properties.keys()
	list.shuffle()
	for key in list:
		if not known_properties[key]:
			known_properties[key] = true
			break
	print(known_properties)


# needed is how close to perfect the score needs to be
# 0 is perfect
# going up is less than perfect
# 24 is the least perfect
func check_score(part_stats, needed) -> bool:
	var lethality_score = min(0, max(0, part_stats.lethality) - self.lethality)
	var endurance_score = min(0, max(0, part_stats.endurance) - self.endurance)
	var charm_score = min(0, max(0, part_stats.charm) - self.charm)
	var speed_score = min(0, max(0, part_stats.speed) - self.speed)
	var total = abs(lethality_score + endurance_score + charm_score + speed_score)
	
	self.print_stats()
	part_stats.print_stats()
	
	return total <= needed
	

func print_stats():
	print("Lethality: ", lethality)
	print("Endurance: ", endurance)
	print("Charm: ", charm)
	print("Speed: ", speed)
