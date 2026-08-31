extends Resource

class_name spell

@export var spellNode: PackedScene
@export var cost: int #WONT BE INTEGRATED FOR A WHILE
@export var coolDown: float = 1.0 #IN SECONDS

#implemented
@export var name: String
@export var description: String
@export var Icon: Texture

#for the sake of ui
@export var castable: bool = true
@export var equipped: bool
@export var uiNode: Variant

func cast(caster: Variant):
	#Globals.Player
	if castable:
		var actualNode = spellNode.instantiate()
		Globals.Root.add_child(actualNode)
		actualNode.global_rotation = caster.global_rotation
		actualNode.global_position = caster.global_position
		actualNode.set_owner(Globals.Player)
		cooldown()
		return true
	else:
		return false

func cooldown():
	castable = false
	uiNode.dim.show()
	uiNode.timer_active = true
	uiNode.timerNode.start(coolDown)
	uiNode.dim.max_value = uiNode.timerNode.wait_time
	await Engine.get_main_loop().create_timer(coolDown).timeout
	uiNode.dim.hide()
	castable = true
