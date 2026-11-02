extends Action

class_name tutorialEnd

func do(_caster: Node, _casterSpell: spell = null, _args: Array = [], params: Dictionary[StringName, Variant] = {}):
	print("out of tutorial")
	Globals.Root.changeWorld(self, "tutorial", false, true, true)
