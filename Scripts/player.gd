extends CharacterBody3D

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

var dashVector = Vector3(dashD, 0, 0)

@onready var cursorNode = $Cursor
@onready var camera = $Camera3D
@onready var rotationNode = $Rotation
@onready var wizard = $Rotation/Wizard
@onready var followerNode = $Rotation/Follower1 #will be replaced with a function eventually but this will do for now

@onready var dialogueArea = $Area3D

@export var globalmousePos: Vector3

func refreshStats():
	SPEED = stats.retrieve(0) * 2.5
	max_mana = ((stats.retrieve(1) + stats.retrieve(3)) / 2) * 1000
	max_health = stats.retrieve(4) * 50
	
	mana_recovery_amt = stats.retrieve(1) * 10
	
	health_recovery = stats.retrieve(4)

func damage(amt: float):
	health -= amt

func _ready():
	initialize()

func getFollowerNode() -> Node3D:
	return followerNode

func initialize():
	print(global_position.distance_to(camera.global_position))
	Globals.Player = self
	Globals.stats = stats
	inventory.assignIDs()
	stats.initialize()
	refreshStats()

func recoverMana():
	print("recovering manaa")
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

func _physics_process(delta: float) -> void:
	if canRecoverMana:
		recoverMana()
	if canRecoverhealth:
		recoverHealth()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#call mouselook func
	look_at_mouse()
	
	#swage movement m8
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	#bitch dash, to be replaced
	#actually ykw why are we even doing the casting here?
	#check for dialogue
	if Input.is_action_just_pressed("interact"):
		checkDialogue()
	
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
	setCursor()
	var mouse_pos = get_viewport().get_mouse_position()
	
	#ray
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var direction = camera.project_ray_normal(mouse_pos)
	
	var plane = Plane(Vector3.UP, 0.0)
	
	var hit = plane.intersects_ray(ray_origin, direction)
	
	if hit != null:
		var localmousePos = hit
		globalmousePos = hit
		
		localmousePos.y = global_position.y
		if global_position.distance_to(localmousePos) > 0.1:
			cursorNode.global_position = localmousePos
			rotationNode.look_at(localmousePos, Vector3.UP)
	else:
		print("failing somehow")
		return Vector3.ZERO

#use old cursor functionality
func setCursor():
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
