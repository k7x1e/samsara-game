extends Resource

class_name spell

@export var spellNode: PackedScene
@export var cost: float #WONT BE INTEGRATED FOR A WHILE

#not implemented yet
@export var name: String
@export var description: String
@export var Icon: Texture

#for the sake of ui
@export var castable: bool
@export var equipped: bool
@export var uiNode: Variant

func cast(caster: Variant):
	#Globals.Player
	var actualNode = spellNode.instantiate()
	Globals.Root.add_child(actualNode)
	actualNode.global_rotation = caster.global_rotation
	actualNode.global_position = caster.global_position
	actualNode.set_owner(Globals.Player)
