extends Node3D

class_name physicsItem

@onready var sprite: Sprite3D = $sprite
@onready var nameLabel: RichTextLabel = $SubViewport/CanvasLayer/CenterContainer/RichTextLabel
@onready var nameSprite: Sprite3D = $Sprite3D

@export var ownItem: itemClass

@export var nearPlayer: bool = false

var ownModel: Node

func initialize():
	checkModel()
	updateText()

func updateText():
	var tempStr := ""
	if ownItem.quantity != 0:
		tempStr = str(ownItem.quantity, " ")
	tempStr += ownItem.name
	
	nameLabel.text = tempStr

func checkModel():
	if ownItem.model != null:
		ownModel = ownItem.model.instantiate()
		self.add_child(ownModel)
		ownModel.set_owner(self)
		ownModel.position += ownItem.offset
		sprite.hide()
	else:
		sprite.show()
		sprite.texture = ownItem.icon

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and nearPlayer:
		Globals.Player.inventory.add(ownItem)
		Globals.Player.notify(str("Picked up a ", ownItem.name))
		Globals.inventory.updateInventory()
		self.queue_free()

func body_entered(body: Node3D) -> void:
	nearPlayer = true
	nameSprite.show()

func body_exited(body: Node3D) -> void:
	nearPlayer = false
	nameSprite.hide()
