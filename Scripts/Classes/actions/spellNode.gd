extends Action

class_name castNode

@export var spellNode: PackedScene
@export var casterPlayer: bool = false

func do(caster: Node, casterSpell: spell = null, args: Array = [], params: Dictionary[StringName, Variant] = {}):
	#print("casted node, caster is ", caster.name)
	var actualNode = spellNode.instantiate()
	Globals.Root.add_child(actualNode)
	
	if params.size() > 0:
		for i in params:
			actualNode.set(i, params[i])
	
	if casterPlayer:
		actualNode.global_rotation = Globals.Player.wizard.global_rotation
	else:
		actualNode.global_rotation = caster.global_rotation
	actualNode.global_position = caster.global_position
	actualNode.set_owner(Globals.Root)
	actualNode.initialize()
