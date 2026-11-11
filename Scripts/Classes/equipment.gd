extends Resource

class_name EquipmentManager

signal updated

@export var slots: Dictionary[String, Variant] = {
	"armLeft":null,
	"armRight":null,
	#armor wont be implemented for a while
	}

func checkHands(item:itemClass) -> bool:
	var hands := 0
	if "armLeft" in item.slot:
		hands += 1
	if "armRight" in item.slot:
		hands += 1
	if hands == 2:
		return true
	return false

func equip(item: itemClass):
	if summarizeResult(checkSlots(item.slot)):
		print("succesfully equipped")
		for i in item.slot:
			slots[i] = item
		item.equipped = true
		updated.emit()
		var twohanded = checkHands(item)
		Globals.Player.animManager.playEquipAnim(item.associatedAnimation, false, twohanded)
		item.initializeItem()
		return true
	else:
		return false

func unequip(item: itemClass):
	if !summarizeResult(checkSlots(item.slot)):
		for i in item.slot:
			if slots[i] != item:
				return false
		print("unequipping")
		for i in item.slot:
			slots[i] = null
		item.equipped = false
		Globals.Player.animManager.playEquipAnim("Start", true)
		item.unequip()
		item.curNode.queue_free()
		updated.emit()
		return true
	else:
		return false

func summarizeResult(todo: Array[bool]): ##input result of checkSlots. If all are false return false if all are true return true.
	#previous approach was stupid.
	for i in todo:
		if !i:
			return false
	return true

func checkSlots(slotsToCheck: Array[String]): ## true means available, if input is only one then output is just a bool
	var result: Array[bool] = []
	for i in slotsToCheck:
		if slots[i] == null:
			result.append(true)
		else:
			result.append(false)
	#depreceated
	#if result.size() == 1:
	#	return result[0]
	return result
