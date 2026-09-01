extends CharacterBody3D

@export var inventory: InventoryClass

@export var SPEED = 5.0
@export var dashD = 7.5

@export var mana: float = 1000

var dashVector = Vector3(dashD, 0, 0)

@onready var cursorNode = $Cursor
@onready var camera = $Camera3D
@onready var rotationNode = $Rotation
@onready var wizard = $Rotation/Wizard
@onready var followerNode = $Rotation/Follower1 #will be replaced with a function eventually but this will do for now

func _ready():
	initialize()

func getFollowerNode() -> Node3D:
	return followerNode

func initialize():
	Globals.Player = self
	inventory.assignIDs()

func _physics_process(delta: float) -> void:
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
	if Input.is_action_just_pressed("ui_accept"):
		var dash = dashD * direction
		self.position += dash
	#actually ykw why are we even doing the casting here?§
	
	move_and_slide()

#evil ass mouselook function niggaaaa
func look_at_mouse():
	var spacestate = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	
	#ray
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 2000.0
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.exclude = [self.get_rid()]
	
	#check result
	var result = spacestate.intersect_ray(query)
	if result.has("position"):
		var target_pos = result["position"]
		
		target_pos.y = global_position.y
		
		if global_position.distance_to(target_pos) > 0.1:
			cursorNode.global_position = result["position"]
			rotationNode.look_at(target_pos, Vector3.UP)
