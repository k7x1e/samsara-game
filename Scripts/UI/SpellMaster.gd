extends HBoxContainer

@onready var spell1 = $Spell1
@onready var spell2 = $Spell2
@onready var spell3 = $Spell3
@onready var spell4 = $Spell4
@onready var spell5 = $Spell5

var spells = [spell1,spell2,spell3,spell4,spell5]

func updateSpells(spellList: Array[spell]):
	for i in range(spellList.size()):
		updateSpell(spells[i], spellList[i])

func updateSpell(spellNode: Node, spel: spell):
	pass
