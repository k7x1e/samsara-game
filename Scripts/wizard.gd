extends Node3D

signal casted(anim: String)

@export var spells: Array[spell] = [placeholderSpell,placeholderSpell,placeholderSpell,placeholderSpell,placeholderSpell]

@export var placeholderSpell: spell

#check for input
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("LeftClick"):
		cast(0)
	if Input.is_action_just_pressed("rightClick"):
		cast(1)
	if Input.is_action_just_pressed("spell3"):
		cast(2)
	if Input.is_action_just_pressed("spell4"):
		cast(3)
	if Input.is_action_pressed("spell5"):
		cast(4)

func _ready():
	Globals.wizard = self
	await get_tree().create_timer(0.01).timeout
	Globals.spellMaster.updateSpells(spells)

# Called when the node enters the scene tree for the first time.
func cast(which: int): #1: left, 2: right, 3,4,5: other bindable spells
	if spells[which].castable and spells[which].checkEquipment():
		if spells[which].hasAnimation:
			casted.emit(spells[which].animation)
			await get_tree().create_timer(0.34).timeout
		if which <= 4:
			var _result = spells[which].cast(self)
	elif !spells[which].checkEquipment():
		fail("Hands full")

func fail(reason: String = " "):
	var stringpoop = "Failed casting spell."
	if reason != " ":
		stringpoop += str(" ", reason)
	Globals.Player.notify(stringpoop)

func remove(which: int, replacement: bool):
	if replacement:
		var spellToRemove: spell = spells[which]
		var itemToUnequip: itemClass = Globals.inventory.getFromUID(spellToRemove.parentItemUID)
		var NodeToUnequip: Node = Globals.inventory.GetNode(itemToUnequip)
		itemToUnequip.equipped = false
		Globals.inventory.unequip(NodeToUnequip)
	#for some odd reason it was set to duplicate the placeholder which was causing these bugs
	spells[which] = placeholderSpell

func savespells() -> Array[int]:
	var result: Array[int]
	for i in spells:
		result.append(i.parentItemUID)
	return result

func loadspells(which: Array[int]):
	for i in which:
		pass
