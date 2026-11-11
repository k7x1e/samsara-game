extends Action

class_name sendCourier

@export var message: Variant
@export var isConvo: bool = false

func do(_caster: Node, _casterSpell: spell = null, _args: Array = [], params: Dictionary[StringName, Variant] = {}):
	Globals.Root.sendCourier(message,isConvo)
