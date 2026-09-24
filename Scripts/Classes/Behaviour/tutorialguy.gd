extends Behaviour

class_name TutorialGuy

@export var player: Variant
@export var nav: Variant
@export var hasDialogue: bool

@export var words: conversation
@export var outoftutorial: Condition

@export var respawnPosition: Vector3
@export var ownPosition: Vector3

@export var moving: bool = false

@export var animTree: AnimationNodeBlendTree

@export var playerFollowerNode: Variant

func initialize():
	ownPosition = actor.global_position
	player = Globals.Player
	playerFollowerNode = player.getFollowerNode()
	
	nav = actor.nav
	
	await Engine.get_main_loop().create_timer(1.0).timeout
	
	say("Press Space or Q to interact.", 1.0)

func update():
	if moving:
		#print("I am to chase", str(player.global_position))
		#var tempPosition = playerFollowerNode.global_position
		#tempPosition.y = actor.global_position.y
		if nav.is_target_reached:
			moving = false
		nav.target_position = ownPosition
		actor.move()
		if !moving:
			await Engine.get_main_loop().create_timer(2.0).timeout
			say("You cannot kill me.", 2.0)
		if actor.global_position.distance_to(ownPosition) <= 0.1:
			print("no longer walking")
			animTree.set("parameters/Blend2 2/blend_amount", 0.0)
	if outoftutorial.fulfilled:
		print("out of tutorial")
		Globals.Root.changeWorld(self, "tutorial", false, true, true)

func death():
	animTree.set("parameters/Blend2 2/blend_amount", 1.0)
	actor.health = 100
	actor.global_position = respawnPosition
	moving = true
