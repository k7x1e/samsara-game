extends Resource

class_name itemClass

signal quantity_changed()
signal removed

#THIS IS IMPORTANT EVERY SINGLE ITEM HAS TO BE UNIQUE OTHERWISE IT WILL INTRODUCE INSANE GLITCHES
@export var itemID: int #mostly for tracking purposes
@export var UID: int = 0 #AT NO POINT CAN THIS MATCH ANY OTHER ID EVER USED

var _name: String
@export var name: String
@export var description: String
@export var icon: Texture

@export_enum("Item", "Spell", "Equipment", "Consumable", "Book", "Currency") var Type: int ## item, spell, equipment, consumable, book, currency
@export var isSpell: bool = false
@export_enum("None", "Ranged", "Melee") var WeaponType: int = 0

@export var equipped: bool = false
@export var equippable: bool = false #DOES NOT APPLY TO SPELLS #moved to the actual equipment base class

@export var cost: int
@export var quantity: int = 1:
	get:
		return _quantity
	set(value):
		if _quantity == value:
			return
		elif value == 0:
			removed.emit()
		_quantity = value
		quantity_changed.emit()
var _quantity: int = 1

@export var model: PackedScene = null
@export var offset: Vector3 = Vector3(0,1,0)

@export var currentModifier: itemModifier = null

@export var stats: Dictionary[StringName, Variant] = {&"damage": 50.0, &"cost": 50, &"cooldown": 1.0}
var backups: Dictionary[StringName, Variant]

func get_proper(property: StringName):
	if get(property) != null:
		return get(property)
	if "[" in property:
		var newP = property.left(property.find("["))
		var index = property.right(property.length()-property.find("["))
		index = index.right(-1)
		index = index.left(-1)
		return get(newP)[index]

func set_proper(property:StringName, Value: Variant):
	if get(property) != null:
		set(property,Value)
	if "[" in property:
		var newP = property.left(property.find("["))
		var index = property.right(property.length()-property.find("["))
		index = index.right(-1)
		index = index.left(-1)
		get(newP)[index] = Value

func applyModifier(modifier: itemModifier):
	_name = name
	name = str(modifier.typename, " ", name)
	
	currentModifier = modifier
	
	for i in modifier.effects:
		backups[i] = get_proper(i)
		set_proper(i,modifier.getvalue(i,self))
		print("set ", i, " to ", get_proper(i))
	
	initializeStats()

func initializeStats():
	pass ## does not really do anything in the case of this particular class. Depends on

func checkAndReverseModifier() -> bool:
	if currentModifier != null:
		name = _name
		for i in backups:
			set_proper(i,backups[i])
		currentModifier = null
		return true
	else:
		return false
