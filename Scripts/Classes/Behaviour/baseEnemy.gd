extends Behaviour

class_name baseEnemy

signal playerFoundAlert()
signal attacking()
signal damaged()

@export var attackAction: Action

@export var alerts: bool = true
@export var alertArea: Variant
@export var damageArea: Variant
@export var detectionArea: Variant
@export var player: Variant
@export var nav: Variant

@export_enum("Wandering","Detected","Dead") var enemy_state: int = 0

@export var atdamage: float = 10.0

@export var currentCombatBehaviour: combatBehaviour

var can_attack: bool = true

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
		fixCombatBehaviour()
		playerFoundAlert.emit()

func fixCombatBehaviour():
	currentCombatBehaviour = Globals.getBehaviourFromItemType(actor.equipped.WeaponType)
	currentCombatBehaviour.initialize([player,actor,actor.equipped.action,nav,null,damageArea,actor.equipped.action.damage])

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
	actor.move()

func wander():
	pass #do nothing for now

func hunt():
	currentCombatBehaviour.tick(actor,self)
	if can_attack:
		currentCombatBehaviour.attack(self)
		cooldown()

func damage(amt: float):
	if health - amt > 0:
		health -= amt
		return true
		damaged.emit()
	else: 
		health = 0
		return false

func cooldown():
	can_attack = false
	await Engine.get_main_loop().create_timer(1.0).timeout
	can_attack = true
