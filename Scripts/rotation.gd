extends Node3D

var forward: Vector3 = -global_transform.basis.z

signal reversed(isit: bool)

@export var walkTarget: Vector3 = Vector3(0,0,0)
@export var lookTarget: Vector3 = Vector3(0,0,0)

@export var actualWalkTarget: Vector3
@export var actualLookTarget: Vector3

@export var lookTargetNode: Node3D

@export var diff: float

@export var backwards: bool = false

@export var rotationSpeed = 5.0

var desired_facing: Vector3 = Vector3(0,0,0)

func tick():
	diff = getAngles()
	
	#print(diff)
	if diff > -90.0 and diff <= 90.0:
		actualWalkTarget = walkTarget
		desired_facing = (walkTarget - global_position).normalized()
		backwards = false
		reversed.emit(false)
	else:
		#just look at the looktarget if not and later on make it play the backwards walk anim
		actualWalkTarget = 2.0 * global_position - walkTarget
		desired_facing = (lookTarget - global_position).normalized()
		backwards = true
		reversed.emit(true)
	
	#just use the unfucked values for now
	#actualWalkTarget = walkTarget
	actualLookTarget = lookTarget
	
	
	
	#wizard.look_at(lookTarget, Vector3.UP)

func _process(delta: float) -> void:
	changeRotation(delta)

func getAngles() -> float:
	var dir1 = (walkTarget - global_position).normalized()
	var dir2 = (lookTarget - global_position).normalized()
	return rad_to_deg(dir1.signed_angle_to(dir2, Vector3.UP))

func changeRotation(delta:float):
	#make it work like it did for now as i figure out a solution
	#var target_transform = global_transform.looking_at(actualWalkTarget, Vector3.UP)
	#global_transform = global_transform.interpolate_with(target_transform, rotationSpeed * delta)
	var target_basis = Basis.looking_at(desired_facing, Vector3.UP)
	var current_rot = global_transform.basis.get_rotation_quaternion()
	var target_rot  = target_basis.get_rotation_quaternion()

	# Slerp always takes the shortest arc → correct spin direction
	global_transform.basis = Basis(current_rot.slerp(target_rot, rotationSpeed * delta))
	global_rotation.z = 0
	global_rotation.x = 0
	#global_rotation.move_toward(Vector3(target_transform.rotation),delta * rotationSpeed)
	lookTargetNode.global_position = actualLookTarget
