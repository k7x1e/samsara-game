extends Node3D

@export var duration = 0.2

# Called when the node enters the scene tree for the first time.
func initialize() -> void:
	var backup = Globals.stats.agility
	Globals.stats.setstat(0,30)
	await Engine.get_main_loop().create_timer(duration).timeout
	Globals.stats.setstat(0,backup)
	self.queue_free()
