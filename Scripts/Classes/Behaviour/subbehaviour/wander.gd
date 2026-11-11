extends subBehaviour

class_name wander

@export var wanderRadius := 20.0
@export var reached := true

func tick(_behaviour: Behaviour):
	var nav: NavigationAgent3D = _behaviour.actor.nav
	#check things that might interfere.
	if "angered" in _behaviour:
		if _behaviour.angered:
			print("behaviour is angered, returning")
			return
	
	#behemoth of a line
	if reached:
		print("refreshing target...")
		nav.target_position = NavigationServer3D.map_get_closest_point(nav.get_navigation_map(),get_random_pos_in_radius_3d_flat(_behaviour.actor.global_position,wanderRadius))
		reached = false
	else:
		_behaviour.actor.move()
		if nav.is_navigation_finished():
			reached = false

func get_random_pos_in_radius_3d_flat(center: Vector3, radius: float) -> Vector3:
	var angle := randf() * TAU
	var distance := sqrt(randf()) * radius
	var offset := Vector3(cos(angle) * distance, 0.0, sin(angle) * distance)
	return center + offset
