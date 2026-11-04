extends Action

class_name Teleport

@export var target: String

func do(_caster: Node, _casterSpell: spell = null, _args: Array = [], params: Dictionary[StringName, Variant] = {}):
	if !Globals.Root.currentInterior == "london":
		Globals.Root.changeWorld(_caster,"london",false,false)
	Globals.Root.changeWorld(_caster, target, true, false)
