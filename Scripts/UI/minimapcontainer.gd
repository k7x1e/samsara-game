extends SubViewportContainer

@onready var camera = $miniMapViewport/Camera3D

@export var trackpad_zoom_speed: float = 0.05
@export var zoom_step: float = 5
@export var min_zoom: float = 5
@export var max_zoom: float = 400
@export var pan_speed: float = 1.0

var dragging: bool = false

func update():
	var temp = Globals.Player.global_position
	camera.position = Vector3(temp.x,16,temp.z)

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

func _input(event: InputEvent) -> void:
	if self.visible:
		if event.is_action_pressed("scrollDown"):
			_zoom(zoom_step)
			accept_event()
		elif event.is_action_pressed("scrollUp"):
			_zoom(-zoom_step)
			accept_event()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			accept_event()
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom(-zoom_step)
			accept_event()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom(zoom_step)
			accept_event()
	
	elif event is InputEventMouseMotion and dragging:
		# Negative because we move the camera opposite to the drag
		var new = event.relative * pan_speed * (camera.size/5)
		camera.position -= Vector3(new.x,0,new.y)
		#print(camera.position)
		accept_event()
	
	elif event is InputEventPanGesture:
		# Vertical scroll controls zoom (most natural for maps)
		_zoom(-event.delta.y * trackpad_zoom_speed)
		accept_event()

func _zoom(amount: float) -> void:
	var new_zoom: float = camera.size + amount
	new_zoom = clamp(new_zoom, min_zoom, max_zoom)
	camera.size = new_zoom
