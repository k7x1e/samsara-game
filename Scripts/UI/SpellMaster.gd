extends HBoxContainer

@onready var spell1 = $Spell1
@onready var spell2 = $Spell2
@onready var spell3 = $Spell3
@onready var spell4 = $Spell4
@onready var spell5 = $Spell5

@onready var spells: Array[Node] = [$Spell1,$Spell2,$Spell3,$Spell4,$Spell5]
var spellArray: Array[spell] = []

func _ready() -> void:
	Globals.spellMaster = self

func updateSpells(spellList: Array[spell]):
	spellArray = spellList
	for i in range(spellList.size()):
		updateSpell(spells[i], spellList[i])

func updateSpell(spellNode: Node, spel: spell):
	print("updated spell")
	spellNode.spel = spel
	spellNode.iconNode.texture = spel.Icon
	spellNode.dim.max_value = spel.coolDown
	spellNode.timer_active = spel.cooldown_active
	match spel.cooldown_active:
		true:
			print("showing dim")
			spellNode.dim.show()
		false:
			print("hiding dim")
			spellNode.dim.hide()
	spel.uiNode = spellNode
	spellNode.costLabel.text = str(spel.cost)
