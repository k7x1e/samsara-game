extends Action

class_name sendCourier

func do(_caster: Node, _casterSpell: spell = null, _args: Array = [], params: Dictionary[StringName, Variant] = {}):
	Globals.Root.sendCourier(params["message"],params["isConvo"])
