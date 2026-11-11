extends Behaviour

class_name Courier

@export var speakingThresh := 10.0

@export var words: conversation

@export var said := false
@export var donemission := false

var origin: Vector3
var target: Vector3

func damage(amt: float) -> bool: #return true if survived, if dead return false to let the actor kill itself.
	if health - amt > 0:
		health -= amt
		return true
	else: 
		health = 0
		return false

func death():
	#here is where one would stick fancy death stuff, do whatever then send the destruction command.
	actor.destroy()

func setMessage(message: conversation):
	print("updated convo")
	words = message

func initialize():
	print("initializing courier...")
	origin = actor.global_position
	#set important things here.
	pass

func _update():
	#do subBehaviours first
	if usesSubBehaviours:
		tickSubBehaviours()
	update()

func tickSubBehaviours():
	for i in subBehaviours:
		i.tick(self)

func update():
	if !donemission:
		target = Globals.Player.global_position
	else:
		target = origin
	actor.nav.target_position = target
	actor.move()
	var distance = actor.global_position.distance_to(target)
	if distance <= speakingThresh:
		if !said and !donemission:
			said = true
			say("Message for a Jeremiah!", 4.0)
		if distance < 5.0:
			if !donemission:
				donemission = true
			else:
				print("i have to kill myself")
				death()
