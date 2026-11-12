extends Action

class_name menacingText

@export var what: String = "placeholder"
@export var useSound: bool = true
@export var dontRetract: bool = false

func do(_caster: Node, _casterSpell: spell = null, _args: Array = [], params: Dictionary[StringName, Variant] = {}):
	Globals.Root.notify(what,useSound,dontRetract)
