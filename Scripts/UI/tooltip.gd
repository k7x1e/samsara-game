extends Control

@export var following: bool = false

@export var offset: Vector2 = Vector2(10,10)

@onready var pLabel = $VBoxContainer/Label
@onready var dLabel = $VBoxContainer/desc

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if following:
		global_position = get_global_mouse_position() + offset
