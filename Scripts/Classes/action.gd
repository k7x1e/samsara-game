extends Resource

##THIS FUNCTION DOES JACK SHIT IT ONLY SERVES TO ALLOW CREATION OF ACTUAL ACTIONS

class_name Action

func do(caster: Node, casterSpell: equipmentSpell = null):
	Globals.Player.notify("No Action!")
