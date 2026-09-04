extends Node3D

@export var gamestate: gameState

@onready var preloadshitfuck = load("user://Save/saves.sav")

var Menu
var toggled = false
var paused = false
var inDialogue = false
var dialogueMenu
var pauseMenu

func _ready():
	Globals.Root = self
	if preloadshitfuck:
		gamestate = preloadshitfuck
	gamestate.rootNode = self
	await gamestate.initialize()
	gamestate.initialized = true
	dialogueMenu = Globals.dialogueMenu

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseGame()
	if Input.is_action_just_pressed("menu"):
		toggleMenu()
	if Input.is_action_just_pressed("ui_accept"):
		save()
	if Input.is_action_just_pressed("evilDebugKey"):
		loadSave(2)

func startDialogue(theconvo: conversation):
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
		for object in pausable:
			object.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		for object in pausable:
			object.process_mode = Node.PROCESS_MODE_INHERIT

func initialize(gmestate: gameState):
	for i in range(gmestate.initnodes.size()):
		var temp = gmestate.initnodes[i].scene.instantiate()
		self.add_child(temp)
		temp.set_owner(self)
		if gmestate.initnodes[i].to_be_placed:
			temp.global_position = gmestate.initnodes[i].position
		if gmestate.initnodes[i].name == "Menu":
			Menu = temp.menu
	return true

func save():
	# REDO
	var scene = PackedScene.new()
	var result = scene.pack(get_tree().get_current_scene())
	ResourceSaver.save(scene, "res://last_save.tscn", ResourceSaver.FLAG_BUNDLE_RESOURCES)
	
	if result == OK:
		# Save the packed scene to disk (.tscn or .res)
		print("saved")
		gamestate.add_save(scene.duplicate(true))
	scene = 0
	result = 0
	

func loadSave(_which: int):
	#were just gonna assume it means the last
	var lastSave = gamestate.get_last_save()
	get_tree().change_scene_to_packed(lastSave)
