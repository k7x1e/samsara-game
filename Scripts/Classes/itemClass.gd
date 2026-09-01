extends Resource

#THIS IS IMPORTANT EVERY SINGLE ITEM HAS TO BE UNIQUE OTHERWISE IT WILL INTRODUCE INSANE GLITCHES
class_name itemClass

@export var itemID: int #mostly for tracking purposes
@export var UID: int = 0 #AT NO POINT CAN THIS MATCH ANY OTHER ID EVER USED

@export var name: String
@export var description: String
@export var icon: Texture

@export var Type: String = "Item"

@export var equipped: bool
@export var equippable: bool = false #DOES NOT APPLY TO SPELLS
