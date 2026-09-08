extends Node3D

@onready var effectArea = $Effect
@export var damage: float = 150
@onready var anim = $anim

# Called when the node enters the scene tree for the first time.
func initialize() -> void:
	print("ive been cast")
	self.global_position = Globals.Player.globalmousePos
	await get_tree().physics_frame
	await get_tree().physics_frame
	if effectArea.has_overlapping_bodies():
		damageBodies()
	else:
		print("theres nothing")
	#put fancy animation here
	anim.play("Strike")
	await get_tree().create_timer(0.2).timeout
	self.queue_free()

func damageBodies():
	print("damaging bodies")
	var bodies = effectArea.get_overlapping_bodies()
	for body in bodies:
		print("damaging bodies")
		body.damage(150)
		
