extends AnimationTree

var statemachine: AnimationNodeStateMachinePlayback

func _ready() -> void:
	statemachine = get("parameters/playback")

func moving(fact: bool) -> void:
	print("am i walking? ", fact)
	match fact:
		true:
			statemachine.travel("walk_002")
		false:
			statemachine.travel("rest")
