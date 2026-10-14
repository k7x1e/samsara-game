extends CharacterBody3D

class_name Player

signal moving()
signal stopping()

@export var is_moving: bool = false

@export var equipment: EquipmentManager
@export var inventory: InventoryClass

@export var SPEED = 5.0
@export var dashD = 7.5

@export var mana: float = 1000
@export var health: float = 100

@export var max_mana: float = 1000
@export var max_health: float = 100

@export var mana_recovery: float = 1.0
@export var mana_recovery_amt: float = 20
var canRecoverMana: bool = true

@export var health_recovery: float = 2.0
var canRecoverhealth: bool = true

@export var stats: Stats
@export var experienceThresh: float = 20

var dashVector = Vector3(dashD, 0, 0)

@onready var cursorNode = $Cursor
@onready var camera = $Camera3D
@onready var rotationNode = $Rotation
@onready var wizard = $Wizard
@onready var followerNode = $Rotation/Follower1 #will be replaced with a function eventually but this will do for now
@onready var lookTarget = $lookTarget
@onready var animManager = $Rotation/anim
@onready var skeleton = $Rotation/londonProtag/Armature/Skeleton3D

@onready var notification = preload("res://Scenes/notification.tscn")

@onready var dialogueArea = $Area3D

@export var globalmousePos: Vector3

@export var quests: Array[Quest]

@export var sounds: Dictionary[String, AudioStream]
@onready var sfx = $sfx

@export var statuseffects: Array[statuseffect]

@export var unlocks: Dictionary[String, itemClass]

@export var isGlobal: bool = true
@export var globalName: StringName = "Player"

@export var goldamt: int = 100

@export var controllerActive: bool = false

var spells: Array[spell]

var referenceN: Node3D
var loaded = false

func initializeGold():
	Globals.goldItem.gold_changed.connect(updateGold)

func updateGold():
	goldamt = Globals.goldItem.quantity

func modifyEffects(index: statuseffect, append: bool):
	match append:
		true:
			statuseffects.append(index)
		false:
			statuseffects.erase(index)
	print("refreshing effects")
	Globals.effecthandler.refreshEffects()

func checkLevelUnlocks(stat: int, level: int): ## only items as of now
	var unlockindex = str(stat, level)
	if unlocks.has(unlockindex):
		var unlock = unlocks[unlockindex]
		notify(str("unlocked: ", unlock.name))
		inventory.add(unlock)

func refreshStats():
	SPEED = stats.retrieve(0) * 1 + 6
	max_mana = ((stats.retrieve(1) + stats.retrieve(3)) / 2) * 1000
	max_health = stats.retrieve(4) * 20
	
	mana_recovery_amt = stats.retrieve(1) * 3
	
	health_recovery = stats.retrieve(4)

func damage(amt: float):
	health -= amt
	if health <= 0:
		death()
	stats.experience(4)
	notify(str("-", str(amt)))

func death():
	notify("you died !!")
	Globals.Root.death()

func notify(notif: String, Audio: String = "None"):
	var temp = notification.instantiate()
	self.add_child(temp)
	temp.set_owner(self)
	temp.ntext = notif
	temp.global_position = self.global_position
	temp.initialize()
	if Audio != "None":
		sfx.stream = sounds[Audio]
		sfx.play()

func _ready():
	controllerActive = Globals.controllerActive
	Globals.Player = self
	Globals.quests = quests
	Globals.stats = stats
	print(global_position.distance_to(camera.global_position))
	referenceN = Node3D.new()
	Globals.Root.add_child(referenceN)
	referenceN.global_position = self.global_position

func getFollowerNode() -> Node3D:
	return followerNode

func initialize():
	if loaded:
		wizard.spells = spells
	inventory.assignIDs()
	stats.initialize()
	refreshStats()

func recoverMana():
	#print("recovering manaa")
	#genuinely the dumbest shit ill ever code
	canRecoverMana = false
	await get_tree().create_timer(mana_recovery).timeout
	mana += mana_recovery_amt
	canRecoverMana = true

func recoverHealth():
	#genuinely the dumbest shit ill ever code
	canRecoverhealth = false
	await get_tree().create_timer(health_recovery).timeout
	if health < max_health:
		health += health_recovery
	canRecoverhealth = true

func tick():
	if canRecoverMana:
		recoverMana()
	if canRecoverhealth:
		recoverHealth()
	
	
	look_at_mouse()
	setCursor()
	
#move over all that isnt acute to the tick
func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("interact"):
		checkDialogue()
	#call mouselook func
	#look_at_mouse()
	#swage movement m8
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		rotationNode.walkTarget = global_position + direction
		
		if !is_moving:
			moving.emit()
			is_moving = true
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		if is_moving:
			stopping.emit()
			is_moving = false
	
	#bitch dash, to be replaced
	#actually ykw why are we even doing the casting here?
	#check for dialogue
	
	
	move_and_slide()

func checkDialogue():
	if dialogueArea.has_overlapping_bodies():
		var bodies = dialogueArea.get_overlapping_bodies()
		for body in bodies:
			if body.NpcClass.behaviour.hasDialogue:
				Globals.Root.startDialogue(body.NpcClass.behaviour.words)
				return

#evil ass mouselook function niggaaaa
func look_at_mouse():
	if !controllerActive:
		var mouse_pos = get_viewport().get_mouse_position()
		
		#ray
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var direction = camera.project_ray_normal(mouse_pos)
		
		var plane = Plane(Vector3.UP, global_position.y)
		
		var hit = plane.intersects_ray(ray_origin, direction)
		
		if hit != null:
			var localmousePos = hit
			globalmousePos = hit
			
			localmousePos.y = global_position.y
			rotationNode.lookTarget = localmousePos
			wizard.look_at(localmousePos, Vector3.UP)
			#if global_position.distance_to(localmousePos) > 0.1:
			#	rotationNode.look_at(localmousePos, Vector3.UP)
		else:
			#print("failing somehow")
			return Vector3.ZERO
	else:
		var input_dir := Input.get_vector("rLeft", "rRight", "rUp", "rDown")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			var localmousePos = global_position + (direction * 4)
			localmousePos.y = global_position.y
			rotationNode.lookTarget = localmousePos
			wizard.look_at(localmousePos, Vector3.UP)
			cursorNode.global_position = localmousePos
	

#use old cursor functionality
func setCursor():
	if !controllerActive:
		var spacestate = get_world_3d().direct_space_state
		var mouse_pos = get_viewport().get_mouse_position()
		
		#ray
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 2000.0
		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		query.exclude = [self.get_rid()]
		
		#check result
		var result = spacestate.intersect_ray(query)
		if result.has("position") and global_position.distance_to(result["position"]) > 0.1:
			cursorNode.global_position = result["position"]
	else:
		pass
		


#leveling from walking
func update():
	var dist = self.global_position.distance_to(referenceN.global_position)
	#print(dist)
	if dist >= experienceThresh:
		stats.experience(0)
	referenceN.global_position = self.global_position
	#print(self.global_position.distance_to(referenceN.global_position))

func get_save_data():
	var quests_copy: Array[Quest] = []
	for q in quests:
		quests_copy.append(q.duplicate(true))
	print("saving... stuff....")
	return {
		"inventory": inventory.duplicate(true),
		"stats": stats.duplicate(true),
		#wizard section
		"spells": wizard.spells.duplicate(true),
		"health": health,
		"mana": mana,
		"quests": quests_copy,
		"equipment": equipment.duplicate(true),
	}

func load_save_data(data: Dictionary):
	#loaded = true
	inventory = data["inventory"]
	stats = data["stats"]
	#spells = Globals.convertArray(data["spells"],spell)
	#equipment = data["equipment"]
	health = data["health"]
	mana = data["mana"]
	quests = Globals.convertArray(data["quests"],Quest)
	Globals.quests = quests
	Globals.stats = stats
	refreshStats()
	#Globals.goldItem = inventory.goldItem
