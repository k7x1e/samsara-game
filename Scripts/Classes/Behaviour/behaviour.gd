extends Resource

class_name Behaviour

signal attacking

@export var health: float
@export var speed: float = 15
@export var actor: Variant
@export var hasDialoge: bool = false

@export var billboard: PackedScene = preload("res://Scenes/billboard.tscn")
@export var notification: PackedScene = preload("res://Scenes/notification.tscn")

func damage(amt: float) -> bool: #return true if survived, if dead return false to let the actor kill itself.
	if health - amt > 0:
		health -= amt
		return true
	else: 
		health = 0
		return false

func say(message: String, duration: float, rootparent: bool = false):
	var temp = billboard.instantiate()
	if rootparent:
		Globals.Root.add_child(temp)
		temp.global_position = actor.global_position
	else:
		actor.add_child(temp)
	temp.set_owner(Globals.Root)
	temp.duration = duration
	temp.billboardtext = message
	temp.initialize()

func notify(message: String, rootparent: bool = false):
	var temp = notification.instantiate()
	if rootparent:
		Globals.Root.add_child(temp)
	else:
		actor.add_child(temp)
	temp.set_owner(actor)
	temp.ntext = message
	temp.global_position = actor.global_position
	temp.initialize()

func death():
	#here is where one would stick fancy death stuff, do whatever then send the destruction command.
	actor.destroy()

func initialize():
	#set important things here.
	pass

func update():
	#stick kinda whatever here
	pass
