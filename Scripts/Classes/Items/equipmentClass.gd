extends itemClass

class_name equipmentItem

@export var slot: String

@export var node: PackedScene

@export var associatedAnimation: String = "holdForward"
@export var attachmentPoint: String = "Bone.008.R"

@export var curNode: Variant

func initialize():
	var temp = node.instantiate()
	Globals.Player.skeleton.add_child(temp)
	temp.set_owner(Globals.Player)
	if temp.has_method("initialize"):
		temp.initialize()
	temp.bone_name = attachmentPoint
	curNode = temp
