extends Node3D

@export var activeLeftSpell: spell
@export var activeRightSpell: spell

@export var spells: Array[spell] = []

#check for input
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("LeftClick"):
		cast(1)
	if Input.is_action_just_pressed("rightClick"):
		cast(2)
	if Input.is_action_just_pressed("spell3"):
		cast(3)
	if Input.is_action_just_pressed("spell4"):
		cast(4)
	if Input.is_action_just_pressed("spell5"):
		cast(5)

func _ready():
	activeLeftSpell = spells[0]
	activeRightSpell = spells[1]
	await get_tree().create_timer(0.01).timeout
	Globals.spellMaster.updateSpells(spells)

# Called when the node enters the scene tree for the first time.
func cast(which: int): #1: left, 2: right, 3,4,5: other bindable spells
	match which:
		1:
			activeLeftSpell.cast(self)
		_:
			#fuck you
			print("fuck you")
