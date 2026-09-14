extends PathFollow3D

@export var speed: float = 5.0
@export var phbody: Node3D

@export var stopoffsets: Array[float]

@export var stopduration: float

var goingForward: bool = true
var is_stopped: bool = false

var current_stop_index = 0
var indexgoingforward = true

func _process(delta: float) -> void:
	phbody.global_position = global_position
	if is_stopped or stopoffsets.is_empty():
		return
	if goingForward:
		progress += speed * delta
	else:
		#print("going backwards")
		progress -= speed * delta
	if progress_ratio == 1.0 or progress_ratio == 0.0:
		goingForward = !goingForward

func tick():
	phbody.global_rotation = global_rotation
	#print(global_position, phbody.global_position)
	if is_stopped or stopoffsets.is_empty():
		return
	
	
	if current_stop_index < stopoffsets.size() and !current_stop_index < 0:
		#print(current_stop_index, stopoffsets.size())
		var next_stop = stopoffsets[current_stop_index]
		if (progress >= next_stop and goingForward) or (progress <= next_stop and !goingForward):
			#print("at stop", current_stop_index)
			progress = next_stop          # snap exactly
			is_stopped = true
			if current_stop_index == stopoffsets.size() - 1:
				#print("going backwards")
				indexgoingforward = false
			elif current_stop_index == 0:
				#print(" going forwards")
				indexgoingforward = true
			match indexgoingforward:
				true:
					current_stop_index += 1
				false:
					current_stop_index -= 1
			reached_stop()

func reached_stop():
	await get_tree().create_timer(stopduration).timeout
	is_stopped = false
