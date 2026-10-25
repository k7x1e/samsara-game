extends combatBehaviour

class_name ranged

##THIS IS ALL JUST COPIED FROM THE RANGEDENEMY. WILL NEED CLEANING EVENTUALLY

@export var target: Variant
@export var actor: Variant
@export var attackAction: Action
@export var nav: Variant
@export var behaviour: Behaviour

@export var parameters: Array[Variant]

var can_attack: bool = true
var can_move: bool = true

@export var threshold: int = 5 ##ticks before they recalculate target
var threshcounter: int
@export var offset: Vector3 = Vector3(0,0,0)

@export var range: float = 10.0

func initialize(args: Array[Variant]):
	parameters = args
	target = args[0]
	actor = args[1]
	attackAction = args[2]
	nav = args[3]
	behaviour = args[4]

func tick(_Caster: Node, _CasterBehaviour: Behaviour):
	if actor != null:
		var tempPosition = target.global_position
		if actor.visual.global_position != tempPosition:
			actor.visual.look_at(tempPosition, Vector3.UP)
		if can_move:
			#print("moving")
			nav.target_position = tempPosition + offset
			var temptempPosition = nav.get_next_path_position()
			temptempPosition.y = actor.global_position.y
			actor.move()
		if checkAttack() and can_attack:
			attack()
		if checkSight():
			#print("whats going onz")
			threshcounter = 0
		else:
			threshcounter += 1
			if threshcounter == threshold:
				#print("recalculating offset")
				var stink = calculateOffset()
				offset = Vector3(stink.x,0,stink.y)

func checkAttack() -> bool:
	var bodies = behaviour.damageArea.get_overlapping_bodies()
	for body in bodies:
		return checkSight()
	return false

func calculateOffset() -> Vector2:
	var selfpos = actor.global_position
	var targetpos = target.global_position
	var temp = (selfpos - targetpos)
	var tempTrue: Vector2 = Vector2(temp.x,temp.z).normalized()
	return tempTrue.rotated(90) * range

func checkSight() -> bool:
	var space_state = actor.get_world_3d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters3D.create(actor.global_position, target.global_position)
	query.set_collision_mask(30)
	var result = space_state.intersect_ray(query)
	if result.collider.name == "Player" or result.collider.name == "Actor":
		return true
	return false

func attack():
	#print("attacking")
	#replace with projectile
	var bodies = behaviour.damageArea.get_overlapping_bodies()
	for body in bodies:
		can_attack = false
		await movementcooldown()
		#print("attacking target..")
		actor.behaviour.attacking.emit()
		
		attackAction.do(actor.visual, null)
		
		#var poop = projectile.instantiate()
		#actor.add_child(poop)
		#poop.set_owner(actor)
		#poop.global_position = actor.global_position
		#poop.global_rotation = actor.visual.global_rotation
		#poop.initialize()
		cooldown()
		movementcooldown()
		return true

func cooldown():
	can_attack = false
	await Engine.get_main_loop().create_timer(1.0).timeout
	can_attack = true
func movementcooldown():
	can_move = false
	await Engine.get_main_loop().create_timer(0.3).timeout
	can_move = true
