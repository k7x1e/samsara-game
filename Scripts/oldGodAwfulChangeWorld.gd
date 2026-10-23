extends Node


func changeWorld(caller: Variant, Targetscene: String, fromMain: bool, fade: bool = true, fromTutorial: bool = false, onLoading: bool = false):
	if fromMain:
		#save current world
		if !onLoading:
			packCurrent()
			if fade:
				fadeOut()
				pause(true)
				await get_tree().create_timer(2).timeout
		$World.queue_free()
		
		var tempTarget = interiors[Targetscene]
		currentInterior = Targetscene
		
		gamestate.newWorld = tempTarget.instantiate()
		self.add_child(gamestate.newWorld)
		gamestate.newWorld.set_owner(self)
		gamestate.newWorldName = get_path_to(gamestate.newWorld)
		
		if fade:
			pause(false)
			fadeIn()
		
		if !onLoading:
			Globals.mainWorldPlayerPos = Globals.Player.global_position
		Globals.Player.global_position = gamestate.newWorld.playerSpawn.global_position
		if gamestate.newWorld.isDungeon:
			musicManager.changePlaylist("dungeon", true)
		elif musicManager.checkInteriorPlaylist(Targetscene):
			musicManager.changePlaylist(Targetscene, true)
	
	else:
		if !gamestate.newWorld:
			gamestate.newWorld = get_node(gamestate.newWorldName)
		var temptemptemp2 = PackedScene.new()
		var tempresult2 = await temptemptemp2.pack(gamestate.newWorld)
		currentInterior = "london"
		
		if fade:
			fadeOut()
			pause(true)
			await get_tree().create_timer(2).timeout
		
		if gamestate.newWorld:
			gamestate.newWorld.queue_free()
		
		gamestate.newWorld = interiors["london"].instantiate()
		self.add_child(gamestate.newWorld)
		gamestate.newWorld.set_owner(self)
		
		if fade:
			pause(false)
			fadeIn()
		
		if fromTutorial:
			#musicManager.changeSong(load("res://sound/music/peste noire menu.mp3"), true)
			notify("Samsonarum", true)
		
		interiors[Targetscene] = temptemptemp2
		Globals.Player.global_position = Globals.mainWorldPlayerPos
		
		musicManager.changePlaylist("City", true)
