class_name PartStat
extends Resource

const MIN: int = 0
const MAX: int = 4

export (int, 0, 4) var strength = 0
export (int, 0, 4) var speed = 0
export (int, 0, 4) var endurance = 0
export (int, 0, 4) var intelligence = 0

func generate_random(max_stats: int):
	var order = [0, 1, 2, 3]
	order.shuffle()
	for i in order:
		var stat = min(round(rand_range(MIN, MAX)), max_stats)
		max_stats -= stat
		match i:
			0:
				strength = stat
			1:
				speed = stat
			2:
				endurance = stat
			3:
				intelligence = stat


func check_score(part_stats: PartStat) -> int:
	var strength_score = min(0, part_stats.strength - self.strength)
	var speed_score = min(0, part_stats.speed - self.speed)
	var endurance_score = min(0, part_stats.endurance - self.endurance)
	var intelligence_score = min(0, part_stats.intelligence - self.intelligence)
	
	#print("Strength: ", self.strength, ", ", part_stats.strength, ", ", strength_score)
	#print("Speed: ", self.speed, ", ", part_stats.speed, ", ", speed_score)
	#print("Endurance: ", self.endurance, ", ", part_stats.endurance, ", ", endurance_score)
	#print("Intelligence: ", self.intelligence, ", ", part_stats.intelligence, ", ", intelligence_score)
	#print(strength_score + speed_score + endurance_score + intelligence_score)
	
	return strength_score + speed_score + endurance_score + intelligence_score
