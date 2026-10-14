extends itemClass

class_name equipmentItem

@export var slot: String

@export var node: PackedScene

@export var associatedAnimation: String = "holdForward"
@export var attachmentPoint: String = "Bone.008.R"

@export var curNode: Variant

@export var hasSpells: bool = false
@export var equipmentSpells: Array[equipmentSpell]

func initializeItem():
	var temp = node.instantiate()
	Globals.Player.skeleton.add_child(temp)
	temp.set_owner(Globals.Player)
	if temp.has_method("initialize"):
		temp.initialize()
	temp.bone_name = attachmentPoint
	curNode = temp
	
	if hasSpells:
		for which in equipmentSpells:
			if Globals.wizard.spells[which.slot] != Globals.wizard.placeholderSpell and Globals.wizard.spells[which.slot] != which:
				print("replacing")
				Globals.wizard.remove(which.slot, true)
			Globals.wizard.spells[which.slot] = which
		Globals.spellMaster.updateSpells(Globals.wizard.spells)

func unequip():
	if hasSpells:
		for which in equipmentSpells:
			Globals.wizard.spells[which.slot] = Globals.wizard.placeholderSpell
		Globals.spellMaster.updateSpells(Globals.wizard.spells)
