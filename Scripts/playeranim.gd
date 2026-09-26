extends AnimationTree

@export var player: CharacterBody3D

@export var anim: AnimationPlayer

@export var currentState: String = "rest"

@export var backwards: bool = false

var statemachinespell: AnimationNodeStateMachinePlayback
var statemachineitem: AnimationNodeStateMachinePlayback

func _ready():
	statemachinespell = get("parameters/StateMachine spell/playback")
	statemachineitem = get("parameters/StateMachine item/playback")
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
	statemachinespell.travel(_which)

func playEquipAnim(_which: String):
	statemachineitem.travel(_which)

func casted(anim: String) -> void:
	playAnim(anim)


func reversed(isit: bool) -> void:
	backwards = isit
