@tool
extends Node3D

@export var amt := 15.0

func _process(delta: float) -> void:
	self.global_rotation.y += amt
