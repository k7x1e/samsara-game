extends Action

class_name castRay

@export var useCustom: bool = false
@export var origin: Vector3 = Vector3.INF #if left unchanged caster position will be used.
@export var target: Vector3 = Vector3.INF #if left unchanged player mouse pos will be used
@export var nodeAtTarget: PackedScene = null

func do(_caster: Node, _casterSpell: spell = null, _args: Array = [], params: Dictionary[StringName, Variant] = {}):
	if !useCustom:
		origin = _caster.global_position
		target = Globals.Player.globalmousePos
		#target.y = origin.y
	
	#print("casting from ", origin, " to ", target)
	
	var direction = (target - origin).normalized()
	target = origin + direction * params["range"]
	
	var space_state = _caster.get_world_3d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters3D.create(origin, target)
	query.collision_mask = 1 #8
	query.hit_from_inside = true
	query.exclude = [_caster.get_rid()]
	var result = space_state.intersect_ray(query)
	if result:
		if nodeAtTarget:
			var temp = nodeAtTarget.instantiate()
			Globals.Root.add_child(temp)
			temp.global_position = result.position
			var basis = Basis.looking_at(result.normal, Vector3.UP)
			temp.global_transform.basis = basis * Basis(Vector3.RIGHT, PI / 2)
		#print("we hit something")
		if result.collider.has_method("damage"):
			result.collider.damage(params["damage"])
