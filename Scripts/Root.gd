extends Node3D

@onready var Menu = $Menu

var toggled = false

func _ready():
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
