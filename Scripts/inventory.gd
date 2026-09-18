extends GridContainer

@onready var window = get_node("../../../")
@onready var itemNode = preload("res://Scenes/item.tscn")

var dropDownNode: Node

@export var theInventory: InventoryClass

var dragging: bool = false
var draggingNode: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.inventory = self
	Globals.Player.inventory.inventoryChanged.connect(updateInventory)
	Globals.Player.inventory.inventoryChanged.connect(checkColumns)
	await get_tree().create_timer(0.1).timeout
	dropDownNode = Globals.menu.dropdown


func initialize():
	await updateInventory()
	#genuinely evil strat, for some reason it has some weird sorting algorithm thingy so this should fix it. adjust the value if the player would for some reason start out with a huge inventory
	for i in range(1,100):
		await checkColumns()
		window.size = window.custom_minimum_size
		self.size = window.custom_minimum_size

func updateInventory():
	#print("updating inventory")
	flush()
	theInventory = Globals.Player.inventory
	for i in range(theInventory.inventory.size()):
		var temp = itemNode.instantiate()
		self.add_child(temp)
		temp.set_owner(self)
		temp.initialize(theInventory.inventory[i])
		print("added: ", theInventory.inventory[i].name)
		
	#check players inventory, 

func checkColumns():
	var Columns = int(self.size.x / 148)
	self.set_columns(Columns)
	var _tempsizeY = int((theInventory.inventory.size()/2)+1) * 148
	var tempsizeX = int(sqrt(theInventory.inventory.size())+1) * 148
	#print(tempsizeX)
	var minimumsize: Vector2 = Vector2(tempsizeX, tempsizeX + 26)
	window.custom_minimum_size = minimumsize

func flush():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()

func pickup(what: Node):
	if !dragging:
		var pickedItem = what.ownItem
		theInventory.remove(pickedItem)
		self.remove_child(what)
		Globals.menu.add_child(what)
		what.dragging = true
		unequip(what)
		dragging = true
		draggingNode = what
		updateInventory()
		print("picked up a ", what.ownItem.name)

func unequip(what: Node):
	what.ownItem.equipped = false
	what.checkBorder()
	match what.ownItem.Type:
		"Spell":
			Globals.wizard.remove(Globals.wizard.spells.find(what.ownItem.theSpell), false)
			Globals.spellMaster.updateSpells(Globals.wizard.spells)
		_:
			pass
	updateInventory()

func unequipItem(what: itemClass):
	what.equipped = false
	match what.Type:
		"Spell":
			Globals.wizard.remove(Globals.wizard.spells.find(what.theSpell), false)
			Globals.spellMaster.updateSpells(Globals.wizard.spells)
		_:
			pass
	updateInventory()

func _gui_input(event: InputEvent) -> void:
	#checkColumns()
	if event.is_action_pressed("LeftClick"):
		stopDragging()

func stopDragging():
	if dragging:
		var itembackup = draggingNode.ownItem
		draggingNode.queue_free()
		theInventory.add(itembackup)
		updateInventory()
		dragging = false

func getFromUID(id: int):
	return theInventory.inventory[theInventory.getUIDindex(id)]

func GetNode(itemC: itemClass):
	for n in self.get_children():
		if n.ownItem == itemC:
			return n
	return false

func dropDown(nodeinquestion: Node):
	#replace with a neat function
	dropDownNode.show()
	dropDownNode.global_position = get_global_mouse_position()
	dropDownNode.updateItem(nodeinquestion)
