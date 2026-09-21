extends Node3D

@export var gamestate: gameState

#@onready var preloadshitfuck = load("user://Save/saves.sav")

@export var tickrate: float = 20.0 ##per second
@export var updaterate: float = 2.5 ##per 10 seconds

var tickdelay:float
var ticktick: float = 0.0

var updatedelay: float
var updatetick: float = 0.0

var Menu
var toggled = false
var paused = false
var inDialogue = false
var dialogueMenu
var pauseMenu

var newWorld
var newWorldCaller ##dont know what this is still doing here

var backupGlobals

@export var mainWorldNode: PackedScene
var mainWorldPlayerPos

var isPaused = false
@export var interiors: Dictionary[String, PackedScene]

func changeWorld(caller: Variant, Targetscene: String, fromMain: bool):
	if fromMain:
		#save current world
		var tempworld = $World
		var temptemptemp = PackedScene.new()
		var tempresult = await temptemptemp.pack(tempworld)
		if tempresult == OK:
			mainWorldNode = temptemptemp
			mainWorldPlayerPos = global_position
		
		tempworld.queue_free()
		newWorldCaller = caller
		
		var tempTarget = interiors[Targetscene]
		
		newWorld = tempTarget.instantiate()
		self.add_child(newWorld)
		newWorld.set_owner(self)
		
		mainWorldPlayerPos = Globals.Player.global_position
		Globals.Player.global_position = newWorld.playerSpawn.global_position
	
	else:
		var temptemptemp2 = PackedScene.new()
		var tempresult2 = await temptemptemp2.pack(newWorld)
		
		newWorld.queue_free()
		
		newWorld = mainWorldNode.instantiate()
		self.add_child(newWorld)
		newWorld.set_owner(self)
		
		interiors[Targetscene] = temptemptemp2
		Globals.Player.global_position = mainWorldPlayerPos

func _ready():
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
	if !paused and !toggled and !inDialogue:
		pause(true)
		Globals.dialogueMenu.set_process(true)
		Globals.dialogueMenu.get_parent().show()
		inDialogue = true
	elif !toggled and !paused:
		pause(false)
		Globals.dialogueMenu.set_process(false)
		Globals.dialogueMenu.get_parent().hide()
		inDialogue = false

func pauseGame():
	if !pauseMenu:
		pauseMenu = get_node("PauseMenu")
	print("pausing")
	if !paused and !toggled and !inDialogue:
		pause(true)
		pauseMenu.set_process(true)
		pauseMenu.show()
		paused = true
	elif !toggled and !inDialogue:
		pause(false)
		pauseMenu.set_process(false)
		pauseMenu.hide()
		paused = false

func toggleMenu():
	if !toggled and !paused and !inDialogue:
		Menu.set_process(true)
		Menu.show()
		Menu.activateMenu()
		pause(true)
		toggled = !toggled
	elif !paused and !inDialogue:
		Menu.hideMenu()
		Menu.hide()
		Menu.set_process(false)
		pause(false)
		toggled = !toggled


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
		print(data.name)
		if data.to_be_placed:
			instance.global_position = data.position
			instance.global_rotation = data.rotation
		if instance.has_method("load_save_data"):
			instance.load_save_data(data.extra_data)
		if instance.name == "Player":
			instance.global_position = data.position + Vector3(0,1,0)
			instance.initialize()
	signalinit()


func save(rNode: Node, name: String):
	print(name)
	var path = str("user://saves/",name,".res")
	print(path)
	
	var save = SaveGame.new()
	
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
		nodes.append(temp)
	save.nodes = nodes
	
	save.globals_data = Globals.getGlobals()
	gamestate.add_save(save, name)
	save.globals_data = Globals.getGlobals()
	save.timestamp = Time.get_date_string_from_system()
	
	var err = ResourceSaver.save(save, path)
	if err != OK:
		push_error("Failed to save: %s" % error_string(err))

func loadSave(_which: String):
	var save = await gamestate.get_save(_which)
	print(save)
	
	Globals.saveToLoad = save
	Globals.loadSave = true
	
	#load into the loadin screen
	var screen = load("res://Scenes/loading_screen.tscn")
	get_tree().change_scene_to_packed(screen)

func death():
	pause(true)
