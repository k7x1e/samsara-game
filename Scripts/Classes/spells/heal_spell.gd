extends Node3D

@export var amount = 50.0

@onready var billboard = $billboard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.Player.health += amount
	await billboard.initialize()
	#print("killing self")
	self.queue_free()
