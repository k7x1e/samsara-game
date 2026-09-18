@tool
extends Node3D

@export var belongsTo: int
@export var pathIndex: int
@export var isStartPoint: bool = false
@export var isStop: bool = false

func _func_godot_apply_properties(entity_properties: Dictionary) -> void:
	belongsTo = entity_properties["belongsTo"] as int
	pathIndex = entity_properties["index"] as int
	isStartPoint = entity_properties["startpoint"] as bool
	isStop = entity_properties["isAStop"] as bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.01).timeout
	if Globals.currentWorldNode.containsTrams:
		Globals.currentWorldNode.tramTransforms[belongsTo].append(self)
