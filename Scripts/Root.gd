extends Node3D

@export var gamestate: gameState

var Menu
var toggled = false

func _ready():
	await initialize(gamestate)
	Menu.set_process(false)
	Menu.hide()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		toggleMenu()

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
	for i in range(gmestate.nodes.size()):
		var temp = gmestate.nodes[i].scene.instantiate()
		self.add_child(temp)
		if gmestate.nodes[i].name == "Menu":
			Menu = temp
	return true
