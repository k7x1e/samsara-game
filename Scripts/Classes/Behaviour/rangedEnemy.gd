extends Behaviour

class_name rangedEnemy

signal playerFoundAlert()
signal attacking()
signal damaged()

@export var alerts: bool = true
@export var alertArea: Variant
@export var damageArea: Variant
@export var detectionArea: Variant
@export var player: Variant
@export var nav: Variant

@export var range: float = 10.0

@export_enum("Wandering","Detected","Dead") var enemy_state: int = 0

@export var atdamage: float = 10.0

@export var projectile: PackedScene

var can_attack: bool = true
var can_move: bool =true

@export var threshold: int = 5 ##ticks before they recalculate target
var threshcounter
@export var offset: Vector3 = Vector3(0,0,0)

func initialize():
	player = Globals.Player
	
	nav = actor.nav
	
	damageArea = actor.get_node("attackrange")
	detectionArea = actor.visual.get_node("detection")
	detectionArea.body_entered.connect(detectionEntered)
	detectionArea.body_exited.connect(detectionExited)
	
	alertArea = actor.get_node("aura")

func detectionEntered(body: Node3D):
	#print("body has entered")
	if body == player:
		detectPlayer(true)

func detectionExited(body: Node3D):
	pass

func detectPlayer(detected: bool, isAlerted: bool = false): ##detected is whether or not it is and the second is whether or not said alert comes from alert
	if detected:
		if alerts and !isAlerted:
			alertEnemies(1)
		#print("detected player")
		enemy_state = 1
		playerFoundAlert.emit()

func alertEnemies(state: int):
	var bodies = alertArea.get_overlapping_bodies()
	for body in bodies:
		body.behaviour.detectPlayer(true, true)

func update():
	if !player:
		player = Globals.Player
	match enemy_state:
		0:
			wander()
		1:
			hunt()
		2:
			pass
	#tempPosition.y = actor.global_position.y

func wander():
	pass #do nothing for now

func hunt():
	var tempPosition = player.global_position
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
		threshcounter = 0
	else:
		threshcounter += 1
		if threshcounter == threshold:
			#print("recalculating offset")
			var stink = calculateOffset()
			offset = Vector3(stink.x,0,stink.y)

func damage(amt: float):
	if health - amt > 0:
		health -= amt
		return true
		#damaged.emit()
	else: 
		health = 0
		return false

func checkAttack() -> bool:
	var bodies = damageArea.get_overlapping_bodies()
	for body in bodies:
		return checkSight()
	return false

func calculateOffset() -> Vector2:
	var selfpos = actor.global_position
	var playerpos = player.global_position
	var temp = (selfpos - playerpos)
	var tempTrue: Vector2 = Vector2(temp.x,temp.z).normalized()
	return tempTrue.rotated(90) * range

func checkSight() -> bool:
	var space_state = actor.get_world_3d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters3D.create(actor.global_position, player.global_position)
	query.set_collision_mask(30)
	var result = space_state.intersect_ray(query)
	if result.collider.name == "Player" or result.collider.name == "Actor":
		return true
	return false

func attack():
	#replace with projectile
	var bodies = damageArea.get_overlapping_bodies()
	for body in bodies:
		can_attack = false
		await movementcooldown()
		#print("attacking player..")
		attacking.emit()
		var poop = projectile.instantiate()
		actor.add_child(poop)
		poop.set_owner(actor)
		poop.global_position = actor.global_position
		poop.global_rotation = actor.visual.global_rotation
		poop.initialize()
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
