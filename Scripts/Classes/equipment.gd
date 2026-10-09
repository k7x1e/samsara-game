extends Resource

class_name EquipmentManager

signal updated

@export var slots: Dictionary[String, itemClass] = {
	"armLeft":null,
	"armRight":null,
	#armor wont be implemented for a while
	}


func equip(item: itemClass):
	if checkSlots([item.slot]):
		print("succesfully equipped")
		slots[item.slot] = item
		item.equipped = true
		updated.emit()
		Globals.Player.animManager.playEquipAnim(item.associatedAnimation)
		item.initializeItem()
		return true
	else:
		print(slots[item.slot].name)
		return false

func unequip(item: itemClass):
	print(checkSlots([item.slot]), slots[item.slot].name)
	if !checkSlots([item.slot]) and slots[item.slot] == item:
		slots[item.slot] = null
		item.equipped = false
		Globals.Player.animManager.playEquipAnim("Start", true)
		item.unequip()
		item.curNode.queue_free()
		updated.emit()
		return true
	else:
		return false

func checkSlots(slotsToCheck: Array[String]): ## true means available, if input is only one then output is just a bool
	var result: Array[bool] = []
	for i in slotsToCheck:
		if slots[i] == null:
			result.append(true)
		else:
			result.append(false)
	if result.size() == 1:
		return result[0]
	else:
		return result
