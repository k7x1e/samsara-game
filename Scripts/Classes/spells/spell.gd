extends Resource

class_name spell

@export var spellNode: PackedScene
@export var cost: int
@export var coolDown: float = 1.0 #IN SECONDS

#implemented
@export var name: String
@export var description: String
@export var Icon: Texture

#for the sake of ui
@export var castable: bool = true
@export var cooldown_active: bool = false
@export var equipped: bool
@export var uiNode: Variant
@export var spellTimer: Variant
@export var parentItemUID: int

func cast(caster: Variant):
	#Globals.Player
	updateStats()
	if castable and Globals.Player.mana >= cost:
		var actualNode = spellNode.instantiate()
		Globals.Root.add_child(actualNode)
		actualNode.global_rotation = caster.global_rotation
		actualNode.global_position = caster.global_position
		actualNode.set_owner(Globals.Root)
		actualNode.initialize()
		Globals.Player.mana -= cost
		cooldown_active = true
		cooldown()
		return true
	else:
		return false

func updateStats():
	self.coolDown -= Globals.stats.stats[1] * 0.25
	self.cost -= int(Globals.stats.stats[1] / 10) * 25

func cooldown():
	spellTimer = Timer.new()
	Globals.spellMaster.add_child(spellTimer)
	castable = false
	uiNode.dim.show()
	uiNode.timer_active = true
	uiNode.timerNode = spellTimer
	spellTimer.start(coolDown)
	uiNode.dim.max_value = spellTimer.wait_time
	await Engine.get_main_loop().create_timer(coolDown).timeout
	cooldown_active = false
	uiNode.dim.hide()
	castable = true
