extends subBehaviour

class_name lookAtPlayer

func tick(_behaviour: Behaviour):
	_behaviour.actor.visual.look_at(_behaviour.actor.nav.target_position, Vector3.UP)
