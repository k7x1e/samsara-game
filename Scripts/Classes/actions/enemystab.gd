extends Action

class_name enemy_stab

@export var damage: float = 10.0

func do(caster: Node, casterSpell: spell = null, args: Array = []):
	if args[2] != -1:
		damage = args[2]
	var bodies = args[0].get_overlapping_bodies()
	for body in bodies:
		#print("attacking player..")
		args[1].attacking.emit()
		body.damage(args[2])
		args[1].cooldown()
		return true
