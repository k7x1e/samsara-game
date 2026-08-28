extends Node3D

@export var activeLeftSpell: spell
@export var activeRightSpell: spell

@export var spells: Array[spell]

# Called when the node enters the scene tree for the first time.
func cast(which: int): #1: left, 2: right, 3,4,5: other bindable spells
	match which:
		1:
			activeLeftSpell.cast(self)
		_:
			#fuck you
			print("fuck you")
