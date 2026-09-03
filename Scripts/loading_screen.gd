extends Node3D

@onready var pBar = $CanvasLayer/Control/ProgressBar
@export var targetPath: String = "res://Scenes/Game.tscn"
var progress: Array[float] = []

func _ready() -> void:
	var err = ResourceLoader.load_threaded_request(targetPath)
	if err != OK:
		push_error("Failed to start threaded load: " + str(err))
		return

func _process(_delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(targetPath, progress)
	
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			pBar.value = progress[0] * 100
		ResourceLoader.THREAD_LOAD_LOADED:
			var scene = ResourceLoader.load_threaded_get(targetPath)
			get_tree().change_scene_to_packed(scene)
		ResourceLoader.THREAD_LOAD_FAILED:
			push_error("failed to load: " + targetPath)
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			push_error("no such thing as: " + targetPath)
