extends Control

signal added
signal removed

@export var ownItem: Variant

@onready var itemNode: PackedScene = preload("res://Scenes/item.tscn")

var dragging := false
var temp

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick") and Globals.inventory.dragging:
		ownItem = Globals.inventory.draggingNode.ownItem
		Globals.inventory.stopDragging(false)
		addItem()

func pickup(what: Node):
	temp.reparent(Globals.menu)
	Globals.inventory.pickup(what, false)
	removed.emit()

func addItem():
	temp = null
	temp = itemNode.instantiate()
	self.add_child(temp)
	temp.set_owner(Globals.menu)
	temp.initialize(ownItem)
	added.emit()
