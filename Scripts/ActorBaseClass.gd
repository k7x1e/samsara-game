extends CharacterBody3D

@onready var behaviour: Behaviour
@onready var visual = $Visual
@onready var nav = $Nav
@onready var monitor = $Monitor

@export var health: float = 100 ##welcome to cp brother
@export var NpcClass: npc
@export var hasMonitor: bool = false

var deltaSHIT: float = 1
var tempPos

func _ready() -> void:
	await initialize()
	if hasMonitor:
		await monitor.initialize()

func _physics_process(delta: float) -> void:
	deltaSHIT = delta
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	#basically to tick the behaviour script(when i eventually make it). 
	#Will most likely be replaced by a tick function handled by the combat manager.
	#TO BE REPLACED
	move()

func tick():
	behaviour.update()
	

func damage(amt: float):
	print("took damage")
	health -= amt
	behaviour.say(str("-", amt), 0.2, true)
	if health <= 0:
		behaviour.death()

func move():
	if not is_inside_tree() or not nav.is_inside_tree():
		return
	#basically just stolen from dustrialis source code.
	#if behaviour.nav.target_position:
	tempPos = nav.get_next_path_position()
	#print("headed to ", tempPos)
	var direction = position.direction_to(tempPos)
	if direction:
		#print("i have motion")
		#oh my god nigga "i have motion"
		velocity.x = direction.x * behaviour.speed
		velocity.z = direction.z * behaviour.speed
	else:
		#print("i have nowhere to go....")
		velocity.x = move_toward(velocity.x, 0, deltaSHIT)
		velocity.z = move_toward(velocity.z, 0, deltaSHIT)
	#print(direction, velocity)
	#functionality for the ability
	move_and_slide()

func initialize():
	
	behaviour = NpcClass.behaviour.duplicate()
	behaviour.actor = self
	behaviour.initialize()
	var CharModel = NpcClass.model.instantiate()
	visual.add_child(CharModel)
	CharModel.set_owner(self)
	return true

func destroy():
	self.queue_free()
