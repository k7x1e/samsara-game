extends Control

@onready var inventory = $Inventory
@onready var controllerCursor = $controllerCursor

@export var speed: float = 1.0

var pos

func activateMenu():
	if Globals.controllerActive:
		pos = Vector2(0,0)
		controllerCursor.show()
	else:
		controllerCursor.hide()
	pass

func hideMenu():
	inventory.inventoryGrid.closeDropDown()

func _process(delta: float) -> void:
	if Globals.controllerActive:
#		var input_dir := Input.get_vector("rLeft", "rRight", "rUp", "rDown")
#		var direction := (Vector2(input_dir.x,input_dir.y)).normalized()
#		print(direction)
#		controllerCursor.position += direction * speed * delta
		var stick = Input.get_vector("rLeft", "rRight", "rUp", "rDown")
		if stick.length() > 0.1:
			var new_pos = pos + stick * speed * delta
			pos = new_pos
			Input.warp_mouse(new_pos)

		if Input.is_action_just_pressed("contLclick"):  # or a joypad button
			simulate_mouse_press(MOUSE_BUTTON_LEFT, true)
		if Input.is_action_just_pressed("contRclick"):
			simulate_mouse_press(MOUSE_BUTTON_RIGHT, true)

#func _input(event: InputEvent) -> void:
#	if Globals.controllerActive:
#		if event.is_action_pressed("contLclick"):
#			simulate_mouse_press(MOUSE_BUTTON_LEFT, true)
#		if event.is_action_pressed("contRclick"):
#			simulate_mouse_press(MOUSE_BUTTON_RIGHT, true)
#		if event.is_action_released("contLclick"):
#			simulate_mouse_press(MOUSE_BUTTON_LEFT, false)
#		if event.is_action_released("contLclick"):
#			simulate_mouse_press(MOUSE_BUTTON_RIGHT, false)

func simulate_mouse_press(button: MouseButton = MOUSE_BUTTON_LEFT, pressed: bool = true) -> void:
	var event = InputEventMouseButton.new()
	event.button_index = button
	event.pressed = pressed
	event.position = pos  # or any Vector2 you want
	event.global_position = event.position
	Input.parse_input_event(event)
	
	# Release (this is what actually triggers the default "pressed" signal)
	var release = InputEventMouseButton.new()
	release.button_index = button
	release.pressed = false
	release.position = pos
	release.global_position = pos
	Input.parse_input_event(release)
