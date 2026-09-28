extends Resource

class_name InventoryClass

signal inventoryChanged()

@export var inventory: Array[itemClass]

@export var idHandler: ItemIdHandler

@export var goldItem: gold

func assignIDs():
	if !idHandler:
		idHandler = Globals.idHandler
	idHandler.usedArrays = []
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
	#this is not called when loading game. OR it is but only once for some strange reason
	inventory.append(which)
	assignIDs()
	inventoryChanged.emit()

func getUIDindex(id:int):
	return idHandler.usedArrays.find(id)
