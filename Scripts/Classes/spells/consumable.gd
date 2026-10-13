extends spell

class_name consumable

@export var hasNode: bool = true

func cast(_caster: Variant, _fromInventory: bool = false):
	#print (curThreads)
	#Globals.Player
	#updateStats()
	if castable and !cooldown_active and quantity > 0 and curThreads == 0:
		quantity -= 1
		castable = false
		action.do(Globals.Player, self)
		hasNode = !_fromInventory
		cooldown_active = true
		cooldown()
		return true
	else:
		return false

func cooldown():
	curThreads += 1
	spellTimer = Timer.new()
	Globals.spellMaster.add_child(spellTimer)
	if hasNode:
		uiNode.dim.show()
		uiNode.timer_active = true
		uiNode.timerNode = spellTimer
		uiNode.dim.max_value = spellTimer.wait_time
	spellTimer.start(coolDown)
	await Engine.get_main_loop().create_timer(coolDown).timeout
	curThreads -= 1
	cooldown_active = false
	if hasNode:
		uiNode.dim.hide()
	castable = true
