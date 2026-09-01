extends Control

@export var currentItem: Node

func close():
	self.hide()

#assigning section
func assignSpell(which: int):
	var itemInQ = currentItem.ownItem
	if itemInQ.Type == "Spell":
		if Globals.wizard.spells.has(itemInQ.theSpell):
			#oh my god
			Globals.wizard.remove(Globals.wizard.spells.find(itemInQ.theSpell))
		Globals.wizard.spells[which] = itemInQ.theSpell
		Globals.spellMaster.updateSpells(Globals.wizard.spells)

func _on_assign_1_pressed() -> void:
	assignSpell(0)
	close()


func _on_assign_2_pressed() -> void:
	assignSpell(1)
	close()


func _on_assign_3_pressed() -> void:
	assignSpell(2)
	close()


func _on_assign_4_pressed() -> void:
	assignSpell(3)
	close()


func _on_assign_5_pressed() -> void:
	assignSpell(4)
	close()

#etcetera

func _on_close_pressed() -> void:
	close()
