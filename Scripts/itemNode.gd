extends Control

@onready var Icon = $Icon
@onready var equipBorder = $equipBorder
@onready var quantitylabel = $quantity

@export var ownItem: itemClass

@export var dragging: bool = false

var offset = Vector2(5,5)

# Called when the node enters the scene tree for the first time.
func initialize(fart: itemClass):
	#print("initializing item")
	ownItem = fart
	if ownItem.Type == "Spell":
		ownItem.theSpell.quantity_changed.connect(update)
	else:
		ownItem.quantity_changed.connect(update)
	Icon.texture = fart.icon
	checkBorder()
	update()

func update():
	if ownItem.Type == "Spell":
		ownItem.quantity = ownItem.theSpell.quantity
	if ownItem.quantity != 0:
		quantitylabel.text = str(ownItem.quantity)
	else:
		quantitylabel.text = ""

func checkBorder():
	match ownItem.equipped:
		true:
			#print("checkced border, equipped")
			equipBorder.show()
		false:
			#print("checked border, unequipped")
			equipBorder.hide()

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		print("clicked")
		self.get_parent().pickup(self)
	if event.is_action_pressed("rightClick"):
		self.get_parent().dropDown(self)

func _process(_delta: float) -> void:
	if dragging:
		self.global_position = get_global_mouse_position()+offset
