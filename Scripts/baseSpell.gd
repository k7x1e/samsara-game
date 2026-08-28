extends Node3D

@export var speed: float = 5.0

func _ready() -> void:
	print ("hej")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#do whatever, ill prioritize actual casting/using. (WEAPONS WILL WORK THE SAME AS SPELLS)
	# Get the forward direction based on current rotation
	var direction = -transform.basis.z
	
	# Set velocity and move
	var velocity = direction * speed
	position += velocity
