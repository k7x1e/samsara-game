extends Resource

class_name Stats

@export var agility: float
@export var magic: float
@export var perception: float
@export var intelligence: float
@export var strength: float

@export var stats: Array[Variant] = [agility, magic, perception, intelligence, strength]
#just put stats and their function

func initialize():
	stats = [agility, magic, perception, intelligence, strength]

func retrieve(stat: int): #0: agility, 1: magic, 2: perception, 3: intelligence, 4: strength
	return stats[stat]

func setstat(stat: int, amt: float):
	print(stats[stat])
	stats[stat] = amt
	print(stats[stat])
	Globals.Player.refreshStats()
