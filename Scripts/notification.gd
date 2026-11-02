extends Node3D

@onready var textLabel = $SubViewport/CanvasLayer/CenterContainer/Label
@onready var anim = $AnimationPlayer

@export var offset: float = 1.5
@export var ntext: String = "why"

# Called when the node enters the scene tree for the first time.
func initialize() -> void:
	self.global_position.y += offset
	#print("im in")
	textLabel.text = strip(ntext)
	anim.play("notif")
	await get_tree().create_timer(1.0).timeout
	queue_free()
	#sself.queue_free()

func strip(input:String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	return regex.sub(input, "", true)
