extends Behaviour

class_name baseEnemy

@export var damageArea: Variant
@export var player: Variant
@export var nav: Variant

@export var atdamage: float = 10.0

var can_attack: bool = true

func initialize():
	player = Globals.Player
	
	nav = actor.nav
	damageArea = actor.get_node("Area3D")

func update():
	if player:
		var tempPosition = player.global_position
		nav.target_position = tempPosition
		var temptempPosition = nav.get_next_path_position()
		temptempPosition.y = actor.global_position.y
		if actor.visual.global_position != temptempPosition:
			actor.visual.look_at(temptempPosition, Vector3.UP)
	else:
		player = Globals.Player
	#tempPosition.y = actor.global_position.y
	#actor.move()
	if can_attack:
		attack()

func attack():
	var bodies = damageArea.get_overlapping_bodies()
	for body in bodies:
		print("attacking player..")
		body.damage(atdamage)
		cooldown()
		return true

func cooldown():
	can_attack = false
	await Engine.get_main_loop().create_timer(1.0).timeout
	can_attack = true
