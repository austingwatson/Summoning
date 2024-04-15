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
		elif abs(stat) > max_stats:
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
	var lethality_score = 0
	var endurance_score = 0
	var charm_score = 0
	var speed_score = 0
	
	if self.lethality > 0:
		lethality_score = max(0, self.lethality - part_stats.lethality)
	elif self.lethality < 0:
		lethality_score = part_stats.lethality - abs(self.lethality)
		if lethality_score >= 3:
			lethality_score = 1000
		else:
			lethality_score = 0
	if self.endurance > 0:
		endurance_score = max(0, self.endurance - part_stats.endurance)
	elif self.endurance < 0:
		endurance_score = part_stats.endurance - abs(self.endurance)
		if endurance_score >= 3:
			endurance_score = 1000
		else:
			endurance_score = 0
	if self.charm > 0:
		charm_score = max(0, self.charm - part_stats.charm)
	elif self.charm < 0:
		charm_score = part_stats.charm - abs(self.charm)
		if charm_score >= 3:
			charm_score = 1000
		else:
			charm_score = 0
	if self.speed > 0:
		speed_score = max(0, self.speed - part_stats.speed)
	elif self.speed < 0:
		speed_score = part_stats.speed - abs(self.speed)
		if speed_score >= 3:
			speed_score = 1000
		else:
			speed_score = 0
	
	var total = lethality_score + endurance_score + charm_score + speed_score
	
	#self.print_stats()
	#part_stats.print_stats()
	#print([lethality_score, endurance_score, charm_score, speed_score])
	#print(total)
	#print(needed)
	
	return total <= needed
	

func print_stats():
	print("Lethality: ", lethality)
	print("Endurance: ", endurance)
	print("Charm: ", charm)
	print("Speed: ", speed)
