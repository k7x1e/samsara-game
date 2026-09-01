extends CharacterBody3D

@onready var behaviour: Behaviour
@onready var visual = $Visual
@onready var nav = $Nav

@export var health: float = 100
@export var NpcClass: npc


var deltaSHIT: float = 1
var tempPos

func _ready() -> void:
	initialize()

func _physics_process(delta: float) -> void:
	deltaSHIT = delta
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	#basically to tick the behaviour script(when i eventually make it). 
	#Will most likely be replaced by a tick function handled by the combat manager.
	behaviour.update()

func damage(amt: float):
	print("took damage")
	health -= amt
	behaviour.say(str("-", amt), 0.2, true)
	if health <= 0:
		behaviour.death()

func move():
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
	behaviour = NpcClass.behaviour
	behaviour.actor = self
	behaviour.initialize()
	var CharModel = NpcClass.model.instantiate()
	visual.add_child(CharModel)
	CharModel.set_owner(self)

func destroy():
	self.queue_free()
