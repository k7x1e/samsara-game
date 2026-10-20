extends Behaviour

class_name rangedEnemy

signal playerFoundAlert()
signal damaged()

@export var alerts: bool = true
@export var alertArea: Variant
@export var damageArea: Variant
@export var detectionArea: Variant
@export var player: Variant
@export var nav: Variant

@export_enum("Wandering","Detected","Dead") var enemy_state: int = 0

@export var atdamage: float = 10.0

@export var projectile: PackedScene

@export var currentCombatBehaviour: combatBehaviour

var can_attack: bool = true
var can_move: bool =true

@export var threshold: int = 5 ##ticks before they recalculate target
var threshcounter
@export var offset: Vector3 = Vector3(0,0,0)

func initialize():
	player = Globals.Player
	
	nav = actor.nav
	
	damageArea = actor.damageArea
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
	if actor.currentCombatBehaviour:
		actor.currentCombatBehaviour.tick(actor, self)
	else:
		actor.fixCombatBehaviour()

func damage(amt: float):
	if health - amt > 0:
		health -= amt
		return true
		#damaged.emit()
	else: 
		health = 0
		return false
