extends Node3D

@export var duration = 10.0

# Called when the node enters the scene tree for the first time.
func initialize() -> void:
	var backup = Globals.stats.agility
	Globals.stats.setstat(0,backup*2.0)
	var finalDuration = duration * (Globals.stats.magic * 0.75)
	await Engine.get_main_loop().create_timer(finalDuration).timeout
	Globals.stats.setstat(0,backup)
