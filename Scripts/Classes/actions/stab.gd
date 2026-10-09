extends Action

class_name stab

@export var stabrange: float

func do(caster: Node, casterSpell: equipmentSpell = null):
	var space_state = caster.get_world_3d().direct_space_state
	# use global coordinates, not local to node
	
	var origin = caster.global_position
	var direction = -caster.wizard.global_transform.basis.z.normalized()
	var target = origin + direction * stabrange
	
	var query = PhysicsRayQueryParameters3D.create(origin, target)
	query.set_collision_mask(8)
	query.exclude = [caster]
	query.collide_with_bodies = true
	query.collide_with_areas = true
	
	var result = space_state.intersect_ray(query)
	if result:
		print(result.collider.name)
		if result.collider.name != "Player" and result.collider.has_method("damage"):
			result.collider.damage(casterSpell.damage)
		elif result.collider.name == "Player":
			caster.notify("stabbing yourself")
	else:
		print("not hitting")
	return false
