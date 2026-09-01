extends Control

@onready var equipB = $VBoxContainer/equip

@onready var assign1 = $VBoxContainer/assign1
@onready var assign2 = $VBoxContainer/assign2
@onready var assign3 = $VBoxContainer/assign3
@onready var assign4 = $VBoxContainer/assign4
@onready var assign5 = $VBoxContainer/assign5

@export var currentItem: Node

func updateItem(iteminQ: Node):
	currentItem = iteminQ
	var tempitem = currentItem.ownItem
	match tempitem.Type:
		"Spell":
			equipB.disabled = true
			assign1.disabled = false
			assign2.disabled = false
			assign3.disabled = false
			assign4.disabled = false
			assign5.disabled = false
		"Item":
			equipB.disabled = true
			assign1.disabled = true
			assign2.disabled = true
			assign3.disabled = true
			assign4.disabled = true
			assign5.disabled = true

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
		itemInQ.equipped = true
		currentItem.checkBorder()

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


func _on_discard_pressed() -> void:
	Globals.Player.inventory.remove(currentItem.ownItem)
	Globals.inventory.updateInventory()
	close()
