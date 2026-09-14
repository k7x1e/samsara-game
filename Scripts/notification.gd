extends Node3D

@onready var textLabel = $SubViewport/CanvasLayer/CenterContainer/Label
@onready var anim = $AnimationPlayer

@export var offset: float = 1.5
@export var ntext: String = "why"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.02).timeout
	self.global_position.y += offset
	print("im in")
	textLabel.text = ntext
	anim.play("notif")
	await get_tree().create_timer(1.0).timeout
	#sself.queue_free()
