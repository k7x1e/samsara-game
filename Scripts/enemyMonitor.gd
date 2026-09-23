extends Node3D

@onready var actor = $".."
@onready var sfx = $sfx

@export var animTree: AnimationTree
@export var sounds: Dictionary[String, AudioStream]

func initialize():
	actor.behaviour.playerFoundAlert.connect(playsfx.bind("found"))
	actor.behaviour.attacking.connect(playsfx.bind("attack"))
	actor.behaviour.damaged.connect(playsfx.bind("damage"))
	updateAnim(false)

func playsfx(which:String):
	#print("playing: ", which)
	sfx.stream = sounds[which]
	sfx.play()

func playAnim(what:String):
	match what:
		"poop":
			pass

func updateAnim(p: bool):
	if p:
		animTree.set("parameters/Blend2 2/blend_amount", 0.0)
	else:
		animTree.set("parameters/Blend2 2/blend_amount", 1.0)

func moving(fact: bool) -> void:
	updateAnim(fact)
