extends Resource

class_name InventoryClass

signal inventoryChanged()

@export var inventory: Array[itemClass]

@export var idHandler: ItemIdHandler

@export var goldItem: gold

func assignIDs():
	if !idHandler:
		idHandler = Globals.idHandler
	#WHY WOULD THIS BE HEREeee
	#idHandler.usedArrays = []
	for i in range(inventory.size()):
		idHandler.give_id(inventory[i])

func checkIndex(which:itemClass):
	var itemIndex
	for shit in range(inventory.size()):
		if inventory[shit].UID == which.UID:
			itemIndex = shit
	return itemIndex

func remove(which:itemClass):
	var itemIndex = checkIndex(which)
	inventory.remove_at(itemIndex)
	print("removed a ", which.name, " at ", itemIndex)
	assignIDs()

func add(which:itemClass):
	for i in inventory:
		if i.itemID == which.itemID:
			print("adding...")
			i.quantity += which.quantity
			inventoryChanged.emit()
			return true
	#this is not called when loading game. OR it is but only once for some strange reason
	inventory.append(which)
	assignIDs()

func getUIDindex(id:int):
	var result = idHandler.usedArrays.find(id)
	return result
