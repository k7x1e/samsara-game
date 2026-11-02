extends combatBehaviour

class_name unarmed

@export var target: Variant
@export var actor: Variant
@export var attackAction: Action
@export var nav: Variant

@export var parameters: Array[Variant]

@export var dist: float = 10

var threshcounter: int = 0
@export var threshold: int = 40

@export var offset: Vector3 = Vector3(0,0,0)

@export var screamRange: float = 17.0

var screamArea

func initialize(args: Array[Variant]):
	parameters = args
	target = args[0]
	actor = args[1]
	attackAction = args[2]
	nav = args[3]
	createScreamArea()

func tick(_Caster: Node, _CasterBehaviour: Behaviour):
	if actor != null:
		var tempPosition = target.global_position
		if actor.visual.global_position != tempPosition:
			actor.visual.look_at(tempPosition, Vector3.UP)
			#print("moving")
		nav.target_position = tempPosition + offset
		var temptempPosition = nav.get_next_path_position()
		temptempPosition.y = actor.global_position.y
		actor.move()
		threshcounter += 1
		if threshcounter == threshold:
			threshcounter = 0
			scream(_CasterBehaviour)
			#print("recalculating offset")
			var stink = calculateOffset()
			offset = Vector3(stink.x,0,stink.y)

func createScreamArea():
	screamArea = Area3D.new()
	var screamCol = CollisionShape3D.new()
	screamArea.set_collision_mask_value(1,false)
	screamArea.set_collision_mask_value(18, true) #17
	screamCol.shape = SphereShape3D.new()
	screamCol.shape.radius = screamRange * 2
	
	actor.add_child(screamArea)
	screamArea.set_owner(actor)
	screamArea.add_child(screamCol)
	screamCol.set_owner(actor)
	
	return true

func scream(_behaviour: Behaviour):
	_behaviour.say("AAAAH!!!", 2.0)
	var bodies = screamArea.get_overlapping_bodies()
	for body in bodies:
		if body.behaviour.has_method("hero"):
			print("alerted")
			body.behaviour.hero()

func calculateOffset() -> Vector2:
	var selfpos = actor.global_position
	var targetpos = target.global_position
	var temp = (selfpos - targetpos)
	var tempTrue: Vector2 = Vector2(temp.x,temp.z).normalized()
	return tempTrue.rotated(90) * dist
