class_name PartStats
extends Resource

const MIN: int = -3
const MAX: int = 6

export (String, "Head", "Organ", "Arm", "Leg") var type
export (int, -3, 6) var lethality = 0
export (int, -3, 6) var endurance = 0
export (int, -3, 6) var charm = 0
export (int, -3, 6) var speed = 0
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
	var amount = 0
	for i in order:
		var stat = min(round(rand_range(MIN, MAX)), max_stats)
		if zero_min:
			stat = max(0, stat)
		if amount == 0 and stat < 0:	
			continue
		elif amount == 2 and stat > 0:
			break
		max_stats -= abs(stat)
		amount += 1
		match i:
			0:
				lethality = stat
			1:
				endurance = stat
			2:
				charm = stat
			3:
				speed = stat
		if stat < 0:
			break
				
func get_stats(array: Array):
	var result = []
	
	for i in array:
		match i:
			0:
				result.append(lethality)
			1:
				result.append(endurance)
			2:
				result.append(charm)
			3:
				result.append(speed)
	
	return result
				

func know_all_properties():
	for key in known_properties.keys():
		known_properties[key] = true


func know_random_property():
	var list = known_properties.keys()
	list.shuffle()
	for key in list:
		if not known_properties[key]:
			known_properties[key] = true
			break


# needed is how close to perfect the score needs to be
# 0 is perfect
# going up is less than perfect
# 24 is the least perfect
func check_score(part_stats, needed) -> bool:
	var lethality_score = part_stats.lethality - self.lethality
	var endurance_score = part_stats.endurance - self.endurance
	var charm_score = part_stats.charm - self.charm
	var speed_score = part_stats.speed - self.speed
	
	if part_stats.lethality >= self.lethality:
		lethality_score = 0
	if part_stats.endurance >= self.endurance:
		endurance_score = 0
	if part_stats.charm >= self.charm:
		charm_score = 0
	if part_stats.speed >= self.speed:
		speed_score = 0
	
	if self.lethality < 0:
		lethality_score = 0			
	if self.endurance < 0:
		endurance_score = 0
	if self.charm < 0:
		charm_score = 0
	if self.speed < 0:
		speed_score = 0
	
	var total = abs(lethality_score + endurance_score + charm_score + speed_score)
	
	if self.lethality < 0 and part_stats.lethality - abs(self.lethality) >= 3:
		total += 10000
	if self.endurance < 0 and part_stats.endurance - abs(self.endurance) >= 3:
		total += 10000
	if self.charm < 0 and part_stats.charm - abs(self.charm) >= 3:
		total += 10000
	if self.speed < 0 and part_stats.speed - abs(self.speed) >= 3:
		total += 10000
	
	#self.print_stats()
	#part_stats.print_stats()
	#print(total)
	#print(needed)
	
	return total <= needed
	

func print_stats():
	print("Lethality: ", lethality)
	print("Endurance: ", endurance)
	print("Charm: ", charm)
	print("Speed: ", speed)
