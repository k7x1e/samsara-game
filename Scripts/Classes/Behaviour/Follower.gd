extends Behaviour

class_name Passive


@export var player: Variant
@export var nav: Variant
@export var hasDialogue: bool

@export var angerable: bool = true
@export var angered: bool = false
@export var angerThresh: int = 0 ##how much damage needs to be taken before it gets angered. zero means any damage will piss it off.

@export var damageArea: Variant

var anger: int = 0

@export var words: conversation

@export var currentCombatBehaviour: combatBehaviour

var playerFollowerNode: Variant

func takeDamage(amt: int):
	#print("taking damage")
	anger += amt
	if anger >= angerThresh:
		#print("angered")
		getAngered()

func getAngered():
	hasDialogue = false
	print("angered")
	angered = true
	actor.fixCombatBehaviour()

func initialize():
	damageArea = actor.damageArea
	player = Globals.Player
	#playerFollowerNode = player.getFollowerNode()
	
	#nav = actor.nav
	
	#await Engine.get_main_loop().create_timer(1.0).timeout
	
	#say("hello sol", 1.0)

func update():
	#print("actor tick")
	if angered:
		#print("anger tick")
		actor.currentCombatBehaviour.tick(actor, self)
		actor.move()
	#print("I am to chase", str(player.global_position))
	#var tempPosition = playerFollowerNode.global_position
	#tempPosition.y = actor.global_position.y
	#nav.target_position = tempPosition
