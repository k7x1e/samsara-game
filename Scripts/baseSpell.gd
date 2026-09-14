extends Node3D

@export var speed: float = 5.0
@export var spdamage: float = 50.0

func initialize() -> void:
	await get_tree().create_timer(5.0).timeout
	self.queue_free()
	#TEMPORARY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func tick():
	pass
	#do whatever, ill prioritize actual casting/using. (WEAPONS WILL WORK THE SAME AS SPELLS)
	# Get the forward direction based on current rotation
	
	# Set velocity and move

func _physics_process(delta: float) -> void:
	var direction = -transform.basis.z
	var velocity = direction * (speed * delta)
	position += velocity

func _on_collision_body_entered(body: Node3D) -> void:
	if body.name != "Player":
		body.damage(spdamage)
		self.queue_free()
