extends Node3D

@export var nodeToSpawn: PackedScene
@export var duration: float = 2.0

var can_spawn: bool = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func tick():
	if can_spawn:
		spawnNode()

func spawnNode():
	var temp = nodeToSpawn.instantiate()
	Globals.Root.add_child(temp)
	temp.set_owner(Globals.Root)
	temp.global_position = self.global_position
	cooldown()

func cooldown():
	can_spawn = false
	await get_tree().create_timer(duration).timeout
	can_spawn = true
