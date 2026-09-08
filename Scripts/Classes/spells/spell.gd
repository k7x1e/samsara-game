extends Resource

class_name spell

@export var spellNode: PackedScene
@export var basecost: int
@export var cost: int
@export var basecoolDown: float = 1.0 #IN SECONDS
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

var curThreads: int = 0

func cast(caster: Variant):
	#print (curThreads)
	#Globals.Player
	updateStats()
	if castable and !cooldown_active and Globals.Player.mana >= cost and curThreads == 0:
		castable = false
		var actualNode = spellNode.instantiate()
		Globals.Root.add_child(actualNode)
		actualNode.global_rotation = caster.global_rotation
		actualNode.global_position = caster.global_position
		actualNode.set_owner(Globals.Root)
		actualNode.initialize()
		Globals.Player.mana -= cost
		print(Globals.Player.mana)
		cooldown_active = true
		cooldown()
		return true
	else:
		return false

func updateStats():
	self.coolDown = basecoolDown - (int(Globals.stats.stats[1] / 5) * 0.25)
	#print (coolDown, basecoolDown)
	self.cost = basecost - (int(Globals.stats.stats[1] / 10) * 25)
	#print(cost, basecost)

func cooldown():
	curThreads += 1
	spellTimer = Timer.new()
	Globals.spellMaster.add_child(spellTimer)
	uiNode.dim.show()
	uiNode.timer_active = true
	uiNode.timerNode = spellTimer
	spellTimer.start(coolDown)
	uiNode.dim.max_value = spellTimer.wait_time
	await Engine.get_main_loop().create_timer(coolDown).timeout
	curThreads -= 1
	cooldown_active = false
	uiNode.dim.hide()
	castable = true
