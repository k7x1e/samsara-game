extends combatBehaviour

class_name whatever

@export var target: Variant
@export var actor: Variant
@export var attackAction: Action
@export var nav: Variant

@export var parameters: Array[Variant]

func initialize(args: Array[Variant]):
	parameters = args
	target = args[0]
	actor = args[1]
	attackAction = args[2]
	nav = args[3]

func tick(_Caster: Node, _CasterBehaviour: Behaviour):
	pass
