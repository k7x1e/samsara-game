extends AnimationTree

@export var player: CharacterBody3D

@export var anim: AnimationPlayer

@export var currentState: String = "rest"

@export var backwards: bool = false

var statemachinespell: AnimationNodeStateMachinePlayback
var statemachineitem: AnimationNodeStateMachinePlayback
var statemachinetwohanded: AnimationNodeStateMachinePlayback

func _ready():
	statemachinespell = get("parameters/StateMachine spell/playback")
	statemachineitem = get("parameters/StateMachine item1hand/playback")
	statemachinetwohanded = get("parameters/StateMachine 2handed/playback")
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
	if _which != "None":
		statemachinespell.travel(_which)

func playEquipAnim(_which: String, unequipping: bool = false, twohanded: bool = false):
	if twohanded:
		statemachinetwohanded.travel(_which)
	else:
		statemachineitem.travel(_which)
	if unequipping:
		set("parameters/Blend2 4/blend_amount", 0.0)
		set("parameters/Blend2 5/blend_amount", 0.0)
	elif !twohanded:
		set("parameters/Blend2 4/blend_amount", 1.0)
	else:
		set("parameters/Blend2 5/blend_amount", 1.0)

func casted(anim: String) -> void:
	playAnim(anim)


func reversed(isit: bool) -> void:
	backwards = isit


func equipped_cast(anim: String) -> void:
	statemachineitem.travel(anim)
