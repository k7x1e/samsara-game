extends Node3D

@export var duration = 10.0
@export var statusEffect: statuseffect

# Called when the node enters the scene tree for the first time.
func initialize() -> void:
	Globals.Player.modifyEffects(statusEffect, true)
	var backup = Globals.stats.agility
	Globals.stats.setstat(0,backup*2.0)
	var finalDuration = duration * (Globals.stats.magic * 0.75)
	statusEffect.duration=finalDuration
	statusEffect.initialize()
	await Engine.get_main_loop().create_timer(finalDuration).timeout
	Globals.Player.modifyEffects(statusEffect, false)
	Globals.stats.setstat(0,backup)
	self.queue_free()
