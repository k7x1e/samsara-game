extends itemClass

class_name gold

signal gold_changed

@export var initialized: bool = false

func initialize():
	#initialized = true
	Globals.goldItem = self
	Globals.Player.goldamt = quantity
	Globals.Player.initializeGold()

func removeGold(amount: int):
	quantity -= amount
	gold_changed.emit()

func addGold(amount:int):
	quantity += amount
	gold_changed.emit()
