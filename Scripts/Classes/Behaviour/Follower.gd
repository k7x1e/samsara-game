extends Behaviour

class_name Follower

@export var player: Variant
@export var nav: Variant

var playerFollowerNode: Variant

func initialize():
	player = Globals.Player
	playerFollowerNode = player.getFollowerNode()
	
	nav = actor.nav
	
	await Engine.get_main_loop().create_timer(1.0).timeout
	
	say("Hello World")

func update():
	#print("I am to chase", str(player.global_position))
	var tempPosition = playerFollowerNode.global_position
	#tempPosition.y = actor.global_position.y
	nav.target_position = tempPosition
	actor.move()
