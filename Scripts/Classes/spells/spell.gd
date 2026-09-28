extends Resource

class_name spell

signal quantity_changed()

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

@export var limited: bool = false
@export var statted: bool = true
@export var isPlaceHolder: bool = false
@export var quantity: int:
	set(value):
		quantity = value
		emit_signal('quantity_changed')

@export var animation: String = "boringCast"
@export var hasAnimation: bool = true

@export var requiredSlots: Array[String] = ["armLeft", "armRight"]

@export var requiredLevel: int = 0

var curThreads: int = 0

func checkEquipment() -> bool:
	var tempSpells = Globals.Player.equipment.checkSlots(requiredSlots)
	match typeof(tempSpells):
		TYPE_ARRAY:
			for i in tempSpells:
				if !i:
					return false
		TYPE_BOOL:
			if !tempSpells:
				return false
	return true

func cast(caster: Variant):
	#print (curThreads)
	#Globals.Player
	updateStats()
	if castable and !cooldown_active and Globals.Player.mana >= cost and curThreads == 0:
		if checkEquipment():
			castable = false
			#this is going to happen in the individual spells when it does damage
			#Globals.stats.experience(1)
			var actualNode = spellNode.instantiate()
			Globals.Root.add_child(actualNode)
			actualNode.global_rotation = caster.global_rotation
			actualNode.global_position = caster.global_position
			actualNode.set_owner(Globals.Root)
			actualNode.initialize()
			Globals.Player.mana -= cost
			#print(Globals.Player.mana)
			cooldown_active = true
			cooldown()
			return "true"
		else:
			return "hands"
	else:
		return "falsesd"

func updateStats():
	if statted:
		self.coolDown = basecoolDown - (int(Globals.stats.stats[1] / 5) * 0.25)
		#print (coolDown, basecoolDown)
		self.cost = basecost - (int(Globals.stats.stats[1] / 10) * 25)
		#print(cost, basecost)
	#no matter if its statted the hand change will apply
	if requiredSlots == ["armLeft", "armRight"] and Globals.stats.stats[0] >= Globals.stats.spellHandThreshhold:
		requiredSlots = ["armLeft"]

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
