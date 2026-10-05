extends Control

@onready var texNode = $VBoxContainer/SubViewportContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.minimap = self

func initialize():
	#texNode.texture = Globals.gamestate.newWorld.viewTex
	texNode.update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func updateWindow():
	pass

func get_save_data():
	return {
		"position": global_position,
		"size": size,
	}

func load_save_data(data: Dictionary):
	global_position = data["position"]
	size = data["size"]
	updateWindow()
