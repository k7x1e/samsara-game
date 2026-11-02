@tool
extends Node3D

class_name physicsItem

@onready var sprite: Sprite3D = $visual/sprite
@onready var nameLabel: RichTextLabel = $SubViewport/CanvasLayer/CenterContainer/RichTextLabel
@onready var nameSprite: Sprite3D = $Sprite3D
@onready var visual: Node3D = $visual
@onready var anim: AnimationPlayer = $anim

@export var ownItem: itemClass

@export var nearPlayer: bool = false

@export var spawned: bool = false

var ownModel: Node
var notpickedup: bool = true

func _ready() -> void:
	if spawned:
		initialize()

func initialize():
	print("initializing")
	checkModel()
	updateText()
	if !spawned:
		anim.play("drop")

func updateText():
	var tempStr := ""
	if ownItem.quantity != 0:
		tempStr = str(ownItem.quantity, " ")
	tempStr += ownItem.name
	
	nameLabel.text = tempStr

func checkModel():
	if ownItem.model != null:
		ownModel = ownItem.model.instantiate()
		visual.add_child(ownModel)
		ownModel.set_owner(self)
		ownModel.position += ownItem.offset
		sprite.hide()
	else:
		sprite.show()
		sprite.texture = ownItem.icon

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and nearPlayer and notpickedup:
		notpickedup = false
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
