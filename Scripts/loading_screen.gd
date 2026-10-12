extends Node3D

signal anyButtonPressed

@onready var doneLabel = $CanvasLayer/Label
@onready var tipLabel = $CanvasLayer/Control/Label
@export var loadingTips: Array[String] = ["Tip: One faithful day in 2026 a lazy coder would end up putting this text here only to forget to put actual tips in place"]

@onready var anim = $AnimationPlayer
@onready var pBar = $CanvasLayer/Control/ProgressBar
@export var targetPath: String = "res://Scenes/Game.tscn"
var progress: Array[float] = []
var loading: bool = true

func _ready() -> void:
	anim.play("fadein")
	tipLabel.text = fetchRandomTip()
	var err = ResourceLoader.load_threaded_request(targetPath)
	if err != OK:
		push_error("Failed to start threaded load: " + str(err))
		return

func fetchRandomTip() -> String:
	var i = randi_range(0,loadingTips.size())
	return loadingTips[i]

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		anyButtonPressed.emit()

func _process(_delta: float) -> void:
	if loading:
		var status = ResourceLoader.load_threaded_get_status(targetPath, progress)
		
		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				pBar.value = progress[0] * 100
			ResourceLoader.THREAD_LOAD_LOADED:
				var scene = ResourceLoader.load_threaded_get(targetPath)
				anim.play("fadeout")
				loading = false
				await get_tree().create_timer(2).timeout
				get_tree().change_scene_to_packed(scene)
			ResourceLoader.THREAD_LOAD_FAILED:
				push_error("failed to load: " + targetPath)
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				push_error("no such thing as: " + targetPath)
