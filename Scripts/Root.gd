extends Node3D

@export var gamestate: gameState

var Menu
var toggled = false

func _ready():
	gamestate.rootNode = self
	await gamestate.initialize()
	gamestate.initialized = true

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		toggleMenu()
	if Input.is_action_just_pressed("ui_accept"):
		save()
	if Input.is_action_just_pressed("evilDebugKey"):
		loadSave(2)

func toggleMenu():
	if !toggled:
		Menu.set_process(true)
		Menu.show()
		Menu.activateMenu()
		pause(true)
	else:
		Menu.hideMenu()
		Menu.hide()
		Menu.set_process(false)
		pause(false)
	toggled = !toggled

#straight up stealing code from dustrialis, gng
func pause(paused: bool):
	var pausable = get_tree().get_nodes_in_group("Pausable")
	if paused:
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
		if gmestate.initnodes[i].name == "Menu":
			Menu = temp
	return true

func save():
	var scene = PackedScene.new()
	var result = scene.pack(get_tree().get_current_scene())
	ResourceSaver.save(scene, "res://last_save.tscn")
	
	if result == OK:
		# Save the packed scene to disk (.tscn or .res)
		print("saved")
		gamestate.add_save(scene.duplicate(true))
	scene = 0
	result = 0
	

func loadSave(which: int):
	#were just gonna assume it means the last
	var lastSave = gamestate.get_last_save()
	get_tree().change_scene_to_packed(lastSave)
