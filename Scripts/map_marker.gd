@tool
extends Node3D

@export var locationName: String
@export var discovered: bool = false
@export var discoverable: bool = true

func _func_godot_apply_properties(entity_properties: Dictionary) -> void:
	locationName = entity_properties["locationName"] as String
	discoverable = entity_properties["discoverable"] as bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SubViewport/CanvasLayer/Label.text = locationName
	if discoverable:
		hide()


func _on_discovery_body_entered(body: Node3D) -> void:
	discovered = true
	show()
