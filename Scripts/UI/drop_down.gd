extends Control

@onready var equipB = $VBoxContainer/equip
@onready var unEquipB = $VBoxContainer/unequip

@onready var assign1 = $VBoxContainer/assign1
@onready var assign2 = $VBoxContainer/assign2
@onready var assign3 = $VBoxContainer/assign3
@onready var assign4 = $VBoxContainer/assign4
@onready var assign5 = $VBoxContainer/assign5
@onready var unassign = $VBoxContainer/unassign

@export var currentItem: Node

func updateItem(iteminQ: Node):
	currentItem = iteminQ
	var tempitem = currentItem.ownItem
	match tempitem.Type:
		"Spell":
			equipButtons(true)
			assignButtons(false)
		"Item":
			equipButtons(true)
			assignButtons(true)
	if tempitem.equippable:
		equipButtons(false)
	if tempitem.equipped and tempitem.equippable:
		unEquipB.disabled = false
			
func equipButtons(disableD: bool):
	equipB.disabled = disableD
	unEquipB.disabled = true

func assignButtons(disableD: bool):
	assign1.disabled = disableD
	assign2.disabled = disableD
	assign3.disabled = disableD
	assign4.disabled = disableD
	assign5.disabled = disableD
	unassign.disabled = disableD

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

func _on_unassign_pressed() -> void:
	Globals.inventory.unequip(currentItem)
	close()

#equipping

func _on_equip_pressed() -> void:
	pass # Replace with function body.

func _on_unequip_pressed() -> void:
	pass # Replace with function body.

#etcetera

func _on_close_pressed() -> void:
	close()


func _on_discard_pressed() -> void:
	Globals.Player.inventory.remove(currentItem.ownItem)
	Globals.inventory.updateInventory()
	close()
