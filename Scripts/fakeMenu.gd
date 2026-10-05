extends Control

@onready var inventory = $Inventory
#@onready var controllerCursor = $controllerCursor

@export var windowSizeSpeed: float = 50
@export var windowSpeed: float = 0.5
@export var speed: float = 1.0

var initializedwindow: bool = false
var shitenpoo
var pos

func activateMenu():
	if Globals.controllerActive:
		pos = Vector2(0,0)
		#controllerCursor.show()
	pass

func hideMenu():
	inventory.inventoryGrid.closeDropDown()

func is_mouse_over_any_child() -> Control:
	var mouse_pos = get_global_mouse_position()
	for child in get_children():
		if child is Control and child.visible and child.get_global_rect().has_point(mouse_pos) and child.name != "TextureRect":
			#print("this one eyes emoji")
			return child
	return null

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
		
		#controllerCursor.position = get_global_mouse_position()
		
		var sizeVector = Input.get_vector("sizeDown","sizeRight","sizeDown","sizeUp")
		var lStick = Input.get_vector("lLeft", "lRight", "lUp", "lDown", 0.1)
		print(lStick.length())
		
		if (lStick.length() > 0.1 or sizeVector.length() > 0.1) and !initializedwindow:
			shitenpoo = is_mouse_over_any_child()
			initializedwindow = true
		elif (lStick.length() == 0 and sizeVector.length() == 0) and initializedwindow:
			shitenpoo = is_mouse_over_any_child()
			initializedwindow = false
		
		if (lStick.length() > 0.1 or sizeVector.length() > 0.1) and shitenpoo != null and !Input.is_action_pressed("evilmenu"):
			print("moving...")
			var amt = lStick *windowSpeed*delta
			shitenpoo.global_position += amt
			#var global_center = shitenpoo.global_position + (shitenpoo.size / 2)
			#Input.warp_mouse(global_center)
			#print(amt)
			
			#print("resizing")
			var sizeAmt = sizeVector * windowSizeSpeed * delta
			shitenpoo.size += sizeAmt

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
