extends HBoxContainer

var dragging = false
var offset = Vector2.ZERO
@onready var window = get_parent().get_parent()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			#print("Clicked")
			dragging = event.pressed
			offset = get_global_mouse_position() - window.global_position
	elif event is InputEventMouseMotion and dragging:
		#print("dragging")
		window.global_position = get_global_mouse_position() - offset
