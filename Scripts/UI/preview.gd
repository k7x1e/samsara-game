extends VBoxContainer

@onready var slot = $HBoxContainer/itemSlot
@onready var label: RichTextLabel = $Label

@onready var threefuckingdee: Node3D = $HBoxContainer/SubViewportContainer/SubViewport/item/offset
@onready var nomodel: Sprite3D = $HBoxContainer/SubViewportContainer/SubViewport/item/offset/placeholder

@export var curItem: itemClass

var labelString := ""

var temp: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slot.added.connect(added)
	slot.removed.connect(removed)

func set_visibility_layer_recursive(node: Node, layer_mask: int) -> void:
	#shit fart bro...
	if node is VisualInstance3D:
		node.layers = layer_mask
	
	for child in node.get_children():
		set_visibility_layer_recursive(child, layer_mask)

func added():
	curItem = slot.ownItem
	if curItem.model != null:
		nomodel.hide()
		temp = curItem.model.instantiate()
		threefuckingdee.add_child(temp)
		threefuckingdee.global_position = curItem.offset
		set_visibility_layer_recursive(temp, 262144)
		temp.position = Vector3(0,0,0)
		temp.rotation = Vector3(0,0,0)
		temp.set_owner(self)
	else:
		nomodel.show()
	refresh()

func refresh():
	labelString = ""
	for i in curItem.shownStats:
		var temp = get_proper(i, curItem)
		labelString += str("[p]",i,": ", temp, "[/p][br]")
	
	label.text = labelString

func get_proper(i: StringName, aItem: itemClass):
	var result = aItem.get_proper(i)
	match i:
		&"cost":
			result = str((aItem.quantity*aItem.cost), ", (multiplied)")
		&"damage":
			result = str(aItem.get_proper(&"stats[damage]"))
		&"slot":
			result = ""
			for p in aItem.slot:
				result += str(p,", ")
		&"modifier":
			result = aItem.currentModifierName
			result += "[br][br]"
			result += "[b]Affected modifier stats:[/b][br]"
			for b in aItem.affectedStats:
				result += str(strip(b), ": ", aItem.get_proper(b), "(result)[br]")
	return result

func strip(stringname: StringName):
	#taken from itemclass get_proper function
	if "(" in stringname:
		var newP = stringname.left(stringname.find("("))
		var index = stringname.right(stringname.length()-stringname.find("("))
		index = index.right(-1)
		index = index.left(-1)
		return index
	return stringname

func removed():
	label.text = "None Currently Equippeddw"
	nomodel.show()
	if temp != null:
		temp.queue_free()
	pass
