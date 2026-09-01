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
	await get_tree().create_timer(0.01).timeout
	dropDownNode = Globals.menu.dropdown


func initialize():
	await updateInventory()
	await checkColumns()

func updateInventory():
	print("updating inventory")
	flush()
	theInventory = Globals.Player.inventory
	for i in range(theInventory.inventory.size()):
		var temp = itemNode.instantiate()
		self.add_child(temp)
		temp.set_owner(self)
		temp.initialize(theInventory.inventory[i])
		
	#check players inventory, 

func checkColumns():
	var columns = int(self.size.x / 148)
	self.columns = columns
	var tempsize = int((theInventory.inventory.size()/2)+1) * 148
	var minimumsize: Vector2 = Vector2(296, tempsize + 26)
	window.custom_minimum_size = minimumsize

func flush():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()

func pickup(what: Node):
	var pickedItem = what.ownItem
	theInventory.remove(pickedItem)
	remove_child(what)
	Globals.menu.add_child(what)
	what.dragging = true
	pickedItem.equipped = false
	dragging = true
	draggingNode = what
	updateInventory()
	print("picked up a ", what.ownItem.name)

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		stopDragging()

func stopDragging():
	if dragging:
		var itembackup = draggingNode.ownItem
		draggingNode.queue_free()
		theInventory.add(itembackup)
		updateInventory()
		dragging = false

func dropDown(nodeinquestion: Node):
	#replace with a neat function
	dropDownNode.show()
	dropDownNode.global_position = get_global_mouse_position()
	dropDownNode.currentItem = nodeinquestion
