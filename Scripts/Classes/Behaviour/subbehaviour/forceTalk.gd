extends subBehaviour

class_name forceTalk

@export var range := 5.0
@export var done: bool = false

func tick(_behaviour: Behaviour):
	if _behaviour.actor.global_position.distance_to(Globals.Player.global_position) <= range and !done:
		done = true
		Globals.Root.startDialogue(_behaviour.words)
