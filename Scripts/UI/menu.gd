extends Node

@onready var menu = $Menu

@onready var dropdown = $Menu/DropDown

func _ready() -> void:
	Globals.menu = self

func activateMenu():
	pass

func hideMenu():
	pass
