extends Node2D

export (AtlasTexture) var unknown
export (AtlasTexture) var lethality
export (AtlasTexture) var endurance
export (AtlasTexture) var charm
export (AtlasTexture) var speed
export (AtlasTexture) var tick
export (AtlasTexture) var neg_tick

onready var part_icons = $Background/HBoxContainer/PartIcons
onready var part_type_label = $Background/PartTypeLabel

var stats = []


func _ready():
	var stat1 = []
	var stat1_grid = $Background/HBoxContainer/Stats/Stat1.get_children()
	stat1.append(stat1_grid[0])
	stat1.append(stat1_grid[3])
	stat1.append(stat1_grid[1])
	stat1.append(stat1_grid[4])
	stat1.append(stat1_grid[2])
	stat1.append(stat1_grid[5])
	stats.append(stat1)
	
	var stat2 = []
	var stat2_grid = $Background/HBoxContainer/Stats/Stat2.get_children()
	stat2.append(stat2_grid[0])
	stat2.append(stat2_grid[3])
	stat2.append(stat2_grid[1])
	stat2.append(stat2_grid[4])
	stat2.append(stat2_grid[2])
	stat2.append(stat2_grid[5])
	stats.append(stat2)
	
	var stat3 = []
	var stat3_grid = $Background/HBoxContainer/Stats/Stat3.get_children()
	stat3.append(stat3_grid[0])
	stat3.append(stat3_grid[3])
	stat3.append(stat3_grid[1])
	stat3.append(stat3_grid[4])
	stat3.append(stat3_grid[2])
	stat3.append(stat3_grid[5])
	stats.append(stat3)


func reset():
	for part_icon in part_icons.get_children():
		part_icon.texture = null


func set_info(part_stats: PartStats):
	part_type_label.text = part_stats.type
	
	var current_icon = 0
	var known_properties = part_stats.known_properties
	if part_stats.lethality != 0:
		var icon = part_icons.get_child(current_icon)
		if known_properties["lethality"]:
			icon.texture = lethality
			for i in range(part_stats.lethality):
				stats[current_icon][i].texture = tick
			for i in range(0, part_stats.lethality, -1):
				stats[current_icon][abs(i)].texture = neg_tick
		else:
			icon.texture = unknown
		current_icon += 1
	if part_stats.endurance != 0:
		var icon = part_icons.get_child(current_icon)
		if known_properties["endurance"]:
			icon.texture = endurance
			for i in range(part_stats.endurance):
				stats[current_icon][i].texture = tick
			for i in range(0, part_stats.endurance, -1):
				stats[current_icon][abs(i)].texture = neg_tick
		else:
			icon.texture = unknown
		current_icon += 1
	if part_stats.charm != 0:
		var icon = part_icons.get_child(current_icon)
		if known_properties["charm"]:
			icon.texture = charm
			for i in range(part_stats.charm):
				stats[current_icon][i].texture = tick
			for i in range(0, part_stats.charm, -1):
				stats[current_icon][abs(i)].texture = neg_tick
		else:
			icon.texture = unknown
		current_icon += 1
	if part_stats.speed != 0:
		var icon = part_icons.get_child(current_icon)
		if known_properties["speed"]:
			icon.texture = speed
			for i in range(part_stats.speed):
				stats[current_icon][i].texture = tick
			for i in range(0, part_stats.speed, -1):
				stats[current_icon][abs(i)].texture = neg_tick
		else:
			icon.texture = unknown
		current_icon += 1
