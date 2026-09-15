extends Control

var dragging = false
var offset = Vector2.ZERO
@onready var window = get_parent() # Reference to the PopupPanel

@export var windowType: String
@export var maxX: float
@export var maxY: float

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and !dragging:
			dragging = true
	if Input.is_action_pressed("LeftClick") and dragging:
		offset = get_global_mouse_position() - window.global_position
		#print("dragging")
		#check if it excedes max size
		var maxVector = Vector2(maxX,maxY)
		if offset.x <= maxVector.x and offset.y <= maxVector.y:
			window.size = offset
		elif !offset.x <= maxVector.x and offset.y <= maxVector.y:
			window.size.y = offset.y
		else:
			window.size.x = offset.x
		window.updateWindow()
	if Input.is_action_just_released("LeftClick"):
		dragging = false
