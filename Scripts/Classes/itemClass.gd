extends Resource

class_name itemClass

signal quantity_changed()

#THIS IS IMPORTANT EVERY SINGLE ITEM HAS TO BE UNIQUE OTHERWISE IT WILL INTRODUCE INSANE GLITCHES
@export var itemID: int #mostly for tracking purposes
@export var UID: int = 0 #AT NO POINT CAN THIS MATCH ANY OTHER ID EVER USED

@export var name: String
@export var description: String
@export var icon: Texture

@export var Type: String = "Item"

@export var equipped: bool = false
@export var equippable: bool = false #DOES NOT APPLY TO SPELLS #moved to the actual equipment base class

@export var quantity: int:
	set(value):
		quantity = value
		emit_signal('quantity_changed')
