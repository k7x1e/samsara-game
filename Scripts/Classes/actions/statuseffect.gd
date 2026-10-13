extends Action

class_name statusEffectAction

@export_enum("caster", "specified", "stats") var effectTarget: int = 0
@export_enum("buff","effect") var mode: int = 0 ##buff means it justs up whatever parameter is applicable, effect means it lasts.

@export var statusEffect: statuseffect

@export var parameter: StringName = "health"

@export_enum("*","+","/","=") var operand: int = 1

@export var amount: Variant = 50.0
@export var duration: float = 5.0

@export var message: String = " "

var targetIsStat: bool = false

func setparameter(targetT, targetP, value, isStat: bool = false):
	if !isStat:
		targetT.set(targetP, value)
	if isStat:
		Globals.stats.setstat(Globals.stats.getStatIntFromString(targetP), value)

func do(caster: Node, casterSpell: spell = null, args: Array = []):
	if effectTarget == 2:
		targetIsStat = true
	
	var affected
	var targettemp
	
	match effectTarget:
		0:
			targettemp = caster
		1:
			targettemp = args[0]
		2:
			targettemp = Globals.stats
	
	affected = targettemp.get(parameter)
	var backupAffected = affected
	
	match operand:
		0:
			affected *= amount
		1:
			affected += amount
		2:
			affected /= amount
		3:
			affected = amount
	
	setparameter(targettemp, parameter, affected, targetIsStat)
	
	if message != " ":
		Globals.Player.notify(message)
	
	if mode == 1:
		statusEffect.duration = duration
		Globals.Player.statuseffects.append(statusEffect)
		statusEffect.active = true
		statusEffect.initialize()
		await statusEffect.durationOver
		statusEffect.active = false
		setparameter(targettemp, parameter, backupAffected, targetIsStat)
