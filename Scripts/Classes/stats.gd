extends Resource

class_name Stats

@export var agility: float
@export var agilityprogress: int

@export var magic: float
@export var magicprogress: int

@export var perception: float
@export var perceptionprogress: int

@export var intelligence: float
@export var intelligenceprogress: int

@export var strength: float
@export var strengthprogress: int

@export var stats: Array[Variant] = [agility, magic, perception, intelligence, strength]
@export var progressStats: Array[Variant] = [agilityprogress, magicprogress, perceptionprogress, intelligenceprogress, strengthprogress]
@export var statDescriptions: Array[String] = ["This stat determines how fast you are, in other words how agile you are.", "How proficient you are within the magic arts. Decreases spell cooldown, cost and increases effect.", 
"Perception. How good you are at spotting things and how good you are with guns.", "How smart you are, Affects speech and mana.", "Your physical strength. Makes you able to lift more and melee harder."]
@export var statNames: Array[String] = ["Agility", "Magic", "Perception", "Intelligence", "Strength"]

@export var progressMax: int = 50

#just put stats and their function
@export var statDict: Dictionary[String, Variant] = {
	"Agility": agility,
	"Magic": magic,
	"Perception": perception,
	"Intelligence": intelligence,
	"Strength": strength
}

func initialize():
	stats = [agility, magic, perception, intelligence, strength]

func retrieve(stat: int): #0: agility, 1: magic, 2: perception, 3: intelligence, 4: strength
	return stats[stat]

func setstat(stat: int, amt: float):
	print(stats[stat])
	stats[stat] = amt
	print(stats[stat])
	Globals.Player.refreshStats()

func experience(stat:int):
	progressStats[stat] += 1
	checkLevels()

func checkLevels():
	var b = 0
	for i in progressStats:
		if i >= progressMax:
			progressStats[b] = 0
			print("leveled up stat: ", b)
			setstat(b, stats[b]+1)
			Globals.spellMaster.updateSpells(Globals.spellMaster.spellArray)
			Globals.Player.notify(str("Leveled up ", statNames[b], "."), "Level1")
		b += 1
