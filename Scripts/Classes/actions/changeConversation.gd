extends Action

class_name changeConversation

@export var ownedBehaviour: Behaviour
@export var changeTo: conversation

func do(_caster: Node, _casterSpell: spell = null, _args: Array = [], params: Dictionary[StringName, Variant] = {}):
	ownedBehaviour.words = changeTo
	#dont use this it will try to go from null which is completely wrong.
