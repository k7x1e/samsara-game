extends spell

class_name equipmentSpell

@export var slot: int = 0

@export var spellClass: Action

@export var anim: String

@export var damage: float = 50
@export var baseDamage: float = 50

func checkEquipment() -> bool:
	#overwritten due to it being part of equipment
	return true

func cast(caster: Variant):
	updateStats()
	if castable and !cooldown_active and curThreads == 0:
		updateStats()
		castable = false
		#this is going to happen in the individual spells when it does damage
		#Globals.stats.experience(1)
		
		doSpell()
		
		#print(Globals.Player.mana)
		cooldown_active = true
		cooldown()
		Globals.stats.experience(4)
		return "true"
	else:
		return "falsesd"

func doSpell(): ##only for compatability
	spellClass.do(Globals.Player, self)

func updateStats():
	if statted:
		self.coolDown = basecoolDown - (int(Globals.stats.stats[4] / 5) * 0.25)
		#print (coolDown, basecoolDown)
		self.damage = baseDamage + (Globals.stats.stats[4] * 5)
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
