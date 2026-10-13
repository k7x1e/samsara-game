extends Action

class_name giveItem

@export var items: Array[itemClass]

func do(_caster: Node, _casterSpell: spell = null, _args: Array = []):
	for poop in items:
		print("gave player a ", poop.name)
		Globals.Player.inventory.add(poop)
