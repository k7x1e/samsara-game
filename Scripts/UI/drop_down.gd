extends Control

@onready var useB = $VBoxContainer/use

@onready var equipB = $VBoxContainer/equip
@onready var unEquipB = $VBoxContainer/unequip

@onready var assign1 = $VBoxContainer/assign1
@onready var assign2 = $VBoxContainer/assign2
@onready var assign3 = $VBoxContainer/assign3
@onready var assign4 = $VBoxContainer/assign4
@onready var assign5 = $VBoxContainer/assign5
@onready var unassign = $VBoxContainer/unassign

@onready var nameLabel = $VBoxContainer/Name

@export var currentItem: Node

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("LeftClick"):
		if !get_global_rect().has_point(event.global_position):
			self.close()

func updateItem(iteminQ: Node):
	currentItem = iteminQ
	var tempitem: itemClass = currentItem.ownItem
	nameLabel.text = tempitem.name
	match tempitem.Type:
		0:
			equipButtons(true)
			assignButtons(true)
			useB.disabled = true
		1:
			equipButtons(true)
			assignButtons(false)
			useB.disabled = true
		2:
			equipButtons(false)
			assignButtons(true)
			useB.disabled = true
		3:
			equipButtons(true)
			assignButtons(false)
			useB.disabled = false
		_:
			equipButtons(true)
			assignButtons(true)
			useB.disabled = true
	if tempitem.equippable:
		equipButtons(false, tempitem.equipped)
	if tempitem.equipped and tempitem.equippable:
		unEquipB.disabled = false
			
func equipButtons(disableD: bool, isEquipped: bool = false):
	equipB.disabled = disableD
	unEquipB.disabled = !isEquipped

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
	if itemInQ.isSpell:
		if Globals.wizard.spells.has(itemInQ.theSpell):
			#oh my god
			#for some bumfuck reason certain spells(healing spell) believe they are other spells (thunderbolt)
			print("moving, IE this one already exists here")
			Globals.inventory.unequipItem(itemInQ)
			Globals.wizard.remove(Globals.wizard.spells.find(itemInQ.theSpell), false)
		if Globals.wizard.spells[which] != Globals.wizard.placeholderSpell:
			if !Globals.wizard.spells[which].priority:
				print("replacing")
				Globals.wizard.remove(which, true)
			else:
				print("couldnt, had priority.")
				return false
		Globals.wizard.spells[which] = itemInQ.theSpell
		itemInQ.equipped = true
		Globals.inventory.updateInventory()
		Globals.spellMaster.updateSpells(Globals.wizard.spells)
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
	var result = Globals.Player.equipment.equip(currentItem.ownItem)
	if result == false:
		Globals.Player.notify("Failed to equip. One or more required slots are full.")
	else:
		Globals.Player.notify(str("Equipped ", currentItem.ownItem.name, "."))

func _on_unequip_pressed() -> void:
	var result = Globals.Player.equipment.unequip(currentItem.ownItem)
	if result == false:
		Globals.Player.notify("Failed to unequip. Item not equipped.")
	else:
		Globals.Player.notify(str("Unequipped ", currentItem.ownItem.name, "."))

#etcetera

func _on_close_pressed() -> void:
	close()


func _on_discard_pressed() -> void:
	Globals.Root.placeItem(currentItem.ownItem, Globals.Player.global_position)
	Globals.Player.inventory.remove(currentItem.ownItem)
	Globals.inventory.updateInventory()
	close()


func _on_use_pressed() -> void:
	currentItem.ownItem.theSpell.cast(self, true)
