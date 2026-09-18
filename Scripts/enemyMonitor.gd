extends Node3D

@onready var actor = $".."
@onready var sfx = $sfx

@export var sounds: Dictionary[String, AudioStream]

func initialize():
	actor.behaviour.playerFoundAlert.connect(playsfx.bind("found"))
	actor.behaviour.attacking.connect(playsfx.bind("attack"))
	actor.behaviour.damaged.connect(playsfx.bind("damage"))

func playsfx(which:String):
	print("playing: ", which)
	sfx.stream = sounds[which]
	sfx.play()
