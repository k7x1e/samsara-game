extends Node3D

@export var gamestate: gameState

#@onready var preloadshitfuck = load("user://Save/saves.sav")

@onready var musicManager = $musicManager

@export var tickrate: float = 20.0 ##per second
@export var updaterate: float = 2.5 ##per 10 seconds

var tickdelay:float
var ticktick: float = 0.0

var updatedelay: float
var updatetick: float = 0.0

var Menu
var dialogueMenu
var pauseMenu

@export_enum("none", "dialogue", "menu", "paused", "specific") var currentMenu: int

#var newWorld
var newWorldCaller ##dont know what this is still doing here

var backupGlobals

@export var mainWorldNode: PackedScene

var isPaused = false
@export var interiors: Dictionary[String, PackedScene]
@export var currentInterior: String = "london"

@export var prophecyNotif: Node
@export var fadeAnim: AnimationPlayer

@onready var mNotif = preload("res://Scenes/menacingNotif.tscn")
@onready var songNotif = $fading/NowPlaying

func nowPlaying(songName: String, artistAlbum: String):
	songNotif.songName = songName
	songNotif.artistAlbum = artistAlbum
	songNotif.initialize()

func notify(what: String, useSound: bool = false):
	var tempP = mNotif.instantiate()
	$fading.add_child(tempP)
	tempP.toShow = what
	tempP.sound = useSound
	tempP.initialize()

func fadeIn():
	fadeAnim.play("fadein")

func fadeOut():
	fadeAnim.play("fadeout")

func packCurrent():
	if !gamestate.newWorld:
			gamestate.newWorld = get_node(gamestate.newWorldName)
	
	var tempworld
	if currentInterior == "london":
		tempworld = $World
	else:
		tempworld = gamestate.newWorld
	
	var temptemptemp = PackedScene.new()
	var tempresult = await temptemptemp.pack(tempworld)
	if tempresult == OK:
		interiors[currentInterior] = temptemptemp

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
		newWorldCaller = caller
		
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
	Globals.minimap.initialize()

func _ready():
	Input.mouse_mode =Input.MOUSE_MODE_CONFINED
	fadeIn()
	Globals.gamestate = Globals.gamestate.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	gamestate = Globals.gamestate
	updatedelay = 10.0 / updaterate
	tickdelay = 1.0 / tickrate
	Globals.Root = self
	#if preloadshitfuck:
	#	gamestate = preloadshitfuck
	gamestate.rootNode = self
	await gamestate.initialize()
	gamestate.initialized = true
	dialogueMenu = Globals.dialogueMenu

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseGame()
	if Input.is_action_just_pressed("menu"):
		toggleMenu()
	ticktick += _delta
	updatetick += _delta
	if ticktick >= tickdelay and !isPaused:
		#print("ticking")
		signaltick()
		ticktick = 0.0
	if updatetick >= updatedelay and !isPaused:
		signalupdate()
		updatetick = 0.0

func signaltick():
	var tickable = get_tree().get_nodes_in_group("ticked")
	for object in tickable:
		if object.process_mode != PROCESS_MODE_DISABLED:
			object.tick()
	
func signalupdate():
	var updatable = get_tree().get_nodes_in_group("updatable")
	for object in updatable:
		object.update()

func signalinit():
	var initable = get_tree().get_nodes_in_group("init")
	for object in initable:
		object.initialize()

func startDialogue(theconvo: conversation):
	theconvo.updateQuest()
	Globals.dialogueMenu.index = 0
	Globals.dialogueMenu.dialogueToUse = theconvo
	toggleDialogue()
	Globals.dialogueMenu.update()

func stopDialogue():
	toggleDialogue()

func toggleDialogue():
	if currentMenu == 0:
		pause(true)
		Globals.dialogueMenu.set_process(true)
		Globals.dialogueMenu.get_parent().show()
		currentMenu = 1
	elif currentMenu == 1:
		pause(false)
		Globals.dialogueMenu.set_process(false)
		Globals.dialogueMenu.get_parent().hide()
		currentMenu = 0

func pauseGame():
	if !pauseMenu:
		pauseMenu = get_node("PauseMenu")
	print("pausing")
	if currentMenu == 0:
		pause(true)
		pauseMenu.set_process(true)
		pauseMenu.show()
		currentMenu = 3
	elif currentMenu == 3:
		pause(false)
		pauseMenu.set_process(false)
		pauseMenu.hide()
		currentMenu = 0

func toggleMenu():
	if currentMenu == 0:
		Menu.set_process(true)
		Menu.show()
		Menu.activateMenu()
		pause(true)
		currentMenu = 2
	elif currentMenu == 2:
		Menu.hideMenu()
		Menu.hide()
		Menu.set_process(false)
		pause(false)
		currentMenu = 0


#straight up stealing code from dustrialis, gng
func pause(Paused: bool):
	var pausable = get_tree().get_nodes_in_group("Pausable")
	if Paused:
		isPaused = true
		for object in pausable:
			object.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		isPaused = false
		for object in pausable:
			object.process_mode = Node.PROCESS_MODE_INHERIT

func triggerTutorial():
	changeWorld(self,"tutorial", true, false)

func initialize(gmestate: gameState, sendinit: bool = true):
	for i in range(gmestate.initnodes.size()):
		var scene = load(gmestate.initnodes[i].scene)
		var temp = scene.instantiate()
		self.add_child(temp)
		temp.set_owner(self)
		if gmestate.initnodes[i].to_be_placed:
			temp.global_position = gmestate.initnodes[i].position
		if gmestate.initnodes[i].name == "Menu":
			Menu = temp.menu
		if gmestate.initnodes[i].name == "Player":
			temp.initialize()
	if sendinit:
		signalinit()
	return true

func initalizeSave():
	initialize(Globals.gamestate, false)
	var lsave = Globals.saveToLoad
	
	for obj in get_tree().get_nodes_in_group("Persistent"):
		obj.queue_free()
	Globals.setGlobals(lsave.globals_data)
	pause(true)
	await get_tree().process_frame
	pause(false)
	#stick special stuff here
	Globals.setGlobals(lsave.globals_data)
	for data in lsave.nodes:
		var scene = load(data.scene)
		var instance = scene.instantiate()
		instance.name = data.name
		add_child(instance)
		instance.set_owner(self)
		#print(data.name)
		if data.to_be_placed:
			instance.global_position = data.position
			instance.global_rotation = data.rotation
		if instance.has_method("load_save_data"):
			instance.load_save_data(data.extra_data)
		if instance.name == "Player":
			instance.global_position = data.position + Vector3(0,1,0)
			instance.initialize()
	interiors = lsave.interiors
	if lsave.currentInterior != "london":
		changeWorld(self,lsave.currentInterior,true,false,false,true)
	signalinit()


func save(rNode: Node, name: String):
	#print(name)
	var path = str("user://saves/",name,".res")
	#print(path)
	
	var save = SaveGame.new()
	
	packCurrent()
	
	#set nodes
	var nodes: Array[nodePreset]
	var persistent = get_tree().get_nodes_in_group("Persistent")
	for object in persistent:
		var temp = nodePreset.new()
		temp.name = object.name
		temp.scene = object.scene_file_path   # if it was instanced from a scene
		# or keep a PackedScene reference only if the scene is a clean, self-contained .tscn
		
		if object is Node3D:
			temp.position = object.global_position
			temp.rotation = object.global_rotation
			temp.to_be_placed = true
		
		# Collect only the data you care about
		if object.has_method("get_save_data"):
			temp.extra_data = object.get_save_data()
		
		if "isGlobal" in object:
			temp.inGlobals = object.isGlobal
			temp.globalsName = object.globalName
		nodes.append(temp.duplicate(true))
	save.nodes = nodes
	
	save.globals_data = Globals.getGlobals()
	gamestate.add_save(save, name)
	save.Description = str("Last completed quest: ", Globals.lastCompletedQuestName)
	save.globals_data = Globals.getGlobals()
	save.globals_data["gamestate"].saves.clear()
	save.timestamp = Time.get_datetime_string_from_system()
	save.interiors=interiors.duplicate(true)
	save.currentInterior = currentInterior
	
	var err = ResourceSaver.save(save, path)
	if err != OK:
		push_error("Failed to save: %s" % error_string(err))

func loadSave(_which: String):
	var save = await gamestate.get_save(_which)
	#print(save)
	
	Globals.saveToLoad = save
	Globals.loadSave = true
	
	#load into the loadin screen
	var screen = load("res://Scenes/loading_screen.tscn")
	get_tree().change_scene_to_packed(screen)

func death():
	Globals.Player.hide()
	$fading/monochrome.show()
	#var oldCamPos = Globals.Player.camera.global_position
	#Globals.Player.global_position = $playerDeathPos.global_position
	#Globals.Player.camera.global_position = oldCamPos
	#Globals.Player.set_process(false)
	pause(true)
	musicManager.changePlaylist("Death", true)
