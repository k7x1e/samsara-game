@tool
extends Node

@export var zoneName: String

func _func_godot_apply_properties(entity_properties: Dictionary) -> void:
	zoneName = entity_properties["zoneName"] as String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
