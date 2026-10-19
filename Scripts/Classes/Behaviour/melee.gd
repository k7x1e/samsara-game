extends combatBehaviour

class_name meleeCombat

@export var target: Variant
@export var actor: Variant
@export var attackAction: Action
@export var nav: Variant

@export var parameters: Array[Variant]

func initialize(args: Array[Variant]): ##0: target, 1: the actor, 2: the action associated with the item, 3: the navigationagent.
	parameters = args
	target = args[0]
	actor = args[1]
	attackAction = args[2]
	nav = args[3]

func tick(_Caster: Node, _CasterBehaviour: Behaviour):
	var tempPosition = target.global_position
	nav.target_position = tempPosition
	var temptempPosition = nav.get_next_path_position()
	temptempPosition.y = actor.global_position.y
	if actor.visual.global_position != temptempPosition:
		actor.visual.look_at(temptempPosition, Vector3.UP)
	#if parameters[4]:
	#	attack(_CasterBehaviour)

func attack(_Behaviour: Behaviour):
	#what?
	#the args are as follows: [damagearea,self,atdamage]
	attackAction.do(actor, null, [parameters[5], _Behaviour, parameters[6]])
