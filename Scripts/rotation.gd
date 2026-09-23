extends Node3D

var forward: Vector3 = -global_transform.basis.z

@export var walkTarget: Vector3
@export var lookTarget: Vector3

@export var actualWalkTarget: Vector3
@export var actualLookTarget: Vector3

@export var lookTargetNode: Node3D

@export var diff: float

@export var backwards: bool = false

@export var rotationSpeed = 5.0

func tick():
	diff = rad_to_deg(getAngles())
	
	#print(diff)
	if diff > -90.0 and diff <= 90.0:
		actualWalkTarget = walkTarget
		backwards = false
	else:
		actualWalkTarget = 2.0 * global_position - walkTarget
		backwards = true
	
	#just use the unfucked values for now
	#actualWalkTarget = walkTarget
	actualLookTarget = lookTarget
	
	
	
	#wizard.look_at(lookTarget, Vector3.UP)

func _process(delta: float) -> void:
	changeRotation(delta)

func getAngles() -> float:
	var dir1 = (walkTarget - global_position).normalized()
	var dir2 = (lookTarget - global_position).normalized()
	
	#var angle_to_1: float = global_position.angle_to(dir1)
	#var angle_to_2: float = global_position.angle_to(dir2)
	
	#var angle_difference: float = abs(angle_to_1 - angle_to_2)
	var angle_between_positions := dir1.angle_to(dir2)
	
	return angle_between_positions

func changeRotation(delta:float):
	#make it work like it did for now as i figure out a solution
	var target_transform = global_transform.looking_at(actualWalkTarget, Vector3.UP)
	global_transform = global_transform.interpolate_with(target_transform, rotationSpeed * delta)
	global_rotation.z = 0
	global_rotation.x = 0
	#global_rotation.move_toward(Vector3(target_transform.rotation),delta * rotationSpeed)
	lookTargetNode.global_position = actualLookTarget
