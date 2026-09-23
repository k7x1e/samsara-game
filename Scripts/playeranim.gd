extends AnimationTree

@export var player: CharacterBody3D

@export var anim: AnimationPlayer

@export var currentState: String = "rest"

@export var backwards: bool = false

func _ready():
	updateAnim()

func moving() -> void:
	currentState = "walking"
	updateAnim()

func stopping() -> void:
	currentState = "rest"
	updateAnim()

func updateAnim():
	print("playing ", currentState)
	match currentState:
		"walking":
			set("parameters/Blend2/blend_amount",0.0)
			if backwards:
				set("parameters/Blend2 3/blend_amount", 1.0)
			else:
				set("parameters/Blend2 3/blend_amount", 0.0)
		"rest":
			set("parameters/Blend2/blend_amount",1.0)

func playAnim(_which: String):
	match _which:
		"castMind":
			set("parameters/Add3/add_amount",-1)
			set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		"eat":
			set("parameters/Add3/add_amount",1)
			set("parameters/OneShot 3/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		"cast":
			set("parameters/Add3/add_amount",0)
			set("parameters/OneShot 2/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func casted(anim: String) -> void:
	playAnim(anim)


func reversed(isit: bool) -> void:
	backwards = isit
