extends Node

@onready var menu = $Menu

@onready var dropdown = $Menu/DropDown

@export var isGlobal: bool = true
@export var globalName: StringName = "menu"


func _ready() -> void:
	Globals.menu = self

func activateMenu():
	pass

func hideMenu():
	pass


func _on_agility_mouse_entered() -> void:
	pass # Replace with function body.
