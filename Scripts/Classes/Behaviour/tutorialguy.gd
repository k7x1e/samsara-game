extends Behaviour

class_name TutorialGuy

@export var player: Variant
@export var nav: Variant
@export var hasDialogue: bool

@export var words: conversation
@export var outoftutorial: Condition

var playerFollowerNode: Variant

func initialize():
	player = Globals.Player
	playerFollowerNode = player.getFollowerNode()
	
	nav = actor.nav
	
	await Engine.get_main_loop().create_timer(1.0).timeout
	
	say("Press Space or Q to interact.", 1.0)

func update():
	#print("I am to chase", str(player.global_position))
	#var tempPosition = playerFollowerNode.global_position
	#tempPosition.y = actor.global_position.y
	#nav.target_position = tempPosition
	#actor.move()
	if outoftutorial.fulfilled:
		print("out of tutorial")
		Globals.Root.changeWorld(self, "tutorial", false)
