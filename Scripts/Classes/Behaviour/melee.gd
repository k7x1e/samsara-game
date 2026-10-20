extends combatBehaviour

class_name meleeCombat

@export var target: Variant
@export var actor: Variant
@export var attackAction: Action
@export var nav: Variant
@export var behaviour: Behaviour

@export var parameters: Array[Variant]

var can_attack: bool = true

func initialize(args: Array[Variant]): ##0: target, 1: the actor, 2: the action associated with the item, 3: the navigationagent.
	parameters = args
	target = args[0]
	actor = args[1]
	attackAction = args[2]
	nav = args[3]
	behaviour = args[4]

func tick(_Caster: Node, _CasterBehaviour: Behaviour):
	var tempPosition = target.global_position
	nav.target_position = tempPosition
	var temptempPosition = nav.get_next_path_position()
	temptempPosition.y = actor.global_position.y
	if actor.visual.global_position != temptempPosition:
		actor.visual.look_at(temptempPosition, Vector3.UP)
	if can_attack:
		attack(_CasterBehaviour)

func attack(_Behaviour: Behaviour):
	print("attacking")
	#what?
	#the args are as follows: [damagearea,self,atdamage]
	attackAction.do(actor, null, [_Behaviour.damageArea, _Behaviour, -1])
	cooldown()

func cooldown():
	can_attack = false
	await Engine.get_main_loop().create_timer(1.0).timeout
	can_attack = true
