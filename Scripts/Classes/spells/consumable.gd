extends spell

class_name consumable

func cast(caster: Variant):
	#print (curThreads)
	#Globals.Player
	#updateStats()
	if castable and !cooldown_active and quantity > 0 and curThreads == 0:
		quantity -= 1
		castable = false
		var actualNode = spellNode.instantiate()
		Globals.Root.add_child(actualNode)
		actualNode.global_rotation = caster.global_rotation
		actualNode.global_position = caster.global_position
		actualNode.set_owner(Globals.Root)
		actualNode.initialize()
		cooldown_active = true
		cooldown()
		return true
	else:
		return false

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
